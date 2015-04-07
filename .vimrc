"" users generic .vimrc file for mac, fedora, and any linux.
"" @author: M.Ishikawa


set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
set autoindent


""Vundle導入により、OFF http://slumbers99.blogspot.jp/2012/02/vim-vundle.html
filetype off		" ファイル形式の検出を無効にする

" Vundle を初期化して Vundle 自身も Vundle で管理
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" github にあるプラグイン

" vim-scripts プラグイン

" github にないプラグイン


"そのファイルタイプにあわせたインデントを利用する
filetype plugin indent on
"autocmd FileType conf set noautoindent
"autocmd FileType conf set nosmartindent
"filetype plugin on


"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" ターミナルが対応していれば色をつける
" 検索パターンをハイライトする
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif


" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

" カラースキーマを設定 vim-colors-solarized
let g:solarized_termcolors=256
"syntax enable
if has('gui_running')
    " macvim用
    set background=light
"    set guifont=Menlo:h12
"    set lines=90 columns=200
    set guioptions-=T
else
    set background=dark
endif
colorscheme solarized

"タブ文字、行末など不可視文字を表示する
"set list
"listで表示される文字のフォーマットを指定する
set listchars=eol:$,tab:>\ ,extends:<
"行番号を表示する
"set number
"シフト移動幅
"set shiftwidth=4
"閉じ括弧が入力されたとき、対応する括弧を表示する
set showmatch
"検索時に大文字を含んでいたら大/小を区別
set smartcase
"新しい行を作ったときに高度な自動インデントを行う
set smartindent
"行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする。
set smarttab
"ファイル内の <Tab> が対応する空白の数
"set tabstop=4
"カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
"検索をファイルの先頭へループしない
"set nowrapscan

set cmdheight=2
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set notitle
set linespace=0
set wildmenu
set showcmd

