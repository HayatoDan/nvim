return {
  "bluz71/vim-nightfly-colors",  -- Nightfly カラースキームのプラグイン
  priority = 1000,                -- 他のプラグインより先に読み込むための優先度
  config = function()
    -- true colors を有効化
    -- vim.opt.termguicolors = true

    -- -- Nightfly 固有のオプション設定（必要に応じて調整してください）
    -- vim.g.nightflyCursorColor = true
    -- vim.g.nightflyTerminalColors = true
    -- vim.g.nightflyUnderlineMatchParen = 1

    -- Nightfly カラースキームを適用
    vim.cmd("colorscheme nightfly")
  end,
}
