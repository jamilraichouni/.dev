vim.cmd [[
    colorscheme codedark
    highlight BookmarkSign ctermbg=NONE ctermfg=160 guifg=#569cd6
    highlight BookmarkAnnotationSign ctermbg=NONE ctermfg=160 guifg=#569cd6
    highlight Comment ctermfg=239 guifg=#5f5f5f cterm=italic gui=italic
    highlight! link Folded Comment
    highlight CursorLineNr ctermfg=9 guifg=#af0000
    highlight StatusLine ctermbg=blue ctermfg=white guibg=#002240 guifg=#c0c0c0
    highlight StatusLineNC ctermbg=black ctermfg=white guibg=#121212 guifg=#767676
    highlight TabLine ctermbg=black ctermfg=white guibg=#121212 guifg=#767676
    highlight TabLineSel ctermbg=blue ctermfg=white guibg=#002240 guifg=#c0c0c0
    highlight! link IncSearch DiffChange
    highlight! link Search DiffChange
]]
