return{
  "nvim-tree/nvim-tree.lua",
  version = "*",
  config = function()
    require("nvim-tree").setup({
      -- ファイル更新時にツリー内の該当ファイルをハイライト
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },

      -- ドットファイル（.git や .env など）を表示（trueで非表示）
      filters = {
        dotfiles = false,
      },

      -- 見た目に関する設定（アイコン無効）
      renderer = {
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
          },
        },
        indent_markers = {
          enable = true, -- ツリーの縦線や枝を表示
        },
      },

      -- サイドバーの位置と幅
      view = {
        side = "left", -- 右側に表示（leftにすれば左）
        width = 30,
        preserve_window_proportions = true,
      },

      -- 起動時にカーソルをツリーに合わせる
      hijack_cursor = true,
    })

    -- <leader>e でトグル（例: スペースキー + e）
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
  end
}