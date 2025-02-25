
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

    -- 基本のボタン群
    dashboard.section.buttons.val = {
      dashboard.button("e", "New file", ":ene <BAR> startinsert<CR>"),
      dashboard.button("f", "Find file", ":Telescope find_files<CR>"),
      dashboard.button("r", "Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("q", "Quit", ":qa<CR>")
    }

    -- Windows上でのみ Daily Note ボタンを追加
    if vim.loop.os_uname().sysname:find("Windows") then
      table.insert(
        dashboard.section.buttons.val,
        4,  -- 好みの位置に挿入（ここでは「Quit」ボタンの前に追加）
        dashboard.button("d", "Daily Note", ":lua require('user.daily_note').open_daily_note()<CR>")
      )
    end

    dashboard.section.footer.val = "Have a nice coding session!"

    alpha.setup(dashboard.config)
  end
}