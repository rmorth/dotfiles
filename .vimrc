set nocompatible
set termguicolors

let ayucolor="dark"
colorscheme ayu

syntax on

set ttimeoutlen=0

set number relativenumber

set showcmd
set noshowmode

set showmatch
" Search as you write
set incsearch
" Highlight search matches
set hlsearch

set cursorline

filetype on
filetype plugin on
filetype indent on

set tabstop=4
set shiftwidth=4
set softtabstop=4

" When scrolling, cursor will be 'surrounded' with 10 lines
set scrolloff=10

" Spaces instead of tabs
" set expandtab 

set autoindent
set smarttab
set noexpandtab
set smartindent
set ai

" Set the commands to save in history, default: 20
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" ---------------------------------------
"  Set backup directories
"  Remember to create the directory
" ---------------------------------------
try
	set backupdir=~/.vim/tmp/backupdir
	set directory=~/.vim/tmp/backupdir
catch
endtry

" ---------------------------------------
"  Turn persistent undo on
"  Undo even when you close a buffer/VIM
"  Remember to create the directory
" ---------------------------------------
try
	set undofile
	set undodir=~/.vim/tmp/undodir
catch
endtry


" MAPPINGS ------------------------------------------------------------ {{{

let mapleader = '\'

" Unbind arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Set \\ to clear highlighting from searches.
nnoremap <leader>\ :nohlsearch<CR> 

" Press the space bar to type the : character in command mode.
nnoremap <space> :

" Changes behaviour of pressing the letter o, doesn't go into insert mode.
nnoremap o o<esc>
nnoremap O O<esc>

" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzz
nnoremap N Nzz

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l


" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

" NERDTree specific mappings.
" Map the F3 key to toggle NERDTree open and close.
nnoremap <F3> :NERDTreeToggle<cr>

" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" }}}

" STATUS ------------------------------------------------------------ {{{

set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'ayu_dark',
      \ }

" }}}

" PLUGINS ------------------------------------------------------------ {{{
call plug#begin('~/.vim/plugged')

Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'godlygeek/tabular'

call plug#end()

" }}}

