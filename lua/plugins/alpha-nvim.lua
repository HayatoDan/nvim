local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map('n', '<leader>H', '<Cmd>Alpha<CR>', opts)

return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'lambdalisue/fern.vim',
  },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local daily_note = require("user.daily_note")

    dashboard.section.header.val = {
      "Welcome to Neovim!"
    }

    dashboard.section.buttons.val = {
      dashboard.button("e", "New file", ":ene <BAR> startinsert<CR>"),
      dashboard.button("f", "Find file", ":Telescope find_files<CR>"),
      dashboard.button("r", "Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("q", "Quit", ":qa<CR>")
    }

    -- Windows上のみ Daily Note ボタンを追加（"Quit" の前に挿入）
    if vim.loop.os_uname().sysname:find("Windows") then
      table.insert(
        dashboard.section.buttons.val,
        4,
        dashboard.button("d", "Daily Note", ":lua require('user.daily_note').open_daily_note()<CR>")
      )
    end

    dashboard.section.footer.val = "Have a nice coding session!"

    alpha.setup(dashboard.config)
  end
}
