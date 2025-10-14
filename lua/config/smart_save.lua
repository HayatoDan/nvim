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

    -- コマンドラインモードでのファイル補完用キーマッピングを一時的に設定
    -- 上下: 同一ディレクトリ内移動、左右: 親/子ディレクトリ移動
    vim.keymap.set('c', '<Up>', '<Left>', { noremap = true })
    vim.keymap.set('c', '<Down>', '<Right>', { noremap = true })
    vim.keymap.set('c', '<Left>', '<Up>', { noremap = true })
    vim.keymap.set('c', '<Right>', '<Down>', { noremap = true })

    -- 入力セーフティ開始
    vim.fn.inputsave()
    local fname = vim.fn.input("Save as ...: ", default_dir .. "/", "file")
    vim.fn.inputrestore()

    -- マッピングを元に戻す
    vim.keymap.del('c', '<Up>')
    vim.keymap.del('c', '<Down>')
    vim.keymap.del('c', '<Left>')
    vim.keymap.del('c', '<Right>')

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
