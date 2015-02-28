" Header and vim settings {{
" vim: set sw=2 ts=2 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker spell:
" }}
" === Preamble === 
let mapleader = ","
" Windowns compatibility {{
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
" }}
" === Plugins ===
" Plugin settings {{
  " CtrlP options {{
    let g:ctrlp_extensions = ['funky']
    let g:ctrlp_cmd = 'CtrlPMixed'
  " }}
  " YCM settings {{
    " Disable preview scratch window
    set completeopt=longest,menu,menuone

    let g:ycm_global_ycm_extra_conf = '~/dots/vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
    let g:ycm_key_list_select_completion = ['<Down>']
    let g:ycm_key_list_previous_completion = ['<Up>']
  " }}
  " SuperTab settings (disabled) {{
  " let g:SuperTabDefaultCompletionType='context'
  " }}
  " NumberToggle settings {{
    let g:NumberToggleTrigger="<C-l>"
  " }}
" }}
" Load plugins {{
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
" }}
" === Settings ===
" Generic settings {{
  set gdefault
  set ignorecase
  set smartcase
  set number
  set mouse=a
  set expandtab
  set tabstop=2
  set shiftwidth=2
  set textwidth=78
  " Sets the default behavior when opening a new file to hide the current
  " buffer and create a new one.
  set hidden
" }}
" Apperance {{
" Color scheme
  set background=dark
  colorscheme solarized
" }}
" === Tweaks ===
" Clear last search highlight on ENTER {{
  nnoremap <CR> :nohlsearch<CR><CR>
" }}
" Undo History {{
  " No undo file for temporary files
  augroup TempNoUndo
    au BufWritePre /tmp/* setlocal noundofile
    au BufWritePre ~/tmp/* setlocal noundofile
  augroup END
  if has('win32')
    set undodir=$HOME/.vimundo
  else
    set undodir=~/tmp/.vim/undo
  endif
set undofile
" }}
" Perl-style regex for slash-find {{
  nnoremap / /\v
  vnoremap / /\v
  nnoremap ? ?\v
  vnoremap ? ?\v
" }}
" === Key mappings ===
" Plugin key mappings {{
  nmap <silent><F4> :NERDTreeToggle<CR>
  nmap <silent>L H<Leader><Leader>j
  nnoremap <silent><F5> :GundoToggle<CR>
" }}
" General key mappings {{
  " HR below the current line in the same length
  nnoremap <leader>hr yypVr=
  " Quick save
  nmap ZW :w<CR>
" }}
" System clipboard {{
  if !has('win32')
    " Remap clipboard
    nmap <silent>\c   :let @+=@"<CR>
    nmap <silent>\v   :let @"=@+<CR>
  endif
" }}
