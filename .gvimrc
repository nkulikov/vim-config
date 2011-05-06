set nocp
set number
set nobackup
set nowritebackup
set history=100
set nowrap
set tabstop=4
set statusline=%<%F%h%m%r%=\[%B\]\ %l,%c%V\ %P
set laststatus=2
set showcmd
set gcr=a:blinkon0
set errorbells
set visualbell
set nowarn
set ignorecase
set smartcase

syntax on
set nowrap list listchars=eol:¶,tab:»·,trail:·,extends:▸,precedes:◂
hi NonText ctermfg=7 guifg=lightcyan
hi SpecialKey ctermfg=7 guifg=lightcyan
if has('gui_running')
  set t_Co=256
  set guifont=Menlo:h14
  set guioptions-=T

" grow to maximum horizontal width on entering fullscreen mode
set fuopt+=maxhorz

" remove all scrolls
  set guioptions-=r
  set guioptions-=l
  set guioptions-=L
endif

au BufNewFile,BufRead SConstruct,SConscript,SConscript-debug,SConscript-release set filetype=python

" Clang code-completion support. This is somewhat experimental!
let g:clang_complete_auto = 1
"let g:clang_path = "/opt/local/bin"
let g:clang_snippets = 1
let g:clang_use_library = 1
let g:clang_library_path = "/Users/lostar/.vim/plugin/clang/lib"
"let g:clang_opts = [
"  \ "-x","c++",
"  \ "-D__STDC_LIMIT_MACROS=1","-D__STDC_CONSTANT_MACROS=1",
"  \ "-Iinclude" ]
"
"function! ClangComplete(findstart, base)
"   if a:findstart == 1
"      " In findstart mode, look for the beginning of the current identifier.
"      let l:line = getline('.')
"      let l:start = col('.') - 1
"      while l:start > 0 && l:line[l:start - 1] =~ '\i'
"         let l:start -= 1
"      endwhile
"      return l:start
"   endif
"
"   " Get the current line and column numbers.
"   let l:l = line('.')
"   let l:c = col('.')
"
"   " Build a clang commandline to do code completion on stdin.
"   let l:the_command = shellescape(g:clang_path) .
"                     \ " -cc1 -code-completion-at=-:" . l:l . ":" . l:c
"   for l:opt in g:clang_opts
"      let l:the_command .= " " . shellescape(l:opt)
"   endfor
"
"   " Copy the contents of the current buffer into a string for stdin.
"   " TODO: The extra space at the end is for working around clang's
"   " apparent inability to do code completion at the very end of the
"   " input.
"   " TODO: Is it better to feed clang the entire file instead of truncating
"   " it at the current line?
"   let l:process_input = join(getline(1, l:l), "\n") . " "
"
"   " Run it!
"   let l:input_lines = split(system(l:the_command, l:process_input), "\n")
"
"   " Parse the output.
"   for l:input_line in l:input_lines
"      " Vim's substring operator is annoyingly inconsistent with python's.
"      if l:input_line[:11] == 'COMPLETION: '
"         let l:value = l:input_line[12:]
"
"        " Chop off anything after " : ", if present, and move it to the menu.
"        let l:menu = ""
"        let l:spacecolonspace = stridx(l:value, " : ")
"        if l:spacecolonspace != -1
"           let l:menu = l:value[l:spacecolonspace+3:]
"           let l:value = l:value[:l:spacecolonspace-1]
"        endif
"
"        " Chop off " (Hidden)", if present, and move it to the menu.
"        let l:hidden = stridx(l:value, " (Hidden)")
"        if l:hidden != -1
"           let l:menu .= " (Hidden)"
"           let l:value = l:value[:l:hidden-1]
"        endif
"
"        " Handle "Pattern". TODO: Make clang less weird.
"        if l:value == "Pattern"
"           let l:value = l:menu
"           let l:pound = stridx(l:value, "#")
"           " Truncate the at the first [#, <#, or {#.
"           if l:pound != -1
"              let l:value = l:value[:l:pound-2]
"           endif
"        endif
"
"         " Filter out results which don't match the base string.
"         if a:base != ""
"            if l:value[:strlen(a:base)-1] != a:base
"               continue
"            end
"         endif
"
"        " TODO: Don't dump the raw input into info, though it's nice for now.
"        " TODO: The kind string?
"        let l:item = {
"          \ "word": l:value,
"          \ "menu": l:menu,
"          \ "info": l:input_line,
"          \ "dup": 1 }
"
"        " Report a result.
"        if complete_add(l:item) == 0
"           return []
"        endif
"        if complete_check()
"           return []
"        endif
"
"      elseif l:input_line[:9] == "OVERLOAD: "
"         " An overload candidate. Use a crazy hack to get vim to
"         " display the results. TODO: Make this better.
"         let l:value = l:input_line[10:]
"         let l:item = {
"           \ "word": " ",
"           \ "menu": l:value,
"           \ "info": l:input_line,
"           \ "dup": 1}
"
"        " Report a result.
"        if complete_add(l:item) == 0
"           return []
"        endif
"        if complete_check()
"           return []
"        endif
"
"      endif
"   endfor
"
"   return []
"endfunction ClangComplete

" This to enables the somewhat-experimental clang-based
" autocompletion support.
"set omnifunc=ClangComplete

filetype on
filetype plugin on
let filetype_m='objc'

" Highlight trailing whitespace and lines longer than 80 columns.
highlight LongLine ctermbg=DarkYellow guibg=DarkYellow
highlight WhitespaceEOL ctermbg=DarkYellow guibg=DarkYellow
if v:version >= 702
  " Lines longer than 80 columns.
  au BufWinEnter * let w:m0=matchadd('LongLine', '\%>80v.\+', -1)

  " Whitespace at the end of a line. This little dance suppresses
  " whitespace that has just been typed.
"  au BufWinEnter * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
"  au InsertEnter * call matchdelete(w:m1)
"  au InsertEnter * let w:m2=matchadd('WhitespaceEOL', '\s\+\%#\@<!$', -1)
"  au InsertLeave * call matchdelete(w:m2)
"  au InsertLeave * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
else
  au BufRead,BufNewFile * syntax match LongLine /\%>80v.\+/
"  au InsertEnter * syntax match WhitespaceEOL /\s\+\%#\@<!$/
"  au InsertLeave * syntax match WhitespaceEOL /\s\+$/
endif

" (Objective)C/C++ programming helpers
"augroup csrc
"  au!
"  autocmd FileType *      set nocindent smartindent
"  autocmd FileType c,cpp  set cindent
"  autocmd FileType m,mm   set cindent
"augroup END

map <F2> :NERDTreeToggle<CR>

" shortcuts for fast move between split window
map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l
map <A-h> <C-W>h<C-W>_
map <A-j> <C-W>j<C-W>_
map <A-k> <C-W>k<C-W>_
map <A-l> <C-W>l<C-W>_

" sortcuts for fast move between tabs
map <S-TAB> :tabn<CR>

" open new tab shortcut
map <C-T> :tabe<CR>
