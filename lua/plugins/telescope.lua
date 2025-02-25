return {
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', lazy = false},
    keys = {
      -- <leader>tt を押すと Telescopeを起動
      { "<leader>tt", "<cmd>Telescope<CR>", desc = "Telescope起動" },
      -- <leader>tk を押すと Telescopeを起動
      { "<leader>tk", "<cmd>Telescope keymaps<CR>", desc = "Telescope keymaps起動" },
      -- <leader>tf を押すと Telescopeを起動
      { "<leader>tf", "<cmd>Telescope find_files<CR>", desc = "Telescope find_files起動" },
      -- <leader>tg を押すと Telescopeを起動
      { "<leader>tg", "<cmd>Telescope live_grep<CR>", desc = "Telescope live_grep起動" },
    },
    config = function()
      require("telescope").setup {
        defaults = {
          -- 必要に応じて設定を追加
          -- その他のオプション...
        },
        pickers = {
          find_files = {
            -- 例: dropdown テーマを使用
            theme = "dropdown",
          },
        },
        -- 拡張機能の設定なども可能
        mappings = {
          i={
            ["<esc>"] = require('telescope.actions').close,
          }
        }
      }
    end,
  },
}