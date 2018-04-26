" -------------------
" 色の設定
" -------------------
syntax on

highlight LineNr ctermfg=darkyellow    " 行番号
highlight NonText ctermfg=darkgrey
highlight Folded ctermfg=blue
highlight SpecialKey cterm=underline ctermfg=darkgrey
"highlight SpecialKey ctermfg=grey " 特殊記号

" 全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/

"  Tab,スペースの可視化
set list
set listchars=tab:»-,trail:-,eol:«,extends:»,precedes:«,nbsp:%

" タブ幅
set ts=2 sw=2
set softtabstop=2
" タブをスペースに変換
set expandtab

" タブをスペースに変換しない
"set noexpandtab

"常にステータス行を表示
set laststatus=2
"if(){}などのインデント
set cindent
"検索時にヒット部位の色を変更
set hlsearch
"検索時にインクリメンタルサーチを行う
set incsearch
set showmode
"Vimを終了しても undo 履歴を復元する
"http://vim-users.jp/2010/07/hack162/
if has('persistent_undo')
  set undodir=./.vimundo,~/.vimun
  set undofile
endif

" コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmenu wildmode=list:longest,full
" コマンドラインの履歴を10000件保存する
set history=10000


" -------------------
" 日本語の設定
" -------------------
set termencoding=utf-8
set encoding=japan
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set fenc=utf-8
set enc=utf-8

set autoindent
"#オートインデント
set number
"#行番号表示
set incsearch
"#インクリメンタルサーチ
set ignorecase
"#検索時に大文字小文字を無視
"set nohlsearch　#検索時にハイライト無効
set showmatch
"#対括弧の表示
set showmode
"#モード表示
set backspace=2
"#上行末尾の文字を1文字消去
set title
"#編集中のファイル名を表示
set ruler
"#ルーラーの表示
set tabstop=2
"#タブ文字数を4に
set shiftwidth=2
"#シフト移動幅
set expandtab
"#タブの代わりに空白文字挿入

set clipboard=unnamed,autoselect
"ヤンクをクリップボードへコピー

"#前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif
autocmd BufWinLeave ?* silent mkview
autocmd BufWinEnter ?* silent loadview


setlocal omnifunc=syntaxcomplete#Complete

" 自動補完
set completeopt=menuone
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
  exec "imap <expr> " . k . " pumvisible() ? '" . k . "' : '" . k . "\<C-X>\<C-P>\<C-N>'"
endfor
set wildmenu
set helplang=ja,en
set ambiwidth=double

" 行末空白を消す
autocmd BufWritePre * :%s/\s\+$//ge


" 検索/置換の設定
set gdefault   " 置換の時 g オプションをデフォルトで有効にする

" ファイルタイプ

" markdownのハイライトを有効にする
set syntax=markdown
au BufRead,BufNewFile *.md set filetype=markdown


"""""
" Japanese Settins by ずんWiki
"
" 文字コードの自動認識
"""""
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" vimが重すぎるのでgemのモジューの補完をやめる
let g:ruby_path = ""

" メニューを出さない
set guioptions-=m

" vim-ruby : VimでRubyを扱う際の最も基本的な拡張機能
Bundle 'ruby.vim'

" rails.vim : rails的なアレ
Bundle 'tpope/vim-rails'


"if has('vim_starting')
"  " 挿入モード時に非点滅の縦棒タイプのカーソル
"  let &t_SI .= "\e[6 q"
"  " ノーマルモード時に非点滅のブロックタイプのカーソル
"  let &t_EI .= "\e[2 q"
"  " 置換モード時に非点滅の下線タイプのカーソル
"  let &t_SR .= "\e[4 q"
"endif

"------------------------------------
" NERD Tree
"------------------------------------
" 表示
nmap <silent> <F1> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 25

" .swpを作らない
set noswapfile

"------------------------------------
" spinner
" http://nanasi.jp/articles/vim/spinner_vim.html#id10
"------------------------------------
" spinnerの状態をステータスバーに表示する
set statusline=%<%f%m%r%h%w[#%n]%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.'][spinner:'.g:CurrentSpinnerMode().']'}%=[row:%l/%L,col:%c]%P
" コンソールvimではkeyが被るのでkeyconfigを変える
" 次のアイテムに移動
let g:spinner_previousitem_key = '{'
" 前のアイテムに移動
let g:spinner_nextitem_key = '}'
" 操作モードの切り替え
let g:spinner_switchmode_key = '_'
" 操作モード表示
"let g:spinner_displaymode_key = 'C-S'
" 起動時の操作モード
let g:spinner_initial_search_type = 5
