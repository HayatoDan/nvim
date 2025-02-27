local function selectionCount()
    local mode = vim.fn.mode()
    local start_line, end_line, start_pos, end_pos

    -- 選択モードでない場合には無効
    if not (mode:find("[vV\22]") ~= nil) then return "" end
    start_line = vim.fn.line("v")
    end_line = vim.fn.line(".")

    if mode == 'V' then
        -- 行選択モードの場合は、各行全体をカウントする
        start_pos = 1
        end_pos = vim.fn.strlen(vim.fn.getline(end_line)) + 1
    else
        start_pos = vim.fn.col("v")
        end_pos = vim.fn.col(".")
    end

    -- 開始位置と終了位置を正しく並び替える（逆方向選択対策）
    if start_line > end_line then
        start_line, end_line = end_line, start_line
        start_pos, end_pos = end_pos, start_pos
    elseif start_line == end_line and start_pos > end_pos then
        start_pos, end_pos = end_pos, start_pos
    end

    local chars = 0
    for i = start_line, end_line do
        local line = vim.fn.getline(i)
        local line_len = vim.fn.strlen(line)
        local s_pos = (i == start_line) and start_pos or 1
        local e_pos = (i == end_line) and end_pos or line_len + 1
        local selected_text = line:sub(s_pos, e_pos )

        -- 半角スペースと全角スペースを削除
        selected_text = vim.fn.substitute(selected_text, "[ 　]", "", "g")

        chars = chars + vim.fn.strchars(selected_text)
    end

    local lines = math.abs(end_line - start_line) + 1
    return tostring(lines) .. " lines, " .. tostring(chars) .. " characters"
end

return {
  'nvim-lualine/lualine.nvim',
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto",       -- Nightfly カラースキーム
      section_separators = '',    -- セクションの区切りをなしに
      component_separators = '|', -- コンポーネントの区切りをテキストに
      globalstatus = true,        -- グローバルステータスラインを有効に
      icons_enabled = false,      -- アイコンを無効化
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {selectionCount},
      lualine_y = {'encoding', 'fileformat', 'filetype'},
      lualine_z = {},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {}
  },
  config = function(_, opts)
    require('lualine').setup(opts)
  end,
}
