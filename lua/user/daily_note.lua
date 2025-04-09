
-- ~/.config/nvim/lua/user/daily_note.lua
local M = {}

M.open_daily_note = function()
  -- Windows環境の場合、%USERPROFILE%を使用。必要に応じてHOMEなどに変更してください。
  local base_dir = os.getenv("USERPROFILE") .. "/Dropbox/obsidian/myvault"
  local vault_dir = base_dir .. "/dailynotes"
  local year = os.date("%Y")
  local today = os.date("%Y-%m-%d")
  local note_file = vault_dir .. "/" .. year .. "/" .. today .. ".md"
  local template_file = base_dir .. "/template/dailynote_nvim_template.md"

  -- ファイルが存在しない場合、テンプレートファイルを読み込んで新規作成する
  if vim.fn.filereadable(note_file) == 0 then
    if vim.fn.filereadable(template_file) == 1 then
      local lines = vim.fn.readfile(template_file)
      -- テンプレート内の{{date:YYYY-MM}}を現在の年月に置換
      for i, line in ipairs(lines) do
        lines[i] = line:gsub("{{date:YYYY%-MM}}", os.date("%Y-%m"))
      end
      vim.fn.writefile(lines, note_file)
    else
      -- テンプレートがない場合は空ファイルとして作成
      vim.fn.writefile({}, note_file)
    end
  end

  -- ファイルを編集モードで開く
  vim.cmd("edit " .. note_file)
end

return M
