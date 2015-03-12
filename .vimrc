" Header and vim settings {{
" vim: set sw=2 ts=2 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker spell:
" }}
" === Preamble === 
let mapleader = ","
" Detect OS {{
  let s:os = "unknown"
  if has("win32") || has('win64')
    let s:os = "windows"
  else
    if has("unix")
      let s:uname = substitute(system('uname'), "\n", "", "")
      if s:uname == 'Darwin'
        let s:os = "osx"
      elseif s:uname =~ 'CYGWIN'
        let s:os = "cygwin"
      else
        let s:os = s:uname
      endif
    endif
  endif
" }}
" Windows compatibility {{
if s:os == 'windows'
  set nocompatible
  source $VIMRUNTIME/vimrc_example.vim
  source $VIMRUNTIME/mswin.vim
  behave mswin
  set encoding=utf-8
  
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
  " Vimproc {{
    " Check vimproc.
    function! BuildVimProc(info)
      " info is a dictionary with 3 fields
      " - name:   name of the plugin
      " - status: 'installed', 'updated', or 'unchanged'
      " - force:  set on PlugInstall! or PlugUpdate!
      if a:info.status == 'installed' || a:info.force
        if s:os == 'linux'
          !make
        elseif s:os == 'osx'
          !make -f make_mac.mak
        elseif s:os == 'windows'
          !tools\\update-dll-mingw
        elseif has('unix')
          if executable('gmake')
            !gmake
          else
            !make
          endif
        endif
      endif
    endfunction
  " }}
  " Unite.vim {{
    let g:unite_source_history_yank_enable = 1
    let g:unite_source_grep_max_candidates = 200
    " Find best grep executable
    if executable('ag')
      " Use ag in unite grep source.
      let g:unite_source_grep_command = 'ag'
      let g:unite_source_grep_default_opts =
      \ '-i --line-numbers --nocolor --nogroup --hidden --ignore ' .
      \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('pt')
      " Use pt in unite grep source.
      " https://github.com/monochromegane/the_platinum_searcher
      let g:unite_source_grep_command = 'pt'
      let g:unite_source_grep_default_opts = '--nogroup --nocolor'
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('ack-grep')
      " Use ack in unite grep source.
      let g:unite_source_grep_command = 'ack-grep'
      let g:unite_source_grep_default_opts =
      \ '-i --no-heading --no-color -k -H'
      let g:unite_source_grep_recursive_opt = ''
    endif
  " }}
  " VimFiler settings {{
    let g:vimfiler_as_default_explorer = 1
  " }}
  " YCM+UltiSnips settings {{
    function! BuildYCM(info)
      " info is a dictionary with 3 fields
      " - name:   name of the plugin
      " - status: 'installed', 'updated', or 'unchanged'
      " - force:  set on PlugInstall! or PlugUpdate!
      if a:info.status == 'installed' || a:info.force
        !./install.sh
      endif
    endfunction
    " Conceal for snippets
    set conceallevel=2 concealcursor=i
    " Disable preview scratch window
    set completeopt=longest,menu,menuone

    " Try to set compatible ultisnips triggers
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<Tab>"
    let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"

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
  " vim-airline settings {{
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
  " }}
  " Emmet.vim settings {{
    let g:user_emmet_install_global = 0
    autocmd FileType html,css EmmetInstall
  " }}
  " Syntastic settings {{
    " Automatically populate location list upon loading, so we can jump to
    " error warnings.
    " Since we have vim-unimpaired, jumping is as simple as ']l' and '[l'
    let g:syntastic_always_populate_loc_list = 1
  " }}
" }}
" Load plugins {{
call plug#begin()
  Plug 'tpope/vim-sensible'                 " Sensible defaults for vim
  Plug 'tpope/vim-surround'                 " csXX for quotes, braces, etc.
  Plug 'tpope/vim-unimpaired'               " Pair commands
  Plug 'tpope/vim-eunuch'                   " Shell tools
  Plug 'dr-chip-vim-scripts/ZoomWin'        " Zoom in/out windows with <c-w>o
  Plug 'jeffkreeftmeijer/vim-numbertoggle'  " Relative line numbers
  Plug 'kana/vim-textobj-user'              " Library for custom text objects 
  Plug 'whatyouhide/vim-textobj-xmlattr'    " Xml Attribute text object (ax, ix)
  Plug 'altercation/vim-colors-solarized'
  Plug 'Lokaltog/vim-easymotion'
  Plug 'rking/ag.vim', { 'on': 'Ag' }
  Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'Shougo/vimproc.vim', { 'do': function('BuildVimProc') }
  Plug 'Shougo/Unite.vim'
  Plug 'Shougo/vimfiler.vim'
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/syntastic'
  Plug 'bling/vim-airline'
  "Plug 'ervandew/supertab'
  if s:os != 'windows'
    Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
  endif

  " --- Type-specific ---
  Plug 'tpope/vim-git', { 'for': 'git' }
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
  Plug 'mattn/emmet-vim', { 'for': 'html' }
  Plug 'othree/html5.vim', { 'for': 'html' }
