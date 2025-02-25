
return {
  'lambdalisue/fern.vim',
  keys = {
    { "<leader>f", ":Fern . -reveal=% -drawer -toggle -width=40<CR>", desc = "toggle fern" },
  },
--   config = function()
--     vim.api.nvim_create_autocmd("VimEnter", {
--       callback = function()
--         vim.schedule(function()
--           vim.cmd("Fern . -reveal=% -drawer -width=40")
--         end)
--       end,
--     })
--   end,
}