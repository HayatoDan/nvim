vim.api.nvim_set_var('loaded_netrw', 1)
vim.api.nvim_set_var('loaded_netrwPlugin', 1)
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- キーマッピングで <leader><leader>n で nvim-tree をトグル
  keys = {
    { "<leader><leader>n", "<cmd>NvimTreeToggle<CR>", mode = "n", desc = "Toggle NvimTree" },
  },
  config = function()
    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",
      },
      filters = {
        dotfiles = true,
      },
    })
    -- Neovim起動時に nvim-tree を自動表示する
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        require("nvim-tree.api").tree.open()
      end,
    })
  end,
}