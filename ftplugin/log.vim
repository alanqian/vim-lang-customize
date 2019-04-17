" Set nice colors
" background for normal text is light grey
" Text below the last line is darker grey
" Cursor is green
" Constants are not underlined but have a slightly lighter background
highlight Normal guibg=grey90
highlight Cursor guibg=Green guifg=NONE
highlight NonText guibg=grey80
highlight Constant gui=NONE guibg=grey95
highlight Special gui=NONE guibg=grey95
highlight Comment term=bold ctermfg=6
highlight Search NONE
highlight Search term=reverse cterm=reverse

" For view log files
highlight CursorLine term=standout cterm=standout ctermfg=4 ctermbg=7
highlight PreProc term=underline cterm=bold ctermfg=8
highlight TabLine term=underline ctermfg=0 ctermbg=7
highlight TabLineSel term=underline cterm=bold ctermfg=7 ctermbg=0
highlight TabLineFill term=underline ctermfg=7 ctermbg=1
