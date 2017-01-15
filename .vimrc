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
      if a:info.status == 'installed' || a:info.satus == 'updated' || a:info.force
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
    function s:my_unite_settings()
      "let b:unite_close=0
      "imap <silent><buffer> <S-Tab> :let b:unite_no_close=1<CR><ESC>
      "au InsertLeave <buffer> if !(exists('b:unite_no_close') && b:unite_no_close) | norm q | endif
      "au InsertEnter <buffer> let b:unite_no_close=0
    endfunction
    autocmd FileType unite call s:my_unite_settings()

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
      " Use ag for normal file search with ignore support
      let g:unite_source_rec_async_command = ['ag', '--nocolor', '--nogroup', '-g', '']
    elseif executable('pt')
      " Use pt in unite grep source.
      " https://github.com/monochromegane/the_platinum_searcher
      let g:unite_source_grep_command = 'pt'
      let g:unite_source_grep_default_opts = '--nogroup --nocolor'
      let g:unite_source_grep_recursive_opt = ''
      " Use pt for normal file search with ignore support
      let g:unite_source_rec_async_command = ['pt', '--nocolor', '--nogroup', '-g', '""']
    elseif executable('ack-grep')
      " Use ack in unite grep source.
      let g:unite_source_grep_command = 'ack-grep'
      let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
      let g:unite_source_grep_recursive_opt = ''
    endif
  " }}
  " VimFiler settings {{
    function s:my_vimfiler_settings()
      setlocal nonumber
      setlocal norelativenumber
    endfunction
    autocmd FileType vimfiler call s:my_vimfiler_settings()

    let g:vimfiler_as_default_explorer = 1
  " }}
  " YCM+UltiSnips settings {{
    function! BuildYCM(info)
      " info is a dictionary with 3 fields
      " - name:   name of the plugin
      " - status: 'installed', 'updated', or 'unchanged'
      " - force:  set on PlugInstall! or PlugUpdate!
      if a:info.status == 'installed' || a:info.force
        !./install.py --clang-completer
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

    let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
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
  " }}
  " Syntastic settings {{
    " Use ESLint for better ES6 and JSX support
    let g:syntastic_javascript_checkers = ['eslint']
    " Automatically populate location list upon loading, so we can jump to
    " error warnings.
    " Since we have vim-unimpaired, jumping is as simple as ']l' and '[l'
    let g:syntastic_always_populate_loc_list = 1
  " }}
  " JSDoc settings {{
    " Disable default mapping <C-l>
    let g:jsdoc_default_mapping = 0
  " }}
  " Rust settings {{
    " Path to racer cmd
    let g:racer_cmd = "$HOME/.cargo/bin/racer"
  " }}