call plug#end()
" }}
" Plugin Checks {{
  try
    call vimproc#version()
    let s:has_vimproc = 1
  catch
    let s:has_vimproc = 0
  endtry
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
  set nospell
  set linebreak
  "set virtualedit=onemore " Allow for cursor beyond last character
  " Sets the default behavior when opening a new file to hide the current
  " buffer and create a new one.
  set hidden
  " Make messages shorter than default ([+] for [Modified] and [RO] for
  " [ReadOnly])
  set shortmess+=filmnrxoOtT
  " Unixish behavior even on Windows (converts to LF and slashes)
  set viewoptions=folds,options,cursor,unix,slash
" }}
" Appearance {{
" Color scheme
  set background=dark
  colorscheme solarized
" }}
" GUI settings {{
  if s:os == "osx"
    set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h11
  elseif s:os == "windows"
    set guifont=Powerline_Consolas:h11
  endif
" }}
" === Tweaks ===
" Grabbed from SPF13 {{
  " Most prefer to automatically switch to the current file directory when
  " a new buffer is opened; to prevent this behavior, add the following to
  " your .vimrc.before.local file:
  "   let g:spf13_no_autochdir = 1
  if !exists('g:spf13_no_autochdir')
      autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
      " Always switch to the current file directory
  endif
" }}
" Clear last search highlight on ENTER {{
  nnoremap <CR> :nohlsearch<CR><CR>
" }}
" Directories for Vim support files {{
  function! MakeDirP (dir)
    if !isdirectory(a:dir)
      call mkdir(a:dir, 'p')
    endif
  endfunction

  if s:os == 'windows'
    set directory=C:/Temp/User/.vim/swap
    set backupdir=C:/Temp/User/.vim/backup
    set undodir=C:/Temp/User/.vim/undo
  else
    set directory=$HOME/tmp/.vim/swap
    set backupdir=$HOME/tmp/.vim/backup
    set undodir=$HOME/tmp/.vim/undo
  endif
  call MakeDirP(&directory)
  call MakeDirP(&backupdir)
  call MakeDirP(&undodir)
" }}
" Undo History {{
  " No undo file for temporary files
  augroup TempNoUndo
    au BufWritePre /tmp/* setlocal noundofile
    au BufWritePre ~/tmp/* setlocal noundofile
  augroup END
  set undofile
" }}
" Perl-style regex for slash-find {{
  nnoremap / /\v
  vnoremap / /\v
  nnoremap ? ?\v
  vnoremap ? ?\v
" }}
" === Key mappings ==
" Plugin key mappings {{
  " Todo, add neo_mru, buffertab, build string accordingly
  nnoremap <Leader>u :<C-u>Unite -start-insert<CR>
  nnoremap gy :<C-u>Unite -start-insert history/yank<CR>
  nnoremap gb :<C-u>Unite -start-insert buffer<CR>
  if exists('s:has_vimproc') && s:has_vimproc
    nnoremap <c-p> :<C-u>Unite -start-insert file_rec/async buffer<CR>
  else
    nnoremap <c-p> :<C-u>Unite -start-insert file_rec buffer<CR>
  endif
  nmap <silent><F4> :VimFilerExplorer<CR>
  nmap <silent>L H<Leader><Leader>j
  nnoremap <silent><F5> :GundoToggle<CR>
" }}
" General key mappings {{
  " HR below the current line in the same length
  nnoremap <leader>hr yypVr=
  " Quick save
  nnoremap ZW :w<CR>
  " select last pasted text with 'gp'
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" }}
" System clipboard {{
  if s:os != 'windows'
    " Remap clipboard
    nmap <silent>\c   :let @+=@"<CR>
    nmap <silent>\v   :let @"=@+<CR>
  endif
" }}
