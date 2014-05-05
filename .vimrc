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
let g:pathogen_disabled = []

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

set conceallevel=2
set concealcursor=vin

" clang_complete options
let g:clang_snippets=1                  " Automatically add snippets with function parameters
let g:clang_conceal_snippets=1          " Conceal the snippets
let g:clang_auto_select=1               " Select the first entry in the popup menu
let g:clang_library_path="/usr/lib/"    " This is where libclang.so is found

" SuperTab options
let g:SuperTabDefaultCompletionType='context'

execute pathogen#infect()

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

nmap <silent><F2> :NERDTreeToggle<CR>
nmap <silent>L H<Leader><Leader>j

nnoremap <leader>hr yypVr=

nmap ZW :w<CR>

" F5: Gundo
nnoremap <silent><F5> :GundoToggle<CR>

if has('win32')
  " Color scheme
  set background=dark
  colorscheme solarized
else
  " Remap clipboard
  nmap <silent>\c   :let @+=@"<CR>
  nmap <silent>\v   :let @"=@+<CR>
endif
