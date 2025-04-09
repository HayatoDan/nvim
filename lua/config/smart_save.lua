-- スマート保存機能（未保存ファイルは補完付きプロンプトでファイル名を指定）
local function smart_save()
  local bufname = vim.api.nvim_buf_get_name(0)
  local readable = vim.fn.filereadable(bufname) == 1

  if bufname ~= "" and readable then
    vim.cmd("write")
  else
    -- 現在のバッファのディレクトリを取得（空ならカレントディレクトリ）
    local default_dir = vim.fn.expand('%:p:h')
    if default_dir == "" then
      default_dir = vim.fn.getcwd()
    end

    -- 入力セーフティ開始
    vim.fn.inputsave()
    local fname = vim.fn.input("Save as ...: ", default_dir .. "/", "file")
    vim.fn.inputrestore()

    if fname ~= "" then
      vim.cmd("write " .. fname)
    else
      print("Save canceled")
    end
  end
end

-- Ctrl+S にマッピング（ノーマル／インサート両対応）
vim.keymap.set({ "n", "i" }, "<C-s>", function()
  if vim.fn.mode() == "i" then
    vim.cmd("stopinsert")
    vim.schedule(smart_save)
  else
    smart_save()
  end
end, { noremap = true, silent = true })
