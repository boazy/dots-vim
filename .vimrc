if has('win32')
  set nocompatible
  source $VIMRUNTIME/vimrc_example.vim
  source $VIMRUNTIME/mswin.vim
  behave mswin

  set diffexpr=MyDiff()
  function MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    let cmd = 'diff'
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
  endfunction
end

let mapleader = ","

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = ['clang_complete', 'supertab']

" for some reason the csscolor plugin is very slow when run on the terminal
" but not in GVim, so disable it if no GUI is running
if !has('gui_running')
  call add(g:pathogen_disabled, 'csscolor')
endif

" Gundo requires at least vim 7.3
if v:version < '703' || !has('python')
  call add(g:pathogen_disabled, 'gundo')
endif

" CtrlP options
let g:ctrlp_extensions = ['funky']
let g:ctrlp_cmd = 'CtrlPMixed'

" Set numbertoggle trigger
let g:NumberToggleTrigger="<C-l>"

" set conceallevel=2
" set concealcursor=vin

" Disable preview scratch window
set completeopt=longest,menu,menuone

let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']

" SuperTab options
let g:SuperTabDefaultCompletionType='context'

" execute pathogen#infect()
call plug#begin()
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-surround'
  Plug 'altercation/vim-colors-solarized'
  Plug 'kien/ctrlp.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'Lokaltog/vim-easymotion'
  Plug 'sjl/gundo.vim'
  Plug 'tomtom/tlib_vim'
  Plug 'MarcWeber/vim-addon-mw-utils'
  Plug 'SirVer/ultisnips'
  Plug 'boazy/ZoomWin'
  Plug 'jeffkreeftmeijer/vim-numbertoggle'
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/syntastic'
  Plug 'davidhalter/jedi-vim'
  Plug 'plasticboy/vim-markdown'
  Plug 'vim-ruby/vim-ruby'
  Plug 'tacahiroy/ctrlp-funky'
  Plug 'fholgado/minibufexpl.vim'
  Plug 'Valloric/YouCompleteMe'
  " Plug 'ervandew/supertab'
call plug#end()

if v:version >= '703'
  au BufWritePre /tmp/* setlocal noundofile
  if has('win32')
    set undodir=$HOME/.vimundo
  else
    set undodir=~/tmp/.vim/undo
  endif
  set undofile
endif

syntax on
filetype plugin indent on

" Perl-style regex for  find
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" Clear last search highlight on ENTER
nnoremap <CR> :nohlsearch<CR><CR>

set gdefault
set ignorecase
set smartcase
set number
set mouse=a
set expandtab
set tabstop=2
set shiftwidth=2
set textwidth=78

" Sets the default behavior when opening a new file to hide the current buffer and create a new one.
set hidden

nmap <silent><F4> :NERDTreeToggle<CR>
nmap <silent>L H<Leader><Leader>j

nnoremap <leader>hr yypVr=

nmap ZW :w<CR>

" F5: Gundo
nnoremap <silent><F5> :GundoToggle<CR>

" Color scheme
set background=dark
colorscheme solarized

if !has('win32')
  " Remap clipboard
  nmap <silent>\c   :let @+=@"<CR>
  nmap <silent>\v   :let @"=@+<CR>
endif
