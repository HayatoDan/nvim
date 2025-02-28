return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim", lazy = false },
    keys = {
      -- Telescopeの基本操作
      { "<leader>tt", "<cmd>Telescope<CR>", desc = "Telescope起動" },
      { "<leader>tk", "<cmd>Telescope keymaps<CR>", desc = "Telescope keymaps起動" },
      { "<leader>tf", "<cmd>Telescope find_files<CR>", desc = "Telescope find_files起動" },
      { "<leader>tg", "<cmd>Telescope live_grep<CR>", desc = "Telescope live_grep起動" },
      -- ファイルブラウザ
      { "<leader>f", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "Telescope File Browser起動" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          initial_mode = "normal", -- デフォルトをノーマルモードに
          mappings = {
            ["i"] = {
              ["<C-u>"] = false, -- デフォルトの削除キーを無効化
              ["<C-c>"] = false, -- インサートモードで <C-c> を無効化
            },
            ["n"] = {
              ["<C-c>"] = require("telescope.actions").close, -- ノーマルモードで <C-c> でファイルブラウザを閉じる
            },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
          },
        },
        extensions = {
          file_browser = {
            theme = "dropdown", -- "ivy", "dropdown", "cursor" など選択可
            hijack_netrw = true, -- netrw を無効化
            grouped = true, -- ディレクトリを先に表示
            display_stat = false, -- ファイル情報（サイズやパーミッション）を非表示
            dir_icon = "o", -- フォルダアイコン（表示する場合）
            hidden = true, -- 隠しファイルを表示する
            respect_gitignore = false, -- .gitignore を無視しない
            sorting_strategy = "ascending", -- 昇順ソート
            sort_by = { "type", "name" }, -- ディレクトリを先に、その後名前順でソート
            },
          },
      })

      -- ファイルブラウザ拡張をロード
      require("telescope").load_extension("file_browser")
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
}
