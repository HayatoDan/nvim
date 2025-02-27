return{
    {
    'smoka7/hop.nvim',
    version = "*",
    keys = {
        { "<leader>e", "<cmd>HopWord<CR>", desc = "HopWord" },
      },
      config = function()
        require("hop").setup {
          keys = 'etovxqpdygfblzhckisuran'  -- お好みでキー設定を変更できます
        }
      end,
    },
}
