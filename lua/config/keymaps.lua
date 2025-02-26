-- -- リーダーキー設定
-- lazy.luaの中で設定
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- 表示行でカーソル移動
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('v', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('v', 'k', 'gk')

-- Ctrl-Zで取り消し
vim.keymap.set('i', '<C-z>', '<ESC>ui')
vim.keymap.set('n', '<C-z>', 'u') 

-- Ctrl-Sで保存
vim.keymap.set('i', '<C-s>', '<ESC>:w<CR>')
vim.keymap.set('n', '<C-s>', ':w<CR>') 

-- 行末までヤンク
vim.keymap.set('n', 'Y', 'y$') 


-- ビジュアルモードで連続ペーストを可能に
-- Pでペーストするとレジスタが汚れないので，Pとpを入れ替えておく．
vim.keymap.set('v', 'p', 'P')
vim.keymap.set('v', 'P', 'p')



-- ,と$をを入れ替え
vim.keymap.set('n', ',', '$')
vim.keymap.set('v', ',', '$')
vim.keymap.set('n', '$', ',')
vim.keymap.set('v', '$', ',')


-- <leader><tab>でウインドウフォーカスを移動
vim.keymap.set('n', '<leader><tab>', '<C-w>w')

-- <space>w で現在バッファの「非スペース文字数」を出力
vim.keymap.set('n', '<space>w', function()
  -- 現在のバッファから全行を取得
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  -- 改行を含めずに全行を連結
  local joined = table.concat(lines, "")
   -- Vim の substitute() を使って半角スペース (" ") と全角スペース ("　") を除去
  local sanitized = vim.fn.substitute(joined, '[ 　]', '', 'g') 
  -- vim.fn.strchars() の第2引数を 1 にして合成文字を1文字としてカウント
  local count = vim.fn.strcharlen(sanitized)
  print("Char count (excluding spaces): " .. count)
end, { silent = true })