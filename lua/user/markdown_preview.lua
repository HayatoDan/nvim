
-- lua/user/markdown_preview.lua
local M = {}
local uv = vim.loop
local preview_html = ""
local server_started = false
M.port = 8080  -- デフォルトのポート番号
M.server = nil  -- サーバーオブジェクトを保持するための変数

-----------------------------------------------------------
-- インライン要素のパース（太字、斜体、コード、リンク等）
-----------------------------------------------------------
local function parse_inline(text)
  -- インラインコード（バッククォートで囲む）
  text = text:gsub("`([^`]+)`", "<code>%1</code>")
  -- 太字 (**text** または __text__)
  text = text:gsub("%*%*(.-)%*%*", "<strong>%1</strong>")
  text = text:gsub("__(.-)__", "<strong>%1</strong>")
  -- 斜体 (*text* または _text_)
  text = text:gsub("%*(.-)%*", "<em>%1</em>")
  text = text:gsub("_(.-)_", "<em>%1</em>")
  -- リンク [テキスト](URL)
  text = text:gsub("%[([^%]]+)%]%(([^%)]+)%)", '<a href="%2">%1</a>')
  return text
end

-----------------------------------------------------------
-- ブロック要素のパース
-----------------------------------------------------------
local function parse_blocks(lines)
  local output = {}
  local in_code_block = false
  local code_lines = {}
  local paragraph_buffer = {}
  local list_buffer = {}
  local in_list = false
  local list_type = nil
  local blockquote_buffer = {}
  local in_blockquote = false

  local function flush_paragraph()
    if #paragraph_buffer > 0 then
      local paragraph_text = table.concat(paragraph_buffer, " ")
      paragraph_text = parse_inline(paragraph_text)
      table.insert(output, "<p>" .. paragraph_text .. "</p>")
      paragraph_buffer = {}
    end
  end

  local function flush_list()
    if #list_buffer > 0 then
      local list_html = {}
      table.insert(list_html, "<" .. list_type .. ">")
      for _, item in ipairs(list_buffer) do
        item = parse_inline(item)
        table.insert(list_html, "<li>" .. item .. "</li>")
      end
      table.insert(list_html, "</" .. list_type .. ">")
      table.insert(output, table.concat(list_html, "\n"))
      list_buffer = {}
      in_list = false
      list_type = nil
    end
  end

  local function flush_blockquote()
    if #blockquote_buffer > 0 then
      local bq_text = table.concat(blockquote_buffer, " ")
      bq_text = parse_inline(bq_text)
      table.insert(output, "<blockquote>" .. bq_text .. "</blockquote>")
      blockquote_buffer = {}
      in_blockquote = false
    end
  end

  for _, line in ipairs(lines) do
    if line:match("^```") then
      flush_paragraph()
      flush_list()
      flush_blockquote()
      if in_code_block then
        -- コードブロック終了
        table.insert(output, "<pre><code>" .. table.concat(code_lines, "\n") .. "</code></pre>")
        in_code_block = false
        code_lines = {}
      else
        in_code_block = true
      end
    elseif in_code_block then
      table.insert(code_lines, line)
    elseif line:match("^%s*$") then
      -- 空行で各バッファをフラッシュ
      flush_paragraph()
      flush_list()
      flush_blockquote()
    elseif line:match("^(%-%-%-+)%s*$") or line:match("^(%*%*%*+)%s*$") or line:match("^(___+)%s*$") then
      flush_paragraph()
      flush_list()
      flush_blockquote()
      table.insert(output, "<hr/>")
    elseif line:match("^#+%s") then
      flush_paragraph()
      flush_list()
      flush_blockquote()
      local hashes, content = line:match("^(#+)%s+(.*)")
      local level = #hashes
      content = parse_inline(content)
      table.insert(output, string.format("<h%d>%s</h%d>", level, content, level))
    elseif line:match("^>") then
      flush_paragraph()
      flush_list()
      in_blockquote = true
      local content = line:gsub("^>%s*", "")
      table.insert(blockquote_buffer, content)
    elseif line:match("^[%*%-]%s+") then
      flush_paragraph()
      flush_blockquote()
      in_list = true
      list_type = "ul"
      local content = line:gsub("^[%*%-]%s+", "")
      table.insert(list_buffer, content)
    elseif line:match("^%d+%.%s+") then
      flush_paragraph()
      flush_blockquote()
      in_list = true
      list_type = "ol"
      local content = line:gsub("^%d+%.%s+", "")
      table.insert(list_buffer, content)
    else
      flush_list()
      flush_blockquote()
      table.insert(paragraph_buffer, line)
    end
  end

  flush_paragraph()
  flush_list()
  flush_blockquote()
  if in_code_block then
    table.insert(output, "<pre><code>" .. table.concat(code_lines, "\n") .. "</code></pre>")
  end
  return table.concat(output, "\n")
end

-- Markdown 全体を HTML にレンダリング
local function render_markdown(lines)
  return parse_blocks(lines)
end

-----------------------------------------------------------
-- プレビュー更新処理（カーソル位置に応じたスクロール情報も埋め込む）
-----------------------------------------------------------
function M.update_preview()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local rendered = render_markdown(lines)
  local total_lines = #lines
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local scroll_percent = 0
  if total_lines > 0 then
    scroll_percent = (cursor_line - 1) / total_lines
  end
  preview_html = '<div data-scroll="' .. scroll_percent .. '">\n' .. rendered .. "\n</div>"
