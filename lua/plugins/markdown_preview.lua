return {
    require("user.markdown_preview").setup({
         port = 8080,
         keymaps = {
             toggle = "<leader>mp",  -- トグル用キーを上書き
             start  = "<leader>ms",  -- 起動用キー（必要に応じて変更可能）
             stop   = "<leader>mq",  -- 停止用キー（必要に応じて変更可能）
         },
    })
}