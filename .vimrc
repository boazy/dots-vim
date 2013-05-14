let mapleader = ","

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []

call add(g:pathogen_disabled, 'command-t')

" for some reason the csscolor plugin is very slow when run on the terminal
" but not in GVim, so disable it if no GUI is running
if !has('gui_running')
  call add(g:pathogen_disabled, 'csscolor')
endif

" Gundo requires at least vim 7.3
if v:version < '703' || !has('python')
  call add(g:pathogen_disabled, 'gundo')
endif

execute pathogen#infect()

if v:version >= '703'
  au BufWritePre /tmp/* setlocal noundofile
  set undodir=~/tmp/.vim/undo
  set undofile
endif

filetype plugin indent on

set number
set mouse=a
set expandtab
set tabstop=2
set shiftwidth=2

" Remap clipboard
nnoremap y "+y
vnoremap y "+y
nnoremap Y "+Y
vnoremap Y "+Y
nnoremap p "+p
vnoremap p "+p
nnoremap P "+P
vnoremap P "+P
nmap <silent><C-\> <Leader><Leader>f
nmap <silent><F2> :NERDTreeToggle<CR>
nmap <silent>L H<Leader><Leader>j

" F5: Gundo
nnoremap <silent><F5> :GundoToggle<CR>

" use Ctrl+L to toggle the line number counting method
function! g:ToggleNuMode()
  if &nu == 1
     set rnu
  else
     set nu
  endif
endfunction
nnoremap <silent><C-L> :call g:ToggleNuMode()<cr>
