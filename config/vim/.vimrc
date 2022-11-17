" Désactive la compatibilités vi 
set nocompatible

filetype plugin indent on
syntax on
set number
set cursorline
set autoindent
set laststatus=2
set clipboard=unnamedplus

" Highligh les résultats durant la recherche
set hlsearch

" Activer l'auto complétion des fichiers en appuyant sur TAB
set wildmenu

call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'arcticicestudio/nord-vim'

call plug#end()

" Theme
try

colorscheme nord

catch /^Vim\%((\a\+)\)\=:E185/

" deal with it

endtry

let g:lightline = {'colorscheme': 'nord'}

" Wildmenu
set wildmode=list:full
set wildignorecase
set wildignore=*/.git/**/*

" Copier/Coller
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p
