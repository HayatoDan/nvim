
-- 文字コード関連
vim.scriptencoding = 'utf-8'
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.o.ambiwidth = 'double'

-- マウス有効化
vim.o.mouse = 'a' 

-- ファイルの扱い
vim.o.backup = false -- バックアップファイルを作らない
vim.o.swapfile = false -- スワップファイルも作らない
vim.o.hidden = true -- 編集中ファイルも開く
vim.o.autoread = true -- 編集中に外部で変更されたファイルは自動で読み直す
vim.o.autochdir = true -- 現在開いているファイルの親ディレクトリを自動的に移動

-- 見た目
vim.o.number = true -- 行番号表示
vim.o.showcmd = true -- 入力中のコマンド表示
vim.o.showmatch = true -- 対応する()を表示
vim.o.matchtime = 1 -- 対応する()に飛ぶ時間を0.1秒に
vim.o.wildmenu = true -- コマンドラインでの補完
vim.o.laststatus = 2 -- 常時ステータスライン表示
vim.o.cursorline = true -- 現在の行をハイライト

vim.o.list = true -- 不可視文字を可視化
vim.o.listchars = 'tab:>-', 'extends:<' -- 不可視文字の可視化方法



vim.o.title = true -- ウインドウのタイトルバーにファイルのパス情報等を表示

-- クリップボード有効化
vim.o.clipboard = "unnamedplus","unnamed"

-- 検索系
vim.o.hlsearch = true -- 検索をハイライト
vim.o.incsearch = true -- 検索文字入力時に順次対象文字列にヒット
vim.o.ignorecase = true -- 検索文字列が小文字なら大文字小文字を区別しない
vim.o.smartcase = true -- 検索文字に大文字が含まれるなら区別する
vim.o.wrapscan = true -- 最後まで検索したら最初に戻る

vim.keymap.set('n', '<ESC><ESC>', ':nohlsearch<CR><ESC>') -- ESC連打でハイライト解除

-- indent and TAB
vim.o.expandtab = true -- tabを半角スペースに
vim.o.tabstop = 4 -- タブ文字の表示幅
vim.o.shiftwidth = 4 -- 挿入するインデント幅
vim.o.autoindent = true -- 改行時に前の行のインデント継続
vim.o.smartindent = true -- 改行時にインデントを調節




-- バックスペース有効化
vim.o.backspace = 'indent,eol,start'

vim.o.helplang = 'ja','en'
