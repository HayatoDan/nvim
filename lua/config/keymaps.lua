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
vim.keymap.set('v', 'p', '"_d"+p')



-- <leader>lで文末へ
vim.keymap.set('n', '<leader>l', 'g$')
vim.keymap.set('v', '<leader>l', 'g$')


-- <leader><tab>でウインドウフォーカスを移動
vim.keymap.set('n', '<leader><tab>', '<C-w>w')
