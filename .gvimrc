" Supplementary functions {{{

function! s:isLinux()
  return has("unix") && count(split(system("uname"), '\n'), 'Linux')
endfunction

function! s:isMac()
  return has("mac") && count(split(system("uname"), '\n'), 'Darwin')
endfunction

function! s:enableSpellChecker()
  if &filetype =~ 'nerdtree|tagbar|qf|help'
    return
  endif

  setlocal spell
endfun

function! ToggleBackgroundSafely()
  let &background = (&background == "dark"? "light" : "dark")
  colorscheme solarized
  call s:setupColors()
  call s:setupYcmColors()
endfun

function! s:setupColors()
  " Corrections for solarized theme
  highlight MatchParen ctermbg=none guibg=red
  if &background == "dark"
    highlight Cursor                                        guibg=fg
    highlight CursorLine  ctermbg=233                       guibg=#171717
    highlight Visual      ctermbg=LightGray                 guibg=#EEE8D5
  else
    highlight CursorLine  ctermbg=Gray                      guibg=Gray
    highlight Visual      ctermbg=Yellow                    guibg=Magenta
    highlight VertSplit                                     guibg=DarkGray
  endif

  highlight Cursor                                          guibg=fg

  if !has("gui")
    highlight SpecialKey    ctermbg=bg           ctermfg=238
  endif
endfun

function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