" }}
" Load plugins {{
call plug#begin()
  Plug 'rust-lang/rust.vim'                                     " Rust language support
  Plug 'tpope/vim-repeat'                                       " Repeat support for complex mappings
  Plug 'tpope/vim-sensible'                                     " Sensible defaults for Vim
  Plug 'tpope/vim-surround'                                     " csXX for quotes, braces, etc.
  Plug 'tpope/vim-unimpaired'                                   " Pair commands
  Plug 'tpope/vim-eunuch'                                       " Shell tools
  Plug 'tpope/vim-fugitive'                                     " Git control from Vim
  Plug 'vim-scripts/marvim'                                     " Macros Repository
  Plug 'godlygeek/tabular'                                      " Editing and aligning tabular data easily
  Plug 'boazy/drchip-vis'                                       " Vim Block Commands (B and S)
  Plug 'dr-chip-vim-scripts/ZoomWin'                            " Zoom in/out windows with <c-w>o
  Plug 'kana/vim-textobj-user'                                  " Library for custom text objects
  Plug 'kana/vim-textobj-fold'                                  " Fold text object (az/iz)
  Plug 'kana/vim-textobj-indent'                                " Idented blocks (ai/ii)
  Plug 'kana/vim-textobj-syntax'                                " Syntax highlighted item (ay/iy)
  Plug 'sgur/vim-textobj-parameter'                             " Comma-separated arguments (a,/i,)
  Plug 'glts/vim-textobj-comment'                               " Comments text object (ac/ic)
  Plug 'whatyouhide/vim-textobj-xmlattr'                        " Xml Attribute text object (ax/ix)
  Plug 'Julian/vim-textobj-variable-segment'                    " Variable name segment (av/iv)
  Plug 'frankier/neovim-colors-solarized-truecolor-only'        " Solarized color scheme (needs terminal support)
  Plug 'pangloss/vim-javascript'                                " Better JavaScript syntax
  Plug 'heavenshell/vim-jsdoc'                                  " Generate JSDoc
  Plug 'gkz/vim-ls'                                             " LiveScript syntax and make
  Plug 'mxw/vim-jsx'                                            " JSX support
  Plug 'wavded/vim-stylus'                                      " Stylus support
  Plug 'digitaltoad/vim-jade'                                   " Jade support
  Plug 'jeffkreeftmeijer/vim-numbertoggle'                      " Relative line numbers
  Plug 'racer-rust/vim-racer'                                   " Vim Racer (Rust language completion)
  Plug 'easymotion/vim-easymotion'                              " Motion Hints 
  Plug 'junegunn/vim-easy-align'                                " Easy align
  Plug 'rizzatti/dash.vim'                                      " Dash support
  Plug 'chrisbra/SudoEdit.vim'                                  " Read/write files with admin/root permissions
  Plug 'rking/ag.vim', { 'on': 'Ag' }                           " Grep with 'ag' command
  Plug 'simnalamburt/vim-mundo', { 'on': 'MundoToggle' }        " Graphical Undo Tree
  Plug 'SirVer/ultisnips'                                       " Auto-insert snippets
  Plug 'honza/vim-snippets'                                     " Snippet repository for snipmate/ultisnips/neosnippet
  Plug 'Shougo/vimproc.vim', { 'do': function('BuildVimProc') } " Async subprocesses
  Plug 'Shougo/Unite.vim'                                       " Incremental search UI
  Plug 'Shougo/vimfiler.vim'                                    " Vim file manager
  Plug 'scrooloose/nerdcommenter'                               " Commenting bindings for many languages
  Plug 'scrooloose/syntastic'                                   " Syntax highlighting for many languages
  Plug 'bling/vim-airline'                                      " Lightweight status line
  if s:os != 'windows'
    Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
  endif

  " --- Type-specific ---
  Plug 'tpope/vim-git', { 'for': 'git' }
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
  Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'javascript.jsx'] }
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
" Plugin Triggers {{
  " Install Emmet hooks only for HTML and CSS files
  autocmd FileType html,css,javascript.jsx EmmetInstall
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
  " Open vsplits to the right
  set splitright
" }}
" Appearance {{
" Color scheme
  set background=dark
  colorscheme solarized
" }}
" GUI settings {{
  set termguicolors
  if has("gui_vimr")
  else
    if s:os == "osx"
      set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h11
    elseif s:os == "windows"
      set guifont=Powerline_Consolas:h11
    endif
  endif
" }}
" === Tweaks ===
" Grabbed from SPF13 {{
  " Most prefer to automatically switch to the current file directory when
  " a new buffer is opened; to prevent this behavior, add the following to
  " your .vimrc.before.local file:
  let g:spf13_no_autochdir = 1
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
" Perl-style (very magic) regex for slash-find {{
  " Default '/' is taken by EasyMotion
  nnoremap g/ /\v
  vnoremap g/ /\v
  nnoremap g? ?\v
  vnoremap g? ?\v
" }}
" === Custom Functions ===
" :Verbose (from scriptease.vim) {{

command! -range=999998 -nargs=1 -complete=command Verbose
      \ :exe s:Verbose(<count> == 999998 ? '' : <count>, <q-args>)

