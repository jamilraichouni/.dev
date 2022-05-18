" Core {{{
" set t_Co=256
syntax on

set autoindent
set backspace=2
set colorcolumn=88
set completeopt="menuone,noinsert,noselect,preview"
set cursorline
set cursorlineopt=number
set expandtab  " blanks instead of tab
" set guicursor="n-v-c:block-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor"
set hlsearch
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
set updatetime=100
set wildmenu  " display all matching files when we tab complete

filetype plugin indent on

" Set built-in file system explorer to use layout similar to the NERDTree plugin
let g:netrw_liststyle=3
" }}}

" Plugins {{{
call plug#begin()

" https://github.com/tomasiser/vim-code-dark
Plug 'tomasiser/vim-code-dark'

" https://github.com/tpope/vim-commentary
Plug 'tpope/vim-commentary'

" https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'

" https://github.com/MattesGroeger/vim-bookmarks
Plug 'MattesGroeger/vim-bookmarks'

" https://github.com/tpope/vim-repeat
Plug 'tpope/vim-repeat'

" https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline'

" https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-fugitive'

" https://github.com/fladson/vim-kitty
Plug 'fladson/vim-kitty'

" https://github.com/airblade/vim-gitgutter
Plug 'https://github.com/airblade/vim-gitgutter'

" https://github.com/dense-analysis/ale
Plug 'https://github.com/dense-analysis/ale'

" https://github.com/ycm-core/YouCompleteMe
" IMPORTANT: I could only build YouCompleteMe via 'YCM_CORES=1 ./install.py --verbose'
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 ./install.py --all' }

Plug 'SirVer/ultisnips'

" https://github.com/iamcco/markdown-preview.nvim
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" https://github.com/puremourning/vimspector
Plug 'puremourning/vimspector'

" https://github.com/vim-python/python-syntax
Plug 'vim-python/python-syntax'

call plug#end()
" }}}

" Plugin configurations {{{

" UltiSnips {{{
let g:UltiSnipsSnippetDirectories = ["UltiSnips"]
" }}}

" vimspector {{{
let g:vimspector_install_gadgets = [ 'debugpy' ]
" }}}

let g:python_highlight_all = 1

colorscheme codedark
let g:airline#extensions#ale#enabled = 1
" let g:ale_cursor_detail = 1
let g:ale_fixers = {'python': ['black', 'isort']}
let g:ale_linters = {'python': ['flake8', 'isort', 'pyright']}
let g:ale_python_pyright_config = {
\ 'pyright': {
\   'disableLanguageServices': v:true,
\ },
\}
let g:ale_completion_symbols = {
\ 'text': '',
\ 'method': '',
\ 'function': '',
\ 'constructor': '',
\ 'field': '',
\ 'variable': '',
\ 'class': '',
\ 'interface': '',
\ 'module': '',
\ 'property': '',
\ 'unit': 'v',
\ 'value': 'v',
\ 'enum': 't',
\ 'keyword': 'v',
\ 'snippet': 'v',
\ 'color': 'v',
\ 'file': 'v',
\ 'reference': 'v',
\ 'folder': 'v',
\ 'enum_member': 'm',
\ 'constant': 'm',
\ 'struct': 't',
\ 'event': 'v',
\ 'operator': 'f',
\ 'type_parameter': 'p',
\ '<default>': 'v'
\ }
let g:ale_sign_error = ""
let g:ale_sign_warning = ""
let g:ale_sign_info = ""
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix = " "
" }}}

" Functions {{{
function! SetIndentWidth(width)
    let width = str2nr(a:width)
    let &tabstop=width
    let &softtabstop=width
    let &shiftwidth=width
endfunction

function! SetupPython()
    set tabstop=4
    set softtabstop=0
    set shiftwidth=4
    set expandtab
    set autoindent
    set fileformat=unix
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
        hi LineNr ctermfg=grey guifg=grey guifg=grey
    endif
endfunction
" }}}

" Events {{{
" https://learnvimscriptthehardway.stevelosh.com/chapters/12.html#autocommands

