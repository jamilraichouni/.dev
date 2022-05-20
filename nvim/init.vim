" Core {{{
set shell=/bin/zsh
let g:python3_host_prog = "/usr/local/bin/python3"
let jarvim_dir = $HOME .. "/repos/jarvim"
if isdirectory(jarvim_dir)
    let &runtimepath.=",".jarvim_dir
endif
set autoindent

" Use system clipboard
" http://stackoverflow.com/questions/8134647/copy-and-paste-in-vim-via-keyboard-between-different-mac-terminals
" set clipboard+=unnamed

set colorcolumn=88
set completeopt="menuone,noinsert,noselect,preview"
" set completeopt="menuone,noinsert,noselect"
" set completeopt="menuone,preview"
set cursorline
set cursorlineopt=number
set expandtab  " blanks instead of tab
set ignorecase
set laststatus=2
" Highlight tailing whitespace
set list listchars=tab:\ \ ,trail:·
set mouse=a
set nobackup
set noswapfile
set nowrap
set nowritebackup
set number
set path+=**  " search down into subdirs, provide tab-completion for all file-related tasks
set relativenumber
set shiftwidth=4
" Don't show intro
" set shortmess+=I
set smartcase
set splitbelow
set splitright
set tabstop=4  " tab width
set termguicolors  " needed by plugin feline
set wildmenu  " display all matching files when we tab complete

filetype plugin indent on

" Set built-in file system explorer to use layout similar to the NERDTree plugin
let g:netrw_liststyle=3
" }}}
" plugins {{{

" Theme reset before any plugin changes something:
set background=dark
highlight clear
syntax reset

if has("nvim")
    lua require('plugins')
else
    call plug#begin()

    " https://github.com/tomasiser/vim-code-dark
    plug 'tomasiser/vim-code-dark'

    " https://github.com/tpope/vim-commentary
    plug 'tpope/vim-commentary'

    " https://github.com/tpope/vim-surround
    plug 'tpope/vim-surround'

    " https://github.com/MattesGroeger/vim-bookmarks
    plug 'MattesGroeger/vim-bookmarks'

    " https://github.com/tpope/vim-repeat
    plug 'tpope/vim-repeat'

    " https://github.com/vim-airline/vim-airline
    plug 'vim-airline/vim-airline'

    " https://github.com/tpope/vim-fugitive
    plug 'tpope/vim-fugitive'

    " https://github.com/fladson/vim-kitty
    plug 'fladson/vim-kitty'

    " https://github.com/airblade/vim-gitgutter
    plug 'https://github.com/airblade/vim-gitgutter'

    " https://github.com/dense-analysis/ale
    plug 'https://github.com/dense-analysis/ale'

    " https://github.com/ycm-core/YouCompleteMe
    " IMPORTANT: I could only build YouCompleteMe via 'YCM_CORES=1 ./install.py --verbose'
    plug 'ycm-core/YouCompleteMe', { 'do': 'python3 ./install.py --all' }

    plug 'SirVer/ultisnips'

    " https://github.com/iamcco/markdown-preview.nvim
    plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

    " https://github.com/puremourning/vimspector
    plug 'puremourning/vimspector'

    " https://github.com/vim-python/python-syntax
    plug 'vim-python/python-syntax'

    call plug#end()
    colorscheme codedark
endif
" }}}
" Functions {{{
" Search literally via command :Search <LITERAL>
com! -nargs=1 Search :let @/='\V'.escape(<q-args>, '\\')| normal! n

function! OpenDoc()
  tabnew $DEVHOME/JARDOC.md
  MarkdownPreview
endfunction

function! SetupFolding()
    setlocal foldmethod=indent
    " execute 'execute "silent %foldopen!"'
    " execute 'execute "silent %foldclose"'
endfunction

function! SetIndentWidth(width)
    let width = str2nr(a:width)
    let &tabstop=width
    let &softtabstop=width
    let &shiftwidth=width
endfunction

function! Scratch()
    split
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    "setlocal nobuflisted
    "lcd ~
    file scratch
endfunction

function! SetupPython()
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set expandtab
    set autoindent
    set fileformat=unix
endfunction

" https://github.com/neovim/neovim/issues/8816#issuecomment-539224440
let g:previous_window = -1
function! SmartInsert()
  if &buftype == 'terminal'
    if g:previous_window != winnr()
      startinsert
    endif
    let g:previous_window = winnr()
  else
    let g:previous_window = -1
  endif
endfunction

function! ToggleNumber()
    if (&number || &rnu)
        set nonumber
        set norelativenumber
    else
        set relativenumber
        hi LineNr ctermfg=grey guifg=grey
    endif
endfunction


function! ToggleRelativeNumber()
    if &rnu
        set norelativenumber
        set number
        hi LineNr ctermfg=white guifg=#d7875f
    else
        set relativenumber
        hi LineNr ctermfg=grey guifg=gre guifg=grey
    endif
endfunction
" }}}
" Events {{{
" https://learnvimscriptthehardway.stevelosh.com/chapters/12.html#autocommands

" COMMON EVENTS ------------------------------------------------------------------------
autocmd BufEnter * call SmartInsert()
autocmd BufNewFile,BufReadPost *.aird,*.bash*,bash_*,*.css,*.html,*.js,*.md,*.reqif,*.xml,*.zsh*,zsh_* call SetIndentWidth(2)
autocmd BufNewFile,BufReadPost *.csv setlocal filetype=csv
autocmd BufNewFile,BufReadPost *.py call SetupPython()
autocmd BufReadPost builddesc*.yml setlocal foldmethod=indent
autocmd BufReadPost *.json setlocal foldnestmax=1 foldmethod=indent
autocmd BufReadPost *.lua,*.py call SetupFolding()
autocmd BufReadPost *.reqif setlocal filetype=xml syntax=xml
autocmd BufReadPost .bash* setlocal syntax=sh
autocmd BufReadPost init.vim,plugins.lua setlocal foldmethod=marker
autocmd BufReadPost lsp.log setlocal wrap
autocmd BufWritePost *.snippets CmpUltisnipsReloadSnippets
autocmd BufWritePost */jarvim/**/*.py UpdateRemoteplugins
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
if has("nvim")
  autocmd TermOpen * setlocal colorcolumn=0 nonumber norelativenumber | startinsert!
  autocmd TermClose * call feedkeys("i")
