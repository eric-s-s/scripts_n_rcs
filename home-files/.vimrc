
let mapleader=","

filetype plugin indent on

set hlsearch
set number

set tabstop=4
set shiftwidth=4
set expandtab

set noerrorbells visualbell t_vb=

set titlestring=\VIM\ \ %t\ \@\ \%(\ (%{expand(\"%:p:h\")})%)
set title

nnoremap <leader><CR> o<Esc>
nnoremap <leader>\ O<Esc>

" This is specific settings for yaml files and makefiles
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType make setlocal noexpandtab

