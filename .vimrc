set nocompatible
set termguicolors

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

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

nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gP

" NERDTree specific mappings.
" Map the F3 key to toggle NERDTree open and close.
nnoremap <F3> :NERDTreeToggle<cr>

" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" }}}

" STATUS ------------------------------------------------------------ {{{

set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }

" }}}

autocmd vimenter * ++nested colorscheme gruvbox

" PLUGINS ------------------------------------------------------------ {{{
call plug#begin('~/.vim/plugged')

Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'godlygeek/tabular'
Plug 'morhetz/gruvbox'

call plug#end()

let g:gruvbox_contrast_dark = 'medium'
set background=dark " set dark mode

colorscheme gruvbox

" }}}