endif
" FILETYPE EVENTS ----------------------------------------------------------------------
autocmd FileType Trouble setlocal wrap
" }}}
" Keymaps {{{
let mapleader=","

" Disable arrow keys in normal mode:
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>

" Disable arrow keys in visual mode:
vnoremap <left> <nop>
vnoremap <right> <nop>
vnoremap <up> <nop>
vnoremap <down> <nop>

" leave insert mode of terminal as it is in vim:
tnoremap <c-w>N <c-\><c-n>
" tnoremap <c-r> <nop>

" Clear search highlighting:
nnoremap <leader>, :noh<cr>

" line numbers:
noremap <silent><leader>ll :call ToggleNumber()<cr>
noremap <silent><leader>rr :call ToggleRelativeNumber()<cr>
" Register and load remote plugins:
nnoremap <leader>uu :UpdateRemoteplugins<cr>

" Edit specific files:
nnoremap <leader>doc :call OpenDoc()<cr>
" nnoremap <leader>erc :e $DEVHOME/zsh/zsh_all<cr>
nnoremap <leader>erc :e $DEVHOME/zsh/zsh_macos<bar>:new $DEVHOME/zsh/zsh_all<bar>:nohlsearch<bar>:wincmd k<bar>:resize 10<bar>:wincmd j<cr>
nnoremap <leader>ewt :e $HOME/repos/finances/data/working_times.csv<cr>
nnoremap <leader>init :e $HOME/.config/nvim/init.vim<cr>
nnoremap <leader>plug :e $HOME/.config/nvim/lua/plugins.lua<cr>
nnoremap <leader>lsp :e $HOME/.config/nvim/lua/config/nvim-lspconfig.lua<cr>
nnoremap <leader>theme :e $HOME/.config/nvim/lua/config/vim-code-dark.lua<cr>

" tools:
nnoremap <leader>top <cmd>tabnew<bar>terminal htop<cr>

" resize window:
nnoremap <silent><left> :vertical resize -5<cr>
nnoremap <silent><right> :vertical resize +5<cr>
nnoremap <silent><up> :resize +5<cr>
nnoremap <silent><down> :resize -5<cr>

" Source zsh config:
nnoremap <leader>sinit :source $HOME/.config/nvim/init.vim<cr>
nnoremap <leader>src :!source $HOME/.zshrc<cr>