" quckfix & location lists

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec('botright '.a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

" Setup pathogen plugin
"runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
execute pathogen#helptags()
syntax on
filetype on

" }}}

" General {{{

set nocp
set number
set nobackup
set nowritebackup
set noswapfile
set history=100
set laststatus=2
set showcmd
set nowarn
set ignorecase
set smartcase
set linebreak

" Setup status line
set statusline=
set statusline+=%<%f%h%m%r\ 
set statusline+=[%{strlen(&ft)?&ft:'none'},
set statusline+=%{strlen(&fenc)?&fenc:&enc},
set statusline+=%{&fileformat}]%=
"set statusline+=%{SyntasticStatuslineFlag()}\ 
set statusline+=⍖\ %l/%L,\ ⍆\ %c,\ '0x%04B'\ 

" Setup cursor style
set guicursor+=a:blinkon0

" Disable nasty sound beeps
set noerrorbells
set vb t_vb=

" Folds defined by markers in the text.
set foldmethod=marker

" The screen will not be redrawn while executing macros,
" registers and other commands that have not been typed.
set lazyredraw

" Persistent undo file
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 " max number of changes that can be undone
set undoreload=10000 " max number lines to save for undo on a buffer reload

" When a file has been detected to have been changed outside of Vim and
" it has not been changed inside of Vim, automatically read it again.
" When the file has been deleted this is not done.
set autoread

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
" Q: Is it really needed?
set notimeout
set ttimeout
set ttimeoutlen=10

" Improves smoothness of redrawing when there are multiple
" windows and the terminal does not support a scrolling region.
set ttyfast

" Delete text past the start of the insert.
set backspace=indent,eol,start

" Move around the screen freely while in visual block mode to define your
" selections.
set virtualedit=block

" copy/paste to/from clipboard
if s:isLinux()
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" This makes Vim display the match for the string while you are still
" typing it.
set incsearch

" This means that all matches in a line are substituted instead of one.
set gdefault

" This stops the search at the end of the file.
set nowrapscan

" Place new vertical splits to the right of the current pane, and horizontal
" splits below the current pane.
set splitbelow
set splitright

" Display unprintable characters
set list

" Set pretty split border and fold marker
set fillchars=fold:·,vert:│

set background=dark
colorscheme solarized
"
call s:setupColors()

if has('gui_running')
  set guifont=Fira\ Mona:h14

  " Unprintable characters mapping
  set listchars=eol:¬,extends:»,precedes:◂,tab:▸\ ,trail:·

  " Remove toolbar
  set guioptions-=T

  " Grow to maximum horizontal width on entering fullscreen mode
  set fuopt+=maxhorz

  " Remove all scroll
  set guioptions-=r
  set guioptions-=l
  set guioptions-=L
else " console UI settings
  " Unprintable characters mapping
  set listchars=eol:↩,extends:»,precedes:◂,tab:⇥\ ,trail:·

  " Enable 256 colors
  set t_Co=256

  if s:isLinux()
    " adjust keycodes of FN + Shift keys for terminal vim
    set <S-F2>=O1;2Q
    set <S-F3>=O1;2R
    set <S-F4>=O1;2S
    set <S-F5>=[15;2~
    set <S-F6>=[17;2~
    set <S-F7>=[18;2~
    set <S-F8>=[19;2~
    set <S-F9>=[20;2~
  endif
endif

" The minimal number of columns to scroll horizontally.
set sidescroll=1

" Line continuation markers used when wrap is off
set listchars+=precedes:◀,extends:►

" Set scons as build tool
set makeprg=scons

" Number of lines to scroll with CTRL-U and CTRL-D commands.
set scroll=5

" Minimal number of screen lines to keep above and below the cursor.
"
set scrolloff=3

" Command-line completion by <Tab>
set wildmenu

" When more than one match, list all matches and do not complete longes
" longes common string (like list:longest)
set wildmode=list

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files

" Some completion options:
" * Use a popup menu so show the possible completion.
" * Use the popup menu also when there is only one match.
" * Only insert the longest common text of the matches.
set completeopt=menu,menuone,longest,preview

set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>

" }}}

" Autocommands. {{{

sign define dummy_sign
autocmd BufEnter *
  \ :execute 'sign place 9999 line=1 name=dummy_sign buffer=' . bufnr('')

" NOTE: Temporary disabled because somehow this conflicts with Gentoo default
" vim scripts
" automatic cleanup trailing spaces and tab for newly created files
"augroup BufNewFile
"  autocmd Filetype cpp,ruby,eruby,yaml,javascript,python
"    \ autocmd BufWritePre <buffer>
"      \ :execute "normal mz" | %s/\s\+$//e | :execute "normal `z"
"augroup END

" Correct filetype detection
autocmd BufNewFile,BufReadPre SConstruct*,SConscript* set filetype=python
autocmd BufRead,BufNewFile *.tpl set filetype=smarty
autocmd BufReadCmd *.epub call zip#Browse(expand("<amatch>"))

" Text formatting

" treat new file with unspecified type as plain text
autocmd BufEnter * if &filetype == "" | setlocal ft=text | endif

" plain text formatting
" (a) autoformating of paragraphs and (w) trailing whitespace for paragraph
" continuation on next line
autocmd FileType text
  \ setlocal formatoptions+=aw

autocmd FileType ruby,python,php
  \ setlocal expandtab shiftwidth=4 softtabstop=4 nowrap
  \ smartindent cinwords=if,elif,else,for,while,try,except,finally,def,cla
autocmd FileType eruby,yaml,javascript
  \ setlocal expandtab shiftwidth=2 softtabstop=2 nowrap
autocmd BufNewFile,BufReadPre .vimrc,.gvimrc
  \ setlocal expandtab shiftwidth=2 softtabstop=2 nowrap
"autocmd FileType cpp
"  \ setlocal noexpandtab shiftwidth=4 softtabstop=0 tabstop=4 nowrap
"  \ cindent cinoptions="(1s,u1s,U0,l1,g1,h-1" matchpairs="(:),{:},[:],<:>"
" Switch tab -> spaces
autocmd FileType cpp
  \ setlocal expandtab shiftwidth=4 softtabstop=0 tabstop=4 nowrap
  \ cindent cinoptions=(1s,u1s,U0,l1,g1,h-1 matchpairs=(:),{:},[:],<:>
autocmd FileType sh,vim,snippets
  \ setlocal noexpandtab tabstop=8 nowrap

" Enable spell checker everywhere except help
autocmd BufNewFile,BufReadPre,BufNew * call s:enableSpellChecker()
autocmd FileType help setlocal nospell

" Highlighting trailing columns in lines longer than 80 columns.
autocmd FileType cpp,ruby,eruby,python,yaml,javascript,sh,gitcommit
  \ set colorcolumn=80
autocmd BufNewFile,BufReadPre .vimrc,gvimrc
  \ set colorcolumn=80
autocmd FileType qf
  \ set colorcolumn=0

" Highlight cursor only in current window
augroup CursorLine
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter,InsertLeave * setlocal cursorline
  autocmd WinLeave,InsertEnter * setlocal nocursorline
augroup END

" Resize splits when the window is resized
autocmd VimResized * :wincmd =

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Highlight whitespaces at the end of line
" note: This feature disabled because it is slightly annoyed in some situation.
"       Solarized plugin has own way to mark such cases (visible only in
"       cursor line).
"autocmd BufWinEnter *.cpp,*.h,*.hpp,*.c,*.m,*.mm,SConstruct*,SConscript*
"  \ let w:m1=matchadd('WhitespaceEOL', '\s\+$\| \+\ze\t')

" }}}

" Keymapping. {{{

" CAUTION:
"  - In general, when you create a mapping that only applies to specific
"    buffers you should use <localleader> instead of <leader>. Using two
"    separate leader keys provides a sort of "namespacing".

" Workaround for unpleasant mapping established by a plugin
noremap <F1>    <nop>
noremap <F2>    <nop>
noremap <F3>    <nop>
noremap <F4>    <nop>
noremap <F5>    <nop>
noremap <F6>    <nop>

noremap <F7>    :make! -Q -s -j 4<CR>
noremap <C-F7>  :make!<CR>

" manual cleanup trailing spaces and tab in current buffer
noremap <F8>    :%s/\s\+$//e<CR>

noremap <F10>   :silent! !ctags
  \ -R --c++-kinds=+p --fields=+iaS --extra=+q .
  \ --exclude='.git' --exclude='.release' --exclude='.debug' &<CR>

" Manual refresh YouCompileMe diagnostics
"noremap <F11>   :YcmForceCompileAndDiagnostics<CR>

" Map solarized dark/ligth switch
noremap <F12>   :call ToggleBackgroundSafely()<CR>

let mapleader = ","
let maplocalleader = "\\"

" Toggle NERDTree window
"noremap <Leader>f    :NERDTreeToggle<CR>

" Toggle Tagbar window
noremap <Leader>t    :TagbarToggle<CR>

" Grep word under cursor
noremap <Leader>g    :exec("Ag -sw ".expand("<cword>"))<CR>

" Switch between declaration and definition of symbol
"noremap <Leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Toggle quickfix/location lists
noremap <Leader>q  :call ToggleList("Quickfix List", 'c')<CR>
noremap <Leader>l  :call ToggleList("Location List", 'l')<CR>

" Quick switching (Ctrl + h/j/k/l) between splits
noremap <C-h>   :wincmd h<CR>
noremap <BS>    :wincmd h<CR>
noremap <C-j>   :wincmd j<CR>
noremap <C-k>   :wincmd k<CR>
noremap <C-l>   :wincmd l<CR>

" Quick switching (Shift/Ctrl + Tab) between tabs
"noremap <S-TAB> :tabn<CR>
"noremap <C-T>   :tabe<CR>

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" Keep the cursor in place when join lines with J
nnoremap J mzJ`z

" Center the window automatically around the cursor after jumping to a location with motions like n or }
nnoremap n nzz
nnoremap } }zz

" j and k keys should move by row instead of line.
nnoremap j gj
nnoremap k gk

" Emulate ESC via jk/kj and disable all alternative mappings
"inoremap jk <esc>
inoremap kj <esc>
inoremap <esc> <nop>
inoremap <C-[> <nop>

" Open help in vertical (instead of horizontal) split
cnoremap help vert help

"}}}

" Setup Syntastic (DISABLED). {{{
"
""let g:syntastic_debug = 1
"
"" Syntastic status line like [✗✗ 5, ≫≫ 10]
"let g:syntastic_stl_format = '[%E{✗✗ %e}%B{, }%W{≫≫ %w}]'
"
"" Change default mark symbol (>>) to new one
"let g:syntastic_error_symbol = "✗✗"
"let g:syntastic_warning_symbol = "≫≫"
"let g:syntastic_style_error_symbol = "⋆⋆"
"let g:syntastic_style_warning_symbol = "⋆⋆"
"
"function! s:setupSyntasticColors()
"  " Sigh mark colors
"  " TODO: remove color hardcode and use solarized color name
"  if &background == "dark"
"    highlight SyntasticErrorSign         ctermbg=Black  ctermfg=DarkRed      guibg=#073642  guifg=red
"    highlight SyntasticWarningSign       ctermbg=Black  ctermfg=DarkYellow   guibg=#073642  guifg=orange
"    highlight SyntasticStyleErrorSign    ctermbg=Black  ctermfg=DarkRed      guibg=#073642  guifg=red
"    highlight SyntasticStyleWarningSign  ctermbg=Black  ctermfg=DarkYellow   guibg=#073642  guifg=orange
"  else
"    highlight SyntasticErrorSign         ctermbg=LightGray  ctermfg=DarkRed     guibg=#eee8d5  guifg=red
"    highlight SyntasticWarningSign       ctermbg=LightGray  ctermfg=DarkYellow  guibg=#eee8d5  guifg=orange
"    highlight SyntasticStyleErrorSign    ctermbg=LightGray  ctermfg=DarkRed     guibg=#eee8d5  guifg=red
"    highlight SyntasticStyleWarningSign  ctermbg=LightGray  ctermfg=DarkYellow  guibg=#eee8d5  guifg=orange
"  endif
"endfun
"
"call s:setupSyntasticColors()
"
"" Check buffer when open/save
"let g:syntastic_check_on_open=1
"
"" Populate location list with warnings/errors
"let g:syntastic_always_populate_loc_list = 1
"
" }}}
" Setup netrw (DISABLED). {{{

"let g:netrw_altv = 1
"let g:netrw_fastbrowse = 0
"let g:netrw_keepdir = 0
"let g:netrw_list_hide= '\(^\|\s\s\)\zs\.\S\+'
"let g:netrw_liststyle = 0
"let g:netrw_retmap = 1
"let g:netrw_silent = 1
"let g:netrw_special_syntax = 1

" }}}
" Setup Ag (https://github.com/ggreer/the_silver_searcher). {{{
" instead of Grep when available.

if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
endif

" }}}
" Setup tagbar. {{{

set updatetime=500 " 500 ms sync delay for position (buffer -> list of tags)
let g:tagbar_compact = 1 " remove help and empty lines
let g:tagbar_foldlevel = 0 " collapse all folding by default
let g:tagbar_iconchars = ['▸', '▾']

"highlight TagbarHighlight

" }}}
" Setup solarized. {{{

" Special characters such as trailing whitespace, tabs, newlines, when 
" displayed using ":set list" can be set to one of three levels
let g:solarized_visibility = "low"

" Enables highlighting of trailing spaces (only one of the listchar types,
" but a particularly important one) while in the cursoline in a different
" manner in order to make them more visible.
let g:solarized_hitrail = 1

" Disable bold fonts
let g:solarized_bold = 0

" Colors for diff mode
let g:solarized_diffmode = "high"

" }}}
" Setup YouCompleteMe (DISABLED). {{{
"
"" Make Syntastic & YCM more responsive
"set updatetime=500 " ms
"let g:ycm_allow_changing_updatetime = 0
"let g:ycm_confirm_extra_conf = 0
"
"" Fallback if no project specific YCM configuration is found.
"let g:ycm_global_ycm_extra_conf = '~/.ycm_global_extra_conf.py'
"
"function! s:setupYcmColors()
"  " Sigh mark colors
"  " TODO: remove color hardcode and use solarized color name
"  if &background == "dark"
"    highlight YcmErrorSign         ctermbg=Black  ctermfg=DarkRed      guibg=#073642  guifg=red
"    highlight YcmWarningSign       ctermbg=Black  ctermfg=DarkYellow   guibg=#073642  guifg=orange
""    highlight SyntasticStyleErrorSign    ctermbg=Black  ctermfg=DarkRed      guibg=#073642  guifg=red
""    highlight SyntasticStyleWarningSign  ctermbg=Black  ctermfg=DarkYellow   guibg=#073642  guifg=orange
"  else
"    highlight YcmErrorSign         ctermbg=LightGray  ctermfg=DarkRed     guibg=#eee8d5  guifg=red
"    highlight YcmWarningSign       ctermbg=LightGray  ctermfg=DarkYellow  guibg=#eee8d5  guifg=orange
""    highlight SyntasticStyleErrorSign    ctermbg=LightGray  ctermfg=DarkRed     guibg=#eee8d5  guifg=red
""    highlight SyntasticStyleWarningSign  ctermbg=LightGray  ctermfg=DarkYellow  guibg=#eee8d5  guifg=orange
"  endif
"endfun
"
"call s:setupYcmColors()
"
" }}}
" Setup UltiSnips. {{{

" Expand selected snip
let g:UltiSnipsExpandTrigger = "<tab>"

" Open snip editor in vertical split
let g:UltiSnipsEditSplit = "vertical"

" }}}
" Setup CScope. {{{

if has("cscope")

    " try to add the database from current dir
    cscope add cscope.out

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " be more verbosive when add new database
    set cscopeverbose

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " show msg when any other cscope db added
    set cscopeverbose

    " find all references to the token under cursor
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>

    " find global definition(s) of the token under cursor
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>

    " find all calls to the function name under cursor
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>

    " find all instances of the text under cursor
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>

    " egrep search for the word under cursor
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>

    " open the filename under cursor
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>

    " find files that include the filename under cursor
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

    " find functions that function under cursor calls
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif

" }}}
" Setup jedi-vim (DISABLED). {{{
"
"" Disable autocomplete because it it YCM duty. This plugin used only for
"" displaying documentation (keymap: K) and params expansion for Python.
"let g:jedi#completions_enabled = 1
"
" }}}
" Setup python-mode. {{{

let g:pymode_virtualenv = 1
let g:pymode_folding = 0
let g:pymode_rope_complete_on_dot = 1
let g:pymode_lint_error_symbol = '✗✗'

" }}}
" Setup unite.vim {{{

let g:unite_data_directory='~/.vim/.cache/unite'

" Fuzzy match by default
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

" Fuzzy matching for plugins not using matcher_default as filter
call unite#custom#source('outline,line,grep,session', 'matchers', ['matcher_fuzzy'])

let g:unite_source_rec_max_cache_files = 0
call unite#custom#source('file_rec,file_rec/async,file_mru,file,buffer,grep', 'max_candidates', 0)

" Keep track of yanks
let g:unite_source_history_yank_enable = 1

" Prettier prompt
call unite#custom#profile('default', 'context', {
  \ 'prompt': '» ',
  \ 'start_insert': 1,
  \ 'marked_icon': '✓',
  \ 'update_time': 200,
  \ 'cursor_line_highlight': 'UniteSelectedLine',
  \ 'direction': 'botright',
  \ 'prompt_direction': 'top',
  \ })

" Autosave sessions for unite-sessions
let g:unite_source_session_enable_auto_save = 1

" Non-ugly colors for selected item, requires you to set 'hi UnitedSelectedLine'
let g:unite_cursor_line_highlight = "UniteSelectedLine"

" Set to some better time formats
let g:unite_source_buffer_time_format = "%Y-%m-%d  %H:%M:%S  "
let g:unite_source_file_mru_time_format = "%Y-%m-%d  %H:%M:%S  "

" Use ag
let g:unite_source_file_async_command = 'ag --nocolor --nogroup --hidden -g ""'
let g:unite_source_rec_async_command =
  \ ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts =
  \'--nocolor --nogroup --hidden --ignore-case'
let g:unite_source_grep_recursive_opt = ''

let g:unite_source_codesearch_ignore_case = 1

function! g:DoUniteFuzzy()
    call unite#custom#source('file_rec/async,file/new', 'sorters', 'sorter_rank')
    call unite#custom#source('file_rec/async,file/new', 'converters', 'converter_relative_word')
    call unite#custom#source('file_rec/async,file/new', 'matchers', 'matcher_fuzzy')
    exec "Unite -buffer-name=files file_rec/async file/new"
endfunction
function! g:DoUniteNonFuzzy()
    call unite#custom#source('file_rec/async,file/new', 'sorters', 'sorter_nothing')
    call unite#custom#source('file_rec/async,file/new', 'converters', 'converter_relative_word')
    call unite#custom#source('file_rec/async,file/new', 'matchers', 'matcher_glob')
    exec "Unite -buffer-name=files file_rec/async file/new"
endfunction
function! g:DoUniteFuzzyQuickfix()
    call unite#custom#source('quickfix', 'sorters', 'sorter_rank')
    call unite#custom#source('quickfix', 'matchers', 'matcher_fuzzy')
    exec "Unite -buffer-name=quickfix quickfix"
endfunction
function! g:DoUniteNonFuzzyQuickfix()
    call unite#custom#source('quickfix', 'sorters', 'sorter_nothing')
    call unite#custom#source('quickfix', 'matchers', 'matcher_glob')
    exec "Unite -buffer-name=quickfix quickfix"
endfunction
function! UltiSnipsCallUnite()
    Unite -immediately -no-empty -vertical -buffer-name=ultisnips ultisnips
    return ''
endfunction

inoremap <silent><leader>l<tab> <C-R>=(pumvisible()? "\<LT>C-E>":"")<CR><C-R>=UltiSnipsCallUnite()<CR>
nnoremap <silent><leader>l<tab> a<C-R>=(pumvisible()? "\<LT>C-E>":"")<CR><C-R>=UltiSnipsCallUnite()<CR>
nnoremap <silent><leader>lr :call g:DoUniteFuzzy()<CR>
nnoremap <silent><leader>lR :call g:DoUniteNonFuzzy()<CR>
nnoremap <silent><leader>lq :call g:DoUniteFuzzyQuickfix()<CR>
nnoremap <silent><leader>lQ :call g:DoUniteNonFuzzyQuickfix()<CR>
nnoremap <silent><leader>le :<C-u>Unite -buffer-name=files file_mru bookmark<CR>
nnoremap <silent><leader>lE :<C-u>Unite -buffer-name=files file_mru bookmark file_rec/async file/new<CR>
nnoremap <silent><leader>lB :<C-u>Unite -buffer-name=buffers buffer<CR>
nnoremap <silent><leader>lb :<C-u>Unite -buffer-name=buffers buffer_tab<CR>
nnoremap <silent><leader>ly :<C-u>Unite -buffer-name=yanks history/yank<CR>
nnoremap <silent><leader>lc :<C-u>Unite -buffer-name=changes change<CR>
nnoremap <silent><leader>lj :<C-u>Unite -buffer-name=jumps jump<CR>
nnoremap <silent><leader>lf :<C-u>Unite -buffer-name=jumps jump<CR>
nnoremap <silent><leader>l; :<C-u>Unite -buffer-name=commands history/command<CR>
nnoremap <silent><leader>l/ :<C-u>Unite -buffer-name=commands history/search<CR>
nnoremap <silent><leader>lo :<C-u>Unite -buffer-name=outline outline<CR>
nnoremap <silent><leader>la :<C-u>Unite -buffer-name=outline -vertical outline<CR>
nnoremap <silent><leader>ll :<C-u>Unite -buffer-name=line line<CR>
nnoremap <silent><leader>lw :<C-u>Unite -buffer-name=location_list location_list<CR>
nnoremap <silent><leader>l* :<C-u>UniteWithCursorWord -buffer-name=line line<CR>
nnoremap <silent><leader>lg :<C-u>Unite -buffer-name=grep grep<CR>
nnoremap <silent><leader>lG "zyiw:<C-u>Unite -buffer-name=grepword grep<CR><CR><C-R>z<CR>
vnoremap <silent><leader>lG "zy:<C-u>Unite -buffer-name=grepword grep<CR><CR><C-R>z<CR>
nnoremap <silent><leader>ls :<C-u>Unite session<CR>
nnoremap <silent><leader>lt :<C-u>Unite -buffer-name=tags tag<CR>
nnoremap <silent><leader>lT :<C-u>Unite -buffer-name=tagfiles tag/file<CR>
nnoremap <silent><leader>li :<C-u>Unite -buffer-name=autotags tag/include<CR>
nnoremap <silent><leader>ld :<C-u>Unite -buffer-name=change-cwd -default-action=lcd directory_mru directory<CR>
nnoremap <silent><leader>l, :<C-u>UniteResume<CR>
nnoremap <silent><leader>lv :<C-u>UniteResume<CR>
nnoremap <silent><leader>lV :<C-u>UniteResume

nnoremap <leader>lS :<C-u>UniteSessionSave

" }}}
" Setup vitality {{{
let g:vitality_fix_focus=0
" }}}

"set foldmethod=syntax
"set foldlevelstart=1

let xml_syntax_folding=1      " XML

" test mode
set sessionoptions=folds,localoptions,sesdir

" apply per-project configuration
set secure
set exrc