function! s:Verbose(level, excmd)
  let temp = tempname()
  let verbosefile = &verbosefile
  call writefile([':'.a:level.'Verbose '.a:excmd], temp, 'b')
  return
        \ 'try|' .
        \ 'let &verbosefile = '.string(temp).'|' .
        \ 'silent '.a:level.'verbose exe '.string(a:excmd).'|' .
        \ 'finally|' .
        \ 'let &verbosefile = '.string(verbosefile).'|' .
        \ 'endtry|' .
        \ 'pedit '.temp.'|wincmd P|nnoremap <buffer> q :bd<CR>'
endfunction

" }}
" BufferOrTab Prev/Next/First/Last {{
function! s:BufferOrTabCmd(cmd)
  let tabcnt = tabpagenr('$')
  let cmd = a:cmd
  if tabcnt == 1
    " Move through buffers if only one tab page is open
    execute 'b'.cmd
  else
    " Move through tabs otherwise
    execute 'tab'.cmd
  endif
endfunction

" }}
" === Key mappings ===
function s:AfterPlugins()
" Custom commands {{
  command Vrc :e ~/.vimrc
" }}
" Plugin key mappings {{
  " Unite.vim key mappings {{
    " Todo, add neo_mru, buffertab, build string accordingly
    nnoremap <Leader>u :<C-u>Unite -start-insert<CR>
    nnoremap gy :<C-u>Unite -start-insert history/yank<CR>
    nnoremap gb :<C-u>Unite -start-insert buffer<CR>
    if exists('s:has_vimproc') && s:has_vimproc
      nnoremap <C-p> :<C-u>Unite -start-insert -toggle file_rec/async buffer<CR>
    else
      nnoremap <C-p> :<C-u>Unite -start-insert -toggle file_rec buffer<CR>
    endif
  " }}
  " VimFiler key mappings {{
    nmap <silent><F4> :VimFilerExplorer<CR>
  " }}
  " EasyAlign key mappings {{
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
  " }}
  " EasyMotion {{
    " Select line in entire screen
    nmap L <Plug>(easymotion-bd-jk)
    " /-Search motion
    map  / <Plug>(easymotion-sn)
    omap / <Plug>(easymotion-tn)

    " 2-char search motions
    nmap s <Plug>(easymotion-s2)
    omap z <Plug>(easymotion-t2)

  " }}
  " Dash {{
  nmap <silent> g- <Plug>DashSearch
  nnoremap <silent><F5> :MundoToggle<CR>
  autocmd filetype javascript nnoremap <silent>sd :JsDoc<CR>
  " }}
  " Unimpaired {{
  command BTprevious :exe s:BufferOrTabCmd('previous')
  command BTnext     :exe s:BufferOrTabCmd('next')
  command BTfirst    :exe s:BufferOrTabCmd('first')
  command BTlast     :exe s:BufferOrTabCmd('last')

  " Override unimpaired mappings
  nnoremap <silent> [b :<C-U>bp<CR>
  nnoremap <silent> ]b :<C-U>bn<CR>
  nnoremap <silent> [B :<C-U>BTfirst<CR>
  nnoremap <silent> ]B :<C-U>BTlast<CR>
  nnoremap <silent> [w :<C-U>wincmd W<CR>
  nnoremap <silent> ]w :<C-U>wincmd w<CR>
  " }}
" }}
" General key mappings {{
  " HR below the current line in the same length
  nnoremap <leader>hr yypVr=
  " Quick save
  nnoremap ZW :w<CR>
  " select last pasted text with 'gp'
  nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
  " replace word under cursor
  nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
  " Terminal emulation
  nnoremap <silent> zt :terminal<CR>
  " Close (delete) buffer
  nnoremap <silent> zq :bdelete<CR>
" }}
" System clipboard {{
  if s:os != 'windows'
    " Remap clipboard
    nmap <silent>\c   :let @+=@"<CR>
    nmap <silent>\v   :let @"=@+<CR>
  endif
" }}
" Terminal {{
  tnoremap <A-`> <C-\><C-n>
  tnoremap <A-Tab> <C-\><C-n><C-w>w
  nnoremap <A-Tab> <C-w>w
" }}
endfunction
autocmd VimEnter * call s:AfterPlugins()
