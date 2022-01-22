set termguicolors

let ayucolor="dark"
colorscheme ayu

set visualbell
set number relativenumber

set showmatch
set incsearch "Search as you write
set hlsearch "Highlight search matches

set cursorline

filetype indent plugin on

set tabstop=4
set shiftwidth=4
set softtabstop=4

set autoindent
set smarttab
set expandtab
set smartindent
set ai

" ---------------------------------------
"  Turn persistent undo on
"  Undo even when you close a buffer/VIM
" ---------------------------------------
set backupdir=~/.vim/temp_dirs/backupdir
set directory=~/.vim/temp_dirs/backupdir

try
    set undodir=~/.vim/temp_dirs/undodir
    set undofile
catch
endtry