" Browse specific locations:
nnoremap <leader>cc <cmd>find /Users/jamilraichouni/repos/cookiecutters/python/*cookiecutter.PROJECT_SLUG*<cr>

" Completion
inoremap <c-space> <c-x><c-o>
inoremap <c-@> <c-space>

" Folding
nnoremap <silent><leader>f1 <cmd>%foldclose<cr>
nnoremap <silent><leader>f0 <cmd>%foldopen!<cr>

" terminal
nnoremap <silent><leader>tt <cmd>terminal<cr>
nnoremap <silent><leader>th <cmd>leftabove vnew +terminal<cr>
nnoremap <silent><leader>tj <cmd>new +terminal<cr>
nnoremap <silent><leader>tk <cmd>aboveleft new +terminal<cr>
nnoremap <silent><leader>tl <cmd>vnew +terminal<cr>

" ipython
nnoremap <silent><leader>ii <cmd>terminal ipython --profile jar<cr>
nnoremap <silent><leader>ih <cmd>leftabove vnew <bar> terminal ipython --profile jar<cr>
nnoremap <silent><leader>ij <cmd>new <bar> terminal ipython --profile jar<cr>
nnoremap <silent><leader>ik <cmd>aboveleft new <bar> terminal ipython --profile jar<cr>
nnoremap <silent><leader>il <cmd>vnew <bar> terminal ipython --profile jar<cr>


" LSP (maps: https://github.com/neovim/nvim-lspconfig#suggested-configuration)
nnoremap <silent><leader>ld <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <silent><leader>lf <cmd>lua vim.lsp.buf.formatting()<cr>
nnoremap <silent><leader>lh <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap <silent><leader>li <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap <silent><leader>lj <cmd>lua vim.diagnostic.goto_next{wrap=false,popup_opts={border="single"}}<cr>
nnoremap <silent><leader>lk <cmd>lua vim.diagnostic.goto_prev{wrap=false,popup_opts={border="single"}}<cr>
nnoremap <silent><leader>ln <cmd>lua vim.lsp.buf.rename()<cr>
nnoremap <silent><leader>lr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent><leader>lt <cmd>TroubleToggle document_diagnostics<cr>

" vimspector:
" mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
nmap <leader>dr <cmd>VimspectorReset<cr>

" for normal mode - the word under the cursor
nmap <leader>di <plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <leader>di <plug>VimspectorBalloonEval

" " Debug Adapter Protocol client (DAP) https://github.com/mfussenegger/nvim-dap
" " see :h dap-mappings or :h dap.txt

" " f9 or <leader>bb
" nnoremap <silent><f9> :lua require"dap".toggle_breakpoint()<cr>
" " f5 or <leader>br
" nnoremap <silent><f5> :lua require"dap".continue()<cr>
" " f6 or <leader>brl
" nnoremap <silent><f6> :lua require"dap".run_last()<cr>
" " <leader><f5> or <leader>b<Esc>
" nnoremap <silent><leader><f5> :lua require"dap".terminate()<cr>

" " f10 or <leader>bn
" nnoremap <silent><f10> :lua require"dap".step_over()<cr>
" " f11 or <leader>bs
" nnoremap <silent><f11> :lua require"dap".step_into()<cr>
" " <leader><f11> or <leader>bu ("u" comes from "up" [pdb])
" nnoremap <silent><leader><f11> :lua require"dap".step_out()<cr>


" nnoremap <silent><leader>bt :lua require"dap".repl.toggle()<cr>

" nnoremap <silent><leader>. :lua require"dapui".toggle()<cr>
" nnoremap <silent><leader>bfs :lua require"dapui".float_element("scopes", { enter = true, width = 80, height = 80 })<cr>
" nnoremap <silent><leader>bff :lua require"dapui".float_element(require"dap.ui.widgets".frames)<cr>

" nnoremap <silent><leader>bB :lua require"dap".list_breakpoints()<cr>
" nnoremap <silent><leader>bc :lua require"dap".set_breakpoint(vim.fn.input("Condition: "))<cr>
" nnoremap <silent><leader>bl :lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<cr>
" nnoremap <silent><leader>bi :lua require"dap.ui.widgets".hover()<cr>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files hidden=true ignore=.git<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fl <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>fm <cmd>Telescope vim_bookmarks<cr>

nnoremap <leader>defined <cmd>lua require('telescope.builtin').grep_string({search='"status": "DEFINED"', search_dirs={"jobs"}, word_match="-w", prompt_title="FAILED jobs"})<cr>
nnoremap <leader>failed <cmd>lua require('telescope.builtin').grep_string({search='"status": "FAILED"', search_dirs={"jobs"}, word_match="-w", prompt_title="FAILED jobs"})<cr>
nnoremap <leader>success <cmd>lua require('telescope.builtin').grep_string({search='"status": "SUCCESS"', search_dirs={"jobs"}, word_match="-w", prompt_title="SUCCESS jobs"})<cr>
nnoremap <leader>trace <cmd>lua require('telescope.builtin').grep_string({search='Trace', search_dirs={"jobs"}})<cr>

nnoremap <silent><leader>gla <cmd>lua require("jar.telescope").my_git_commits()<cr>
nnoremap <silent><leader>glc <cmd>lua require("jar.telescope").my_git_bcommits()<cr>
nnoremap <silent><leader>gs <cmd>lua require("jar.telescope").my_git_status()<cr>

" Bookmarks:
nnoremap <silent>ma <cmd>:BookmarkAnnotate<cr>
nnoremap <silent>ml <cmd>:BookmarkShowAll<cr>

" misc:
nnoremap <c-p> :bprevious<cr>
nnoremap <c-n> :bnext<cr>
nnoremap <leader>hl :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" }}}
" Theme {{{
set background=dark
let g:colors_name="JAR"

function! <sid>hi(group, fg, bg, attr, sp)
  if !empty(a:fg)
    exec "highlight " . a:group . " guifg=" . a:fg.gui
  endif
  if !empty(a:bg)
    exec "highlight " . a:group . " guibg=" . a:bg.gui
  endif
  if a:attr != ""
    exec "highlight " . a:group . " gui=" . a:attr
  endif
  if !empty(a:sp)
    exec "highlight " . a:group . " guisp=" . a:sp.gui
  endif
endfun

" color definitions:

" common colors:
let s:None = {'gui': 'NONE'}
let s:Front = {'gui': '#d4d4d4'}
let s:Back = {'gui': '#1e1e1e'}
let s:Number = {'gui': '#ff628c'}

let s:TabCurrent = {'gui': '#1e1e1e'}
let s:TabOther = {'gui': '#000000'}
let s:TabOutside = {'gui': '#252526'}

let s:LeftDark = {'gui': '#252526'}
let s:LeftMid = {'gui': '#373737'}
let s:LeftLight = {'gui': '#3f3f46'}

let s:PopupFront = {'gui': '#bbbbbb'}
let s:PopupBack = {'gui': '#2d2d30'}
let s:PopupHighlightBlue = {'gui': '#073655'}
let s:PopupHighlightGray = {'gui': '#3d3d40'}

let s:SplitLight = {'gui': '#898989'}
let s:SplitDark = {'gui': '#444444'}
let s:SplitThumb = {'gui': '#424242'}

let s:CursorDarkDark = {'gui': '#222222'}
let s:CursorDark = {'gui': '#51504f'}
let s:CursorLight = {'gui': '#aeafad'}
let s:Selection = {'gui': '#264f78'}
let s:LineNumber = {'gui': '#5f5f5f'}

let s:DiffRedDark = {'gui': '#4b1818'}
let s:DiffRedLight = {'gui': '#6f1313'}
let s:DiffRedLightLight = {'gui': '#fb0101'}
let s:DiffGreenDark = {'gui': '#373d29'}
let s:DiffGreenLight = {'gui': '#4b5632'}

let s:SearchCurrent = {'gui': '#4b5632'} 
let s:Search = {'gui': '#264f78'}

" syntax colors:
let s:Gray = {'gui': '#808080'}
let s:Violet = {'gui': '#646695'}
let s:Blue = {'gui': '#569cd6'}
let s:DarkBlue = {'gui': '#223e55'}
let s:LightBlue = {'gui': '#9cdcfe'}
let s:Green = {'gui': '#6a9955'}
let s:BlueGreen = {'gui': '#4ec9b0'}
let s:LightGreen = {'gui': '#b5cea8'}
let s:Red = {'gui': '#f44747'}
let s:Orange = {'gui': '#ce9178'}
let s:LightRed = {'gui': '#d16969'}
let s:YellowOrange = {'gui': '#d7ba7d'}
let s:Yellow = {'gui': '#dcdcaa'}
let s:Pink = {'gui': '#c586c0'}
let s:Silver = {'gui': '#c0c0c0'}

" Vim editor colors
call <sid>hi('Normal', s:Front, s:Back, 'none', {})
call <sid>hi('Comment', {'gui': '#5f5f5f'}, {}, 'italic', {})
call <sid>hi('SpecialComment', {'gui': '#5f5f5f'}, {}, 'italic', {})
call <sid>hi('ColorColumn', {}, s:CursorDarkDark, 'none', {})
call <sid>hi('Cursor', s:CursorDark, s:CursorLight, 'none', {})
call <sid>hi('CursorLine', {}, s:CursorDarkDark, 'none', {})
call <sid>hi('CursorColumn', {}, s:CursorDarkDark, 'none', {})
call <sid>hi('Directory', s:Blue, s:Back, 'none', {})
call <sid>hi('DiffAdd', {}, s:DiffGreenLight, 'none', {})
call <sid>hi('DiffChange', {}, s:DiffRedDark, 'none', {})
call <sid>hi('DiffDelete', {}, s:DiffRedLight, 'none', {})
call <sid>hi('DiffText', {}, s:DiffRedLight, 'none', {})
call <sid>hi('EndOfBuffer', s:LineNumber, s:Back, 'none', {})
call <sid>hi('ErrorMsg', s:Red, s:Back, 'none', {})
call <sid>hi('VertSplit', s:SplitDark, s:Back, 'none', {})
call <sid>hi('Folded', s:LeftLight, s:LeftDark, 'underline', {})
call <sid>hi('FoldColumn', s:LineNumber, s:Back, 'none', {})
call <sid>hi('SignColumn', {}, s:Back, 'none', {})
call <sid>hi('IncSearch', s:None, s:SearchCurrent, 'none', {})
call <sid>hi('LineNr', s:LineNumber, s:Back, 'none', {})
call <sid>hi('CursorLineNr', {'gui': '#ff0000'}, s:Back, 'none', {})
call <sid>hi('MatchParen', s:None, s:CursorDark, 'none', {})
call <sid>hi('ModeMsg', s:Front, s:LeftDark, 'none', {})
call <sid>hi('MoreMsg', s:Front, s:LeftDark, 'none', {})
call <sid>hi('NonText', s:LineNumber, s:Back, 'none', {})
call <sid>hi('Pmenu', s:PopupFront, s:PopupBack, 'none', {})
call <sid>hi('PmenuSel', s:PopupFront, s:PopupHighlightBlue, 'none', {})
call <sid>hi('PmenuSbar', {}, s:PopupHighlightGray, 'none', {})
call <sid>hi('PmenuThumb', {}, s:PopupFront, 'none', {})
call <sid>hi('Question', s:Blue, s:Back, 'none', {})
call <sid>hi('Search', s:None, s:Search, 'none', {})
call <sid>hi('SpecialKey', s:Blue, s:None, 'none', {})
call <sid>hi('StatusLine', s:Front, s:LeftMid, 'none', {})
call <sid>hi('StatusLineNC', s:Front, s:LeftDark, 'none', {})
call <sid>hi('TabLine', {'gui': '#929292'}, s:TabOther, 'none', {})
call <sid>hi('TabLineFill', s:Front, s:TabOutside, 'none', {})
call <sid>hi('TabLineSel', s:Front, s:TabCurrent, 'none', {})
call <sid>hi('Title', s:None, s:None, 'bold', {})
call <sid>hi('Visual', s:None, s:Selection, 'none', {})
call <sid>hi('VisualNOS', s:None, s:Selection, 'none', {})
call <sid>hi('WarningMsg', s:Orange, s:Back, 'none', {})
call <sid>hi('WildMenu', s:None, s:Selection, 'none', {})

call <sid>hi('Constant', s:Blue, {}, 'none', {})
call <sid>hi('String', s:Orange, {}, 'none', {})
call <sid>hi('Character', s:Orange, {}, 'none', {})
call <sid>hi('Number', s:Number, {}, 'none', {})
call <sid>hi('Boolean', s:Blue, {}, 'none', {})
call <sid>hi('Float', s:Number, {}, 'none', {})

call <sid>hi('Identifier', s:LightBlue, {}, 'none', {})
call <sid>hi('Function', s:Yellow, {}, 'none', {})

call <sid>hi('Statement', s:Pink, {}, 'none', {})
call <sid>hi('Conditional', s:Pink, {}, 'none', {})
call <sid>hi('Repeat', s:Pink, {}, 'none', {})
call <sid>hi('Label', s:Pink, {}, 'none', {})
call <sid>hi('Operator', s:Front, {}, 'none', {})
call <sid>hi('Keyword', s:Pink, {}, 'none', {})
call <sid>hi('Exception', s:Pink, {}, 'none', {})

call <sid>hi('PreProc', s:Pink, {}, 'none', {})
call <sid>hi('Include', s:Pink, {}, 'none', {})
call <sid>hi('Define', s:Pink, {}, 'none', {})
call <sid>hi('Macro', s:Pink, {}, 'none', {})
call <sid>hi('PreCondit', s:Pink, {}, 'none', {})

call <sid>hi('Type', s:Blue, {}, 'none', {})
call <sid>hi('StorageClass', s:Blue, {}, 'none', {})
call <sid>hi('Structure', s:Blue, {}, 'none', {})
call <sid>hi('Typedef', s:Blue, {}, 'none', {})

call <sid>hi('Special', s:YellowOrange, {}, 'none', {})
call <sid>hi('SpecialChar', s:Front, {}, 'none', {})
call <sid>hi('Tag', s:Front, {}, 'none', {})
call <sid>hi('Delimiter', s:Front, {}, 'none', {})
call <sid>hi('SpecialComment', s:Green, {}, 'italic', {})
call <sid>hi('Debug', s:Front, {}, 'none', {})

call <sid>hi('Underlined', s:None, {}, 'underline', {})
call <sid>hi("Conceal", s:Front, s:Back, 'none', {})

call <sid>hi('Ignore', s:Front, {}, 'none', {})

call <sid>hi('Error', s:Red, s:Back, 'undercurl', s:Red)

call <sid>hi('Todo', s:None, s:LeftMid, 'none', {})

call <sid>hi('SpellBad', s:Red, s:Back, 'undercurl', s:Red)
call <sid>hi('SpellCap', s:Red, s:Back, 'undercurl', s:Red)
call <sid>hi('SpellRare', s:Red, s:Back, 'undercurl', s:Red)
call <sid>hi('SpellLocal', s:Red, s:Back, 'undercurl', s:Red)

" Neovim Treesitter:
call <sid>hi('TSError', s:Red, {}, 'none', {})
call <sid>hi('TSPunctDelimiter', s:Front, {}, 'none', {})
call <sid>hi('TSPunctBracket', s:Front, {}, 'none', {})
call <sid>hi('TSPunctSpecial', s:Front, {}, 'none', {})
" Constant
call <sid>hi('TSConstant', s:Yellow, {}, 'none', {})
call <sid>hi('TSConstBuiltin', s:Blue, {}, 'none', {})
call <sid>hi('TSConstMacro', s:BlueGreen, {}, 'none', {})
call <sid>hi('TSStringRegex', s:Orange, {}, 'none', {})
call <sid>hi('TSString', s:Orange, {}, 'none', {})
call <sid>hi('TSStringEscape', s:YellowOrange, {}, 'none', {})
call <sid>hi('TSCharacter', s:Orange, {}, 'none', {})
call <sid>hi('TSNumber', s:LightGreen, {}, 'none', {})
call <sid>hi('TSBoolean', s:Blue, {}, 'none', {})
call <sid>hi('TSFloat', s:LightGreen, {}, 'none', {})
call <sid>hi('TSAnnotation', s:Yellow, {}, 'none', {})
call <sid>hi('TSAttribute', s:BlueGreen, {}, 'none', {})
call <sid>hi('TSNamespace', s:BlueGreen, {}, 'none', {})
" Functions
call <sid>hi('TSFuncBuiltin', s:Yellow, {}, 'none', {})
call <sid>hi('TSFunction', s:Yellow, {}, 'none', {})
call <sid>hi('TSFuncMacro', s:Yellow, {}, 'none', {})
call <sid>hi('TSParameter', s:LightBlue, {}, 'none', {})
call <sid>hi('TSParameterReference', s:LightBlue, {}, 'none', {})
call <sid>hi('TSMethod', s:Yellow, {}, 'none', {})
call <sid>hi('TSField', s:LightBlue, {}, 'none', {})
call <sid>hi('TSProperty', s:LightBlue, {}, 'none', {})
call <sid>hi('TSConstructor', s:BlueGreen, {}, 'none', {})
" Keywords
call <sid>hi('TSConditional', s:Pink, {}, 'none', {})
call <sid>hi('TSRepeat', s:Pink, {}, 'none', {})
call <sid>hi('TSLabel', s:LightBlue, {}, 'none', {})
call <sid>hi('TSKeyword', s:Blue, {}, 'none', {})
call <sid>hi('TSKeywordFunction', s:Blue, {}, 'none', {})
call <sid>hi('TSKeywordOperator', s:Blue, {}, 'none', {})
call <sid>hi('TSOperator', s:Front, {}, 'none', {})
call <sid>hi('TSException', s:Pink, {}, 'none', {})
call <sid>hi('TSType', s:BlueGreen, {}, 'none', {})
call <sid>hi('TSTypeBuiltin', s:Blue, {}, 'none', {})
call <sid>hi('TSStructure', s:LightBlue, {}, 'none', {})
call <sid>hi('TSInclude', s:Pink, {}, 'none', {})
" Variable
call <sid>hi('TSVariable', s:LightBlue, {}, 'none', {})
call <sid>hi('TSVariableBuiltin', s:LightBlue, {}, 'none', {})
" Text
call <sid>hi('TSText', s:YellowOrange, {}, 'none', {})
call <sid>hi('TSStrong', s:YellowOrange, {}, 'none', {})
call <sid>hi('TSEmphasis', s:YellowOrange, {}, 'none', {})
call <sid>hi('TSUnderline', s:YellowOrange, {}, 'none', {})
call <sid>hi('TSTitle', s:YellowOrange, {}, 'none', {})
call <sid>hi('TSLiteral', s:YellowOrange, {}, 'none', {})
call <sid>hi('TSURI', s:YellowOrange, {}, 'none', {})
" Tags
call <sid>hi('TSTag', s:Blue, {}, 'none', {})
call <sid>hi('TSTagDelimiter', s:Gray, {}, 'none', {})

" Markdown:
call <sid>hi('markdownBold', s:Blue, {}, 'bold', {})
call <sid>hi('markdownCode', s:Orange, {}, 'none', {})
call <sid>hi('markdownRule', s:Blue, {}, 'bold', {})
call <sid>hi('markdownCodeDelimiter', s:Orange, {}, 'none', {})
call <sid>hi('markdownHeadingDelimiter', s:Blue, {}, 'none', {})
call <sid>hi('markdownFootnote', s:Orange, {}, 'none', {})
call <sid>hi('markdownFootnoteDefinition', s:Orange, {}, 'none', {})
call <sid>hi('markdownUrl', s:LightBlue, {}, 'underline', {})
call <sid>hi('markdownLinkText', s:Orange, {}, 'none', {})
call <sid>hi('markdownEscape', s:YellowOrange, {}, 'none', {})

" Asciidoc (for default syntax highlighting)
call <sid>hi("asciidocAttributeEntry", s:YellowOrange, {}, 'none', {})
call <sid>hi("asciidocAttributeList", s:Pink, {}, 'none', {})
call <sid>hi("asciidocAttributeRef", s:YellowOrange, {}, 'none', {})
call <sid>hi("asciidocHLabel", s:Blue, {}, 'bold', {})
call <sid>hi("asciidocListingBlock", s:Orange, {}, 'none', {})
call <sid>hi("asciidocMacroAttributes", s:YellowOrange, {}, 'none', {})
call <sid>hi("asciidocOneLineTitle", s:Blue, {}, 'bold', {})
call <sid>hi("asciidocPassthroughBlock", s:Blue, {}, 'none', {})
call <sid>hi("asciidocQuotedMonospaced", s:Orange, {}, 'none', {})
call <sid>hi("asciidocTriplePlusPassthrough", s:Yellow, {}, 'none', {})
call <sid>hi("asciidocMacro", s:Pink, {}, 'none', {})
call <sid>hi("asciidocAdmonition", s:Orange, {}, 'none', {})
call <sid>hi("asciidocQuotedEmphasized", s:Blue, {}, 'italic', {})
call <sid>hi("asciidocQuotedEmphasized2", s:Blue, {}, 'italic', {})
call <sid>hi("asciidocQuotedEmphasizedItalic", s:Blue, {}, 'italic', {})
hi! link asciidocBackslash Keyword
hi! link asciidocQuotedBold markdownBold
hi! link asciidocQuotedMonospaced2 asciidocQuotedMonospaced
hi! link asciidocQuotedUnconstrainedBold asciidocQuotedBold
hi! link asciidocQuotedUnconstrainedEmphasized asciidocQuotedEmphasized
hi! link asciidocURL markdownUrl

" JSON:
call <sid>hi('jsonKeyword', s:LightBlue, {}, 'none', {})
call <sid>hi('jsonEscape', s:YellowOrange, {}, 'none', {})
call <sid>hi('jsonNull', s:Blue, {}, 'none', {})
call <sid>hi('jsonBoolean', s:Blue, {}, 'none', {})

" HTML:
call <sid>hi('htmlTag', s:Gray, {}, 'none', {})
call <sid>hi('htmlEndTag', s:Gray, {}, 'none', {})
call <sid>hi('htmlTagName', s:Blue, {}, 'none', {})
call <sid>hi('htmlSpecialTagName', s:Blue, {}, 'none', {})
call <sid>hi('htmlArg', s:LightBlue, {}, 'none', {})

" PHP:
call <sid>hi('phpStaticClasses', s:BlueGreen, {}, 'none', {})
call <sid>hi('phpMethod', s:Yellow, {}, 'none', {})
call <sid>hi('phpClass', s:BlueGreen, {}, 'none', {})
call <sid>hi('phpFunction', s:Yellow, {}, 'none', {})
call <sid>hi('phpInclude', s:Blue, {}, 'none', {})
call <sid>hi('phpUseClass', s:BlueGreen, {}, 'none', {})
call <sid>hi('phpRegion', s:BlueGreen, {}, 'none', {})
call <sid>hi('phpMethodsVar', s:LightBlue, {}, 'none', {})

" CSS:
call <sid>hi('cssBraces', s:Front, {}, 'none', {})
call <sid>hi('cssInclude', s:Pink, {}, 'none', {})
call <sid>hi('cssTagName', s:YellowOrange, {}, 'none', {})
call <sid>hi('cssClassName', s:YellowOrange, {}, 'none', {})
call <sid>hi('cssPseudoClass', s:YellowOrange, {}, 'none', {})
call <sid>hi('cssPseudoClassId', s:YellowOrange, {}, 'none', {})
call <sid>hi('cssPseudoClassLang', s:YellowOrange, {}, 'none', {})
call <sid>hi('cssIdentifier', s:YellowOrange, {}, 'none', {})
call <sid>hi('cssProp', s:LightBlue, {}, 'none', {})
call <sid>hi('cssDefinition', s:LightBlue, {}, 'none', {})
call <sid>hi('cssAttr', s:Orange, {}, 'none', {})
call <sid>hi('cssAttrRegion', s:Orange, {}, 'none', {})
call <sid>hi('cssColor', s:Orange, {}, 'none', {})
call <sid>hi('cssFunction', s:Orange, {}, 'none', {})
call <sid>hi('cssFunctionName', s:Orange, {}, 'none', {})
call <sid>hi('cssVendor', s:Orange, {}, 'none', {})
call <sid>hi('cssValueNumber', s:Orange, {}, 'none', {})
call <sid>hi('cssValueLength', s:Orange, {}, 'none', {})
call <sid>hi('cssUnitDecorators', s:Orange, {}, 'none', {})
call <sid>hi('cssStyle', s:LightBlue, {}, 'none', {})
call <sid>hi('cssImportant', s:Blue, {}, 'none', {})

" JavaScript:
call <sid>hi('jsVariableDef', s:LightBlue, {}, 'none', {})
call <sid>hi('jsFuncArgs', s:LightBlue, {}, 'none', {})
call <sid>hi('jsFuncBlock', s:LightBlue, {}, 'none', {})
call <sid>hi('jsRegexpString', s:LightRed, {}, 'none', {})
call <sid>hi('jsThis', s:Blue, {}, 'none', {})
call <sid>hi('jsOperatorKeyword', s:Blue, {}, 'none', {})
call <sid>hi('jsDestructuringBlock', s:LightBlue, {}, 'none', {})
call <sid>hi('jsObjectKey', s:LightBlue, {}, 'none', {})
call <sid>hi('jsGlobalObjects', s:BlueGreen, {}, 'none', {})
call <sid>hi('jsModuleKeyword', s:LightBlue, {}, 'none', {})
call <sid>hi('jsClassDefinition', s:BlueGreen, {}, 'none', {})
call <sid>hi('jsClassKeyword', s:Blue, {}, 'none', {})
call <sid>hi('jsExtendsKeyword', s:Blue, {}, 'none', {})
call <sid>hi('jsExportDefault', s:Pink, {}, 'none', {})
call <sid>hi('jsFuncCall', s:Yellow, {}, 'none', {})
call <sid>hi('jsObjectValue', s:LightBlue, {}, 'none', {})
call <sid>hi('jsParen', s:LightBlue, {}, 'none', {})
call <sid>hi('jsObjectProp', s:LightBlue, {}, 'none', {})
call <sid>hi('jsIfElseBlock', s:LightBlue, {}, 'none', {})
call <sid>hi('jsParenIfElse', s:LightBlue, {}, 'none', {})
call <sid>hi('jsSpreadOperator', s:LightBlue, {}, 'none', {})
call <sid>hi('jsSpreadExpression', s:LightBlue, {}, 'none', {})

" Typescript:
call <sid>hi('typescriptLabel', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptExceptions', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptBraces', s:Front, {}, 'none', {})
call <sid>hi('typescriptEndColons', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptParens', s:Front, {}, 'none', {})
call <sid>hi('typescriptDocTags', s:Blue, {}, 'none', {})
call <sid>hi('typescriptDocComment', s:BlueGreen, {}, 'none', {})
call <sid>hi('typescriptLogicSymbols', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptImport', s:Pink, {}, 'none', {})
call <sid>hi('typescriptBOM', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptVariableDeclaration', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptVariable', s:Blue, {}, 'none', {})
call <sid>hi('typescriptExport', s:Pink, {}, 'none', {})
call <sid>hi('typescriptAliasDeclaration', s:BlueGreen, {}, 'none', {})
call <sid>hi('typescriptAliasKeyword', s:Blue, {}, 'none', {})
call <sid>hi('typescriptClassName', s:BlueGreen, {}, 'none', {})
call <sid>hi('typescriptAccessibilityModifier', s:Blue, {}, 'none', {})
call <sid>hi('typescriptOperator', s:Blue, {}, 'none', {})
call <sid>hi('typescriptArrowFunc', s:Blue, {}, 'none', {})
call <sid>hi('typescriptMethodAccessor', s:Blue, {}, 'none', {})
call <sid>hi('typescriptMember', s:Yellow, {}, 'none', {})
call <sid>hi('typescriptTypeReference', s:BlueGreen, {}, 'none', {})
call <sid>hi('typescriptDefault', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptTemplateSB', s:YellowOrange, {}, 'none', {})
call <sid>hi('typescriptArrowFuncArg', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptParamImpl', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptFuncComma', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptCastKeyword', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptCall', s:Blue, {}, 'none', {})
call <sid>hi('typescriptCase', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptReserved', s:Pink, {}, 'none', {})
call <sid>hi('typescriptDefault', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptDecorator', s:Yellow, {}, 'none', {})
call <sid>hi('typescriptPredefinedType', s:BlueGreen, {}, 'none', {})
call <sid>hi('typescriptClassHeritage', s:BlueGreen, {}, 'none', {})
call <sid>hi('typescriptClassExtends', s:Blue, {}, 'none', {})
call <sid>hi('typescriptClassKeyword', s:Blue, {}, 'none', {})
call <sid>hi('typescriptBlock', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptDOMDocProp', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptTemplateSubstitution', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptClassBlock', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptFuncCallArg', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptIndexExpr', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptConditionalParen', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptArray', s:Yellow, {}, 'none', {})
call <sid>hi('typescriptES6SetProp', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptObjectLiteral', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptTypeParameter', s:BlueGreen, {}, 'none', {})
call <sid>hi('typescriptEnumKeyword', s:Blue, {}, 'none', {})
call <sid>hi('typescriptEnum', s:BlueGreen, {}, 'none', {})
call <sid>hi('typescriptLoopParen', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptParenExp', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptModule', s:LightBlue, {}, 'none', {})
call <sid>hi('typescriptAmbientDeclaration', s:Blue, {}, 'none', {})
call <sid>hi('typescriptModule', s:Blue, {}, 'none', {})
call <sid>hi('typescriptFuncTypeArrow', s:Blue, {}, 'none', {})
call <sid>hi('typescriptInterfaceHeritage', s:BlueGreen, {}, 'none', {})
call <sid>hi('typescriptInterfaceName', s:BlueGreen, {}, 'none', {})
call <sid>hi('typescriptInterfaceKeyword', s:Blue, {}, 'none', {})
call <sid>hi('typescriptInterfaceExtends', s:Blue, {}, 'none', {})
call <sid>hi('typescriptGlobal', s:BlueGreen, {}, 'none', {})
call <sid>hi('typescriptAsyncFuncKeyword', s:Blue, {}, 'none', {})
call <sid>hi('typescriptFuncKeyword', s:Blue, {}, 'none', {})
call <sid>hi('typescriptGlobalMethod', s:Yellow, {}, 'none', {})
call <sid>hi('typescriptPromiseMethod', s:Yellow, {}, 'none', {})

" XML:
call <sid>hi('xmlTag', s:BlueGreen, {}, 'none', {})
call <sid>hi('xmlTagName', s:BlueGreen, {}, 'none', {})
call <sid>hi('xmlEndTag', s:BlueGreen, {}, 'none', {})

" Ruby:
call <sid>hi('rubyClassNameTag', s:BlueGreen, {}, 'none', {})
call <sid>hi('rubyClassName', s:BlueGreen, {}, 'none', {})
call <sid>hi('rubyModuleName', s:BlueGreen, {}, 'none', {})
call <sid>hi('rubyConstant', s:BlueGreen, {}, 'none', {})

" Golang:
call <sid>hi('goPackage', s:Blue, {}, 'none', {})
call <sid>hi('goImport', s:Blue, {}, 'none', {})
call <sid>hi('goVar', s:Blue, {}, 'none', {})
call <sid>hi('goConst', s:Blue, {}, 'none', {})
call <sid>hi('goStatement', s:Pink, {}, 'none', {})
call <sid>hi('goType', s:BlueGreen, {}, 'none', {})
call <sid>hi('goSignedInts', s:BlueGreen, {}, 'none', {})
call <sid>hi('goUnsignedInts', s:BlueGreen, {}, 'none', {})
call <sid>hi('goFloats', s:BlueGreen, {}, 'none', {})
call <sid>hi('goComplexes', s:BlueGreen, {}, 'none', {})
call <sid>hi('goBuiltins', s:Yellow, {}, 'none', {})
call <sid>hi('goBoolean', s:Blue, {}, 'none', {})
call <sid>hi('goPredefinedIdentifiers', s:Blue, {}, 'none', {})
call <sid>hi('goTodo', s:Green, {}, 'none', {})
call <sid>hi('goDeclaration', s:Blue, {}, 'none', {})
call <sid>hi('goDeclType', s:Blue, {}, 'none', {})
call <sid>hi('goTypeDecl', s:Blue, {}, 'none', {})
call <sid>hi('goTypeName', s:BlueGreen, {}, 'none', {})
call <sid>hi('goVarAssign', s:LightBlue, {}, 'none', {})
call <sid>hi('goVarDefs', s:LightBlue, {}, 'none', {})
call <sid>hi('goReceiver', s:Front, {}, 'none', {})
call <sid>hi('goReceiverType', s:Front, {}, 'none', {})
call <sid>hi('goFunctionCall', s:Yellow, {}, 'none', {})
call <sid>hi('goMethodCall', s:Yellow, {}, 'none', {})
call <sid>hi('goSingleDecl', s:LightBlue, {}, 'none', {})

" Python:
call <sid>hi('pythonBoolean', s:Blue, {}, 'none', {})
call <sid>hi('pythonBuiltinObj', s:LightBlue, {}, 'none', {})
call <sid>hi('pythonBuiltinType', s:BlueGreen, {}, 'none', {})
call <sid>hi('pythonClassDef', s:BlueGreen, {}, 'none', {})
call <sid>hi('pythonClassVar', s:Blue, {}, 'none', {})
call <sid>hi('pythonExClass', s:BlueGreen, {}, 'none', {})
call <sid>hi('pythonException', s:Pink, {}, 'none', {})
call <sid>hi('pythonNone', s:Blue, {}, 'none', {})
call <sid>hi('pythonNumber', s:Number, {}, 'none', {})
call <sid>hi('pythonTSNumber', s:Number, {}, 'none', {})
call <sid>hi('pythonOperator', s:Blue, {}, 'none', {})
call <sid>hi('pythonStatement', s:Blue, {}, 'none', {})
call <sid>hi('pythonTodo', s:Blue, {}, 'none', {})

" TeX:
call <sid>hi('texStatement', s:Blue, {}, 'none', {})
call <sid>hi('texBeginEnd', s:Yellow, {}, 'none', {})
call <sid>hi('texBeginEndName', s:LightBlue, {}, 'none', {})
call <sid>hi('texOption', s:LightBlue, {}, 'none', {})
call <sid>hi('texBeginEndModifier', s:LightBlue, {}, 'none', {})
call <sid>hi('texDocType', s:Pink, {}, 'none', {})
call <sid>hi('texDocTypeArgs', s:LightBlue, {}, 'none', {})

" Git:
call <sid>hi('gitcommitHeader', s:Gray, {}, 'none', {})
call <sid>hi('gitcommitOnBranch', s:Gray, {}, 'none', {})
call <sid>hi('gitcommitBranch', s:Pink, {}, 'none', {})
call <sid>hi('gitcommitComment', s:Gray, {}, 'none', {})
call <sid>hi('gitcommitSelectedType', s:Green, {}, 'none', {})
call <sid>hi('gitcommitSelectedFile', s:Green, {}, 'none', {})
call <sid>hi('gitcommitDiscardedType', s:Red, {}, 'none', {})
call <sid>hi('gitcommitDiscardedFile', s:Red, {}, 'none', {})
call <sid>hi('gitcommitOverflow', s:Red, {}, 'none', {})
call <sid>hi('gitcommitSummary', s:Pink, {}, 'none', {})
call <sid>hi('gitcommitBlank', s:Pink, {}, 'none', {})

" Lua:
call <sid>hi('luaFuncCall', s:Yellow, {}, 'none', {})
call <sid>hi('luaFuncArgName', s:LightBlue, {}, 'none', {})
call <sid>hi('luaFuncKeyword', s:Pink, {}, 'none', {})
call <sid>hi('luaLocal', s:Pink, {}, 'none', {})
call <sid>hi('luaBuiltIn', s:Blue, {}, 'none', {})


" SH:
call <sid>hi('shDeref', s:LightBlue, {}, 'none', {})
call <sid>hi('shVariable', s:LightBlue, {}, 'none', {})

" SQL:
call <sid>hi('sqlKeyword', s:Pink, {}, 'none', {})
call <sid>hi('sqlFunction', s:YellowOrange, {}, 'none', {})
call <sid>hi('sqlOperator', s:Pink, {}, 'none', {})

" YAML:
call <sid>hi('yamlKey', s:Blue, {}, 'none', {})
call <sid>hi('yamlConstant', s:Blue, {}, 'none', {})

" C++:
call <sid>hi('CTagsClass', s:BlueGreen, {}, 'none', {})
call <sid>hi('CTagsStructure', s:BlueGreen, {}, 'none', {})
call <sid>hi('CTagsNamespace', s:BlueGreen, {}, 'none', {})
call <sid>hi('CTagsGlobalVariable', s:BlueGreen, {}, 'none', {})
call <sid>hi('CTagsDefinedName ', s:Blue, {}, 'none', {})
highlight def link CTagsFunction Function
highlight def link CTagsMember Identifier

" C++ color_coded
call <sid>hi('StructDecl', s:BlueGreen, {}, 'none', {})
call <sid>hi('UnionDecl', s:BlueGreen, {}, 'none', {})
call <sid>hi('ClassDecl', s:BlueGreen, {}, 'none', {})
call <sid>hi('TypeRef', s:BlueGreen, {}, 'none', {})
call <sid>hi('TypedefDecl', s:BlueGreen, {}, 'none', {})
call <sid>hi('TypeAliasDecl', s:BlueGreen, {}, 'none', {})
call <sid>hi('EnumDecl', s:BlueGreen, {}, 'none', {})
call <sid>hi('TemplateTypeParameter', s:BlueGreen, {}, 'none', {})
call <sid>hi('TypeAliasTemplateDecl', s:BlueGreen, {}, 'none', {})
call <sid>hi('ClassTemplate', s:BlueGreen, {}, 'none', {})
call <sid>hi('ClassTemplatePartialSpecialization', s:BlueGreen, {}, 'none', {})
call <sid>hi('FunctionTemplate', s:BlueGreen, {}, 'none', {})
call <sid>hi('TemplateRef', s:BlueGreen, {}, 'none', {})
call <sid>hi('TemplateTemplateParameter', s:BlueGreen, {}, 'none', {})
call <sid>hi('UsingDeclaration', s:BlueGreen, {}, 'none', {})
call <sid>hi('MemberRef', s:LightBlue, {}, 'italic', {})
call <sid>hi('MemberRefExpr', s:Yellow, {}, 'italic', {})
call <sid>hi('Namespace', s:Silver, {}, 'none', {})
call <sid>hi('NamespaceRef', s:Silver, {}, 'none', {})
call <sid>hi('NamespaceAlias', s:Silver, {}, 'none', {})

" C++ lsp-cxx-highlight
call <sid>hi('LspCxxHlSymClass', s:BlueGreen, {}, 'none', {})
call <sid>hi('LspCxxHlSymStruct', s:BlueGreen, {}, 'none', {})
call <sid>hi('LspCxxHlSymEnum', s:BlueGreen, {}, 'none', {})
call <sid>hi('LspCxxHlSymTypeAlias', s:BlueGreen, {}, 'none', {})
call <sid>hi('LspCxxHlSymTypeParameter', s:BlueGreen, {}, 'none', {})
call <sid>hi('LspCxxHlSymConcept', s:BlueGreen, {}, 'italic', {})
call <sid>hi('LspCxxHlSymNamespace', s:Silver, {}, 'none', {})

" highlight DiffAdd guibg=#4b5632
" highlight DiffChange guibg=#4b1818
" highlight DiffDelete guibg=#6f1313
" highlight DiffText guibg=#6f1313
highlight! link Folded Comment
" highlight! link diffAdded DiffAdd
" highlight! link diffChanged DiffChange
" highlight! link diffRemoved DiffDelete


highlight BookmarkAnnotationSign guifg=#3794FF
highlight BookmarkSign guifg=#3794FF

" highlight TabLine guifg=#929292 guibg=#000000
" highlight TabLineSel guifg=#d4d4d4 guibg=#1e1e1e
" highlight! link IncSearch DiffChange
" highlight! link Search DiffChange
" let g:airline_theme='solarized'
" let g:airline_solarized_bg='dark'
"}}}