" COMMON EVENTS ------------------------------------------------------------------------
autocmd BufNewFile,BufReadPost *.csv setlocal filetype=csv
autocmd BufNewFile,BufReadPost *.py call SetupPython()
autocmd BufNewFile,BufReadPost *.aird,*.css,*.html,*.js,*.xml,*.reqif call SetIndentWidth(2)
autocmd BufReadPost .bash* setlocal syntax=sh
autocmd BufReadPost .vimrc setlocal foldmethod=marker
autocmd BufReadPost *.lua,*.py setlocal foldmethod=indent
autocmd BufReadPost *.reqif setlocal filetype=xml syntax=xml
" autocmd BufWritePost debug.json JARReloadDebugConfiguration
autocmd BufWritePost */jarvim/**/*.py UpdateRemotePlugins
" autocmd BufWritePost *.snippets CmpUltisnipsReloadSnippets

" No line nos and color column when a terminal is opened:
autocmd TerminalOpen * setlocal cc=0 nonumber norelativenumber notermguicolors

" autocmd WinClosed * wincmd p

" autocmd VimEnter * JARReloadDebugConfiguration

" FILETYPE EVENTS ----------------------------------------------------------------------
autocmd FileType Trouble setlocal wrap
" }}}

" Keymaps {{{
let mapleader=","

" Disable arrow keys in normal mode:
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>

" Disable arrow keys in visual mode:
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
vnoremap <Up> <Nop>
vnoremap <Down> <Nop>

" Leave terminal mode
" tnoremap <esc><esc> <c-w>N
" tnoremap <Ctrl-r> <Nop>

" Clear search highlighting:
nnoremap <leader>, :noh<cr>

" line numbers:
noremap <silent> <leader>lt :call ToggleNumber()<cr>
noremap <silent> <leader>lr :call ToggleRelativeNumber()<cr>

" Edit specific files:
nnoremap <leader>ezshrc :e $HOME/.zshrc<cr>
nnoremap <leader>evimrc :e $HOME/.vimrc<cr>
nnoremap <leader>ewt :e $HOME/repos/finances/data/working_times.csv<cr>
nnoremap <leader>eplug :e $HOME/.config/nvim/lua/plugins.lua<cr>
nnoremap <leader>elsp :e $HOME/.config/nvim/lua/config/nvim-lspconfig.lua<cr>

" Source zsh config:
nnoremap <leader>szshrc :!source $HOME/.zshrc<cr>

" Browse specific locations:
nnoremap <leader>cc <cmd>find /Users/jamilraichouni/repos/cookiecutters/python/*cookiecutter.PROJECT_SLUG*<cr>

" Folding
nnoremap <silent> <leader>f1 <cmd>%foldclose!<cr>
nnoremap <silent> <leader>f0 <cmd>%foldopen!<cr>

" vimspector:
let g:vimspector_enable_mappings = 'HUMAN'
" }}}

" Theme {{{
" highlight BookmarkSign ctermbg=NONE ctermfg=160 guifg=#569cd6
" highlight BookmarkAnnotationSign ctermbg=NONE ctermfg=160 guifg=#569cd6
highlight Comment ctermfg=239 guifg=#4e4e4e cterm=italic gui=italic
highlight CursorLineNr ctermfg=9 guifg=#af0000
highlight StatusLine ctermbg=blue ctermfg=white guibg=#002240 guifg=#c0c0c0
highlight StatusLineNC ctermbg=black ctermfg=white guibg=#121212 guifg=#767676
highlight TabLine ctermbg=black ctermfg=white guibg=#121212 guifg=#767676
highlight TabLineSel ctermbg=blue ctermfg=white guibg=#002240 guifg=#c0c0c0
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff0000 ctermfg=1

highlight ALEInfo guifg=#ffffff ctermfg=1
highlight ALEVirtualTextInfo guifg=#ffffff ctermfg=1
highlight ALEInfoSign guifg=#ffffff ctermfg=1

highlight ALEWarning guifg=#ffff00 ctermfg=1
highlight ALEVirtualTextWarning guifg=#ffff00 ctermfg=1
highlight ALEWarningSign guifg=#ffff00 ctermfg=1

highlight ALEError guifg=#ff0000 ctermfg=1
highlight ALEVirtualTextError guifg=#ff0000 ctermfg=1
highlight ALEErrorSign guifg=#ff0000 ctermfg=1
set termguicolors
" }}}
