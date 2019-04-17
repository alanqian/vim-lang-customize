"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => c/c++ section

" Vim indent file
" Language: C++
" Maintainer: Konstantin Lepa <konstantin.lepa@gmail.com>
" Last Change:  2010 May 20
" License: MIT
" Version: 1.1.0
"
" Changes {{{
" 1.1.0 2011-01-17
"   Refactored source code.
"   Some fixes.
"
" 1.0.1 2010-05-20
"   Added some changes. Thanks to Eric Rannaud <eric.rannaud@gmail.com>
"
"}}}

if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

function! GoogleCppIndent()
  let l:cline_num = line('.')

  let l:orig_indent = cindent(l:cline_num)

  if l:orig_indent == 0 | return 0 | endif

  let l:pline_num = prevnonblank(l:cline_num - 1)
  let l:pline = getline(l:pline_num)
  if l:pline =~# '^\s*template' | return l:pline_indent | endif

  " TODO: I don't know to correct it:
  " namespace test {
  " void
  " ....<-- invalid cindent pos
  "
  " void test() {
  " }
  "
  " void
  " <-- cindent pos
  if l:orig_indent != &shiftwidth | return l:orig_indent | endif

  let l:in_comment = 0
  let l:pline_num = prevnonblank(l:cline_num - 1)
  while l:pline_num > -1
    let l:pline = getline(l:pline_num)
    let l:pline_indent = indent(l:pline_num)

    if l:in_comment == 0 && l:pline =~ '^.\{-}\(/\*.\{-}\)\@<!\*/'
      let l:in_comment = 1
    elseif l:in_comment == 1
      if l:pline =~ '/\*\(.\{-}\*/\)\@!'
        let l:in_comment = 0
      endif
    elseif l:pline_indent == 0
      if l:pline !~# '\(#define\)\|\(^\s*//\)\|\(^\s*{\)'
        if l:pline =~# '^\s*namespace.*'
          return 0
        else
          return l:orig_indent
        endif
      elseif l:pline =~# '\\$'
        return l:orig_indent
      endif
    else
      return l:orig_indent
    endif

    let l:pline_num = prevnonblank(l:pline_num - 1)
  endwhile

  return l:orig_indent
endfunction

setlocal noundofile
setlocal wrap
setlocal expandtab
setlocal textwidth=90
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal formatoptions=croqtmM 
setlocal cindent
setlocal cinoptions=:0,l1,g0.5s,h0.5s,t0,i1.5s,+1.5s,(0,w1,W1.5s
setlocal indentexpr=GoogleCppIndent()
setlocal comments=sr:/*,mb:*,ex:*/,://
setlocal completeopt=longest,menu
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn .git generated'
let b:undo_indent = "setl sw< ts< sts< et< tw< wrap< cin< cino< inde<"

setlocal makeprg=make\ -j
setlocal grepprg=egrep\ -n\ $*\ /dev/null
" c++/* stands for current version in system, eg. 7.3.0
setlocal path+=,/usr/local/include/c++/*,../include,../src,

"setlocal efm to correct g++ 4.5.x prompt & ld prompt
au FileType c,cc,cpp setlocal efm=%+GIn\ file\ included\ from\ %m,%+Gcollect2:\ %m,%f%l:\ %m,%f:%l:%c:\ %m,%f:%l:\ %m
au BufReadPost quickfix  setlocal wrap
"skip .cc .cpp files since they are modified frequently
au BufWritePre *.h :call ClangFormat()

"quickfix shortcuts: next/previous error

setlocal pastetoggle=<C-F11>
map <F4> :cn<cr>
map <S-F4> :cp<cr>

map <C-F4> <Esc>:tn<cr>
map <C-F3> <Esc>:tp<cr>

"see http://en.kioskea.net/faq/2367-the-autocompletion-c-c-in-vim
"setlocal complete+=k$HOME/../dots/vim/keywords.cpp.txt
 
"obsoluted
"let g:syntastic_cpp_compiler = 'clang++'
"let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
