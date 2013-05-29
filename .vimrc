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

" Set numbertoggle trigger
let g:NumberToggleTrigger="<C-l>"

execute pathogen#infect()

if v:version >= '703'
  au BufWritePre /tmp/* setlocal noundofile
  set undodir=~/tmp/.vim/undo
  set undofile
endif

filetype plugin indent on

" Perl-style regex for  find
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

set gdefault
set ignorecase
set smartcase
set number
set mouse=a
set expandtab
set tabstop=2
set shiftwidth=2
set textwidth=78

" Remap clipboard
nmap <silent>\c   :let @+=@"<CR>
nmap <silent>\v   :let @"=@+<CR>
nmap <silent><F2> :NERDTreeToggle<CR>
nmap <silent>L H<Leader><Leader>j

nnoremap <leader>hr yypVr=

" F5: Gundo
nnoremap <silent><F5> :GundoToggle<CR>