end

-----------------------------------------------------------
-- HTTP レスポンス送信・リクエスト処理
-----------------------------------------------------------
local function send_response(client, code, body)
  local reasons = { [200] = "OK", [404] = "Not Found", [405] = "Method Not Allowed", [400] = "Bad Request" }
  local response = "HTTP/1.1 " .. code .. " " .. (reasons[code] or "") .. "\r\n" ..
                   "Content-Type: text/html; charset=utf-8\r\n" ..
                   "Content-Length: " .. tostring(#body) .. "\r\n" ..
                   "Connection: close\r\n\r\n" ..
                   body
  client:write(response)
  client:shutdown()
  client:close()
end

local function parse_request(data)
  local request_line = data:match("^(.-)\r\n")
  if not request_line then return nil end
  local method, path = request_line:match("^(%S+)%s+(%S+)")
  return { method = method, path = path }
end

local function on_request(req, client)
  if req.method == "GET" then
    if req.path == "/" then
      local page = [[
<html>
<head>
  <meta charset="utf-8">
  <title>Markdown Preview</title>
  <style>
    body { font-family: sans-serif; margin: 20px; }
  </style>
</head>
<body>
  <div id="preview"></div>
  <script>
    function fetchPreview() {
      var xhr = new XMLHttpRequest();
      xhr.onreadystatechange = function() {
        if(xhr.readyState === 4 && xhr.status === 200) {
          document.getElementById('preview').innerHTML = xhr.responseText;
          var container = document.getElementById('preview');
          var scroll = container.getAttribute('data-scroll');
          if(scroll) {
            var scrollPercent = parseFloat(scroll);
            var scrollY = (document.body.scrollHeight - window.innerHeight) * scrollPercent;
            window.scrollTo(0, scrollY);
          }
        }
      };
      xhr.open('GET', '/preview', true);
      xhr.send();
    }
    setInterval(fetchPreview, 200);
    fetchPreview();
  </script>
</body>
</html>
]]
      send_response(client, 200, page)
    elseif req.path == "/preview" then
      send_response(client, 200, preview_html)
    else
      send_response(client, 404, "Not Found")
    end
  else
    send_response(client, 405, "Method Not Allowed")
  end
end

-----------------------------------------------------------
-- HTTP サーバーの起動
-----------------------------------------------------------
function M.start_server(port)
  port = port or M.port
  if server_started then return end
  local server = uv.new_tcp()
  M.server = server  -- サーバーオブジェクトを保存
  server:bind("127.0.0.1", port)
  server:listen(128, function(err)
    assert(not err, err)
    local client = uv.new_tcp()
    server:accept(client)
    client:read_start(function(err, chunk)
      if err then return end
      if chunk then
        local req = parse_request(chunk)
        if req then
          on_request(req, client)
        else
          send_response(client, 400, "Bad Request")
        end
        client:read_stop()
      end
    end)
  end)
  server_started = true
  print("Markdown Preview サーバー起動: http://127.0.0.1:" .. port)
end

-----------------------------------------------------------
-- サーバー停止処理
-----------------------------------------------------------
function M.stop_server()
  if server_started and M.server then
    M.server:close()
    M.server = nil
    server_started = false
    vim.cmd([[
      augroup MarkdownPreview
        autocmd!
      augroup END
    ]])
    print("Markdown Preview サーバーを停止しました。")
  else
    print("Markdown Preview サーバーは起動していません。")
  end
end

-----------------------------------------------------------
-- サーバーの起動／停止をトグルする処理
-----------------------------------------------------------
function M.toggle_preview()
  if server_started then
    M.stop_server()
  else
    M.start_server()
    -- プレビュー自動更新用のオートコマンドも設定
    vim.cmd([[
      augroup MarkdownPreview
        autocmd!
        autocmd BufEnter,BufWritePost,TextChanged,CursorMoved *.md lua require("user.markdown_preview").update_preview()
      augroup END
    ]])
    print("Markdown Preview を開始しました。ブラウザで http://127.0.0.1:" .. M.port .. " を開いてください。")
  end
end

-----------------------------------------------------------
-- 初期化関数（コマンド定義のみ）
----------------------
function M.setup(opts)
  opts = opts or {}
  M.port = opts.port or M.port
  -- コマンド定義
  vim.cmd("command! MarkdownPreview lua require('user.markdown_preview').start_preview()")
  vim.cmd("command! MarkdownPreviewStop lua require('user.markdown_preview').stop_server()")
  vim.cmd("command! MarkdownPreviewToggle lua require('user.markdown_preview').toggle_preview()")
  
  -- keymap 設定（opts.keymaps で上書き可能）
  local keymaps = opts.keymaps or {
      toggle = "<leader>mp",
      start  = "<leader>ms",
      stop   = "<leader>mq",
  }
  vim.api.nvim_set_keymap('n', keymaps.toggle, ':MarkdownPreviewToggle<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', keymaps.start,  ':MarkdownPreview<CR>',       { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', keymaps.stop,   ':MarkdownPreviewStop<CR>',   { noremap = true, silent = true })
end

return M-------------------------------------