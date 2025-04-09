local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map('n', '<A-h>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-l>', '<Cmd>BufferNext<CR>', opts)
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
map('n', '<leader>bh', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<leader>bl', '<Cmd>BufferNext<CR>', opts)
map('n', '<leader>bc', '<Cmd>BufferClose<CR>', opts)
map('n', '<leader>bC', '<Cmd>BufferClose!<CR>', opts)

return {
  'romgrk/barbar.nvim',
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    icons = {
      button = 'x',
      filetype = {
        custom_colors = false,
        enabled = false,
      },
    },
  },
  version = '^1.0.0',
}
