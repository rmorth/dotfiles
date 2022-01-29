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
set noexpandtab
set smartindent
set ai

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
