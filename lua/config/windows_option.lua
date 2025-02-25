vim.o.fileformats = 'dos', 'unix', 'mac'


-- 引数なしで起動したときは指定のフォルダを開く
local default_dir = os.getenv("USERPROFILE") .. "/Dropbox/obsidian/myvault"
local bufinfoargs = {}
bufinfoargs['buflisted'] = 1
local bufinfo = vim.fn.getbufinfo(bufinfoargs)

if (#bufinfo == 1 and bufinfo[1]["name"] == '') then
  vim.cmd("cd " .. default_dir)
--   vim.cmd("e " .. default_dir)
end


-- Daily Note 用の関数をグローバルに定義
_G.open_daily_note = function()
    -- Windows環境の場合、%USERPROFILE%を使用。必要に応じてHOMEなどに変更してください。
    local vault_dir = os.getenv("USERPROFILE") .. "/Dropbox/obsidian/myvault/dailynotes"
    local today = os.date("%Y-%m-%d")
    local note_file = vault_dir .. "/" .. today .. ".md"
    local template_file = vault_dir .. "/template.md"

    -- ファイルが存在しない場合、テンプレートファイルを読み込んで新規作成する
    if vim.fn.filereadable(note_file) == 0 then
      if vim.fn.filereadable(template_file) == 1 then
        local lines = vim.fn.readfile(template_file)
        vim.fn.writefile(lines, note_file)
      else
        -- テンプレートがない場合は空ファイルとして作成
        vim.fn.writefile({}, note_file)
      end
    end
    -- ファイルを編集モードで開く
    vim.cmd("edit " .. note_file)
  end