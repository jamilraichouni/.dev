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
lua require('plugins')
" Functions {{{
" Search literally via command :Search <LITERAL>
com! -nargs=1 Search :let @/='\V'.escape(<q-args>, '\\')| normal! n

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
function SmartInsert()
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
autocmd BufNewFile,BufReadPost *.aird,*.css,*.html,*.js,*.xml,*.reqif call SetIndentWidth(2)
autocmd BufNewFile,BufReadPost *.csv setlocal filetype=csv
autocmd BufNewFile,BufReadPost *.py call SetupPython()
autocmd BufReadPost *.json setlocal foldnestmax=1 foldmethod=indent
autocmd BufReadPost *.lua,*.py call SetupFolding()
autocmd BufReadPost *.reqif setlocal filetype=xml syntax=xml
autocmd BufReadPost .bash* setlocal syntax=sh
autocmd BufReadPost init.vim,plugins.lua setlocal foldmethod=marker
autocmd BufReadPost lsp.log setlocal wrap
autocmd BufWritePost *.snippets CmpUltisnipsReloadSnippets
autocmd BufWritePost */jarvim/**/*.py UpdateRemotePlugins
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
autocmd TermOpen * setlocal colorcolumn=0 nonumber norelativenumber | startinsert!
autocmd TermClose * call feedkeys("i")

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

" leave insert mode of terminal as it is in vim:
tnoremap <c-w>N <C-\><C-n>
" tnoremap <C-r> <Nop>

" Clear search highlighting:
nnoremap <leader>, :noh<cr>

" line numbers:
noremap <silent><leader>tt :call ToggleNumber()<cr>
noremap <silent><leader>rr :call ToggleRelativeNumber()<cr>
" Register and load remote plugins:
nnoremap <leader>uu :UpdateRemotePlugins<cr>

" Edit specific files:
nnoremap <leader>erc :e $HOME/.zshrc<cr>
nnoremap <leader>ewt :e $HOME/repos/finances/data/working_times.csv<cr>
nnoremap <leader>init :e $HOME/.config/nvim/init.vim<cr>
nnoremap <leader>plug :e $HOME/.config/nvim/lua/plugins.lua<cr>
nnoremap <leader>lsp :e $HOME/.config/nvim/lua/config/nvim-lspconfig.lua<cr>
nnoremap <leader>theme :e $HOME/.config/nvim/lua/config/vim-code-dark.lua<cr>

" Source zsh config:
nnoremap <leader>sinit :source $HOME/.config/nvim/init.vim<cr>
nnoremap <leader>src :!source $HOME/.zshrc<cr>

" Browse specific locations:
nnoremap <leader>cc <cmd>find /Users/jamilraichouni/repos/cookiecutters/python/*cookiecutter.PROJECT_SLUG*<cr>

" Completion;
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

" Folding
nnoremap <silent><leader>f1 <cmd>%foldclose!<cr>
nnoremap <silent><leader>f0 <cmd>%foldopen!<cr>

" Terminal:
" nnoremap <silent><leader>tt <cmd>terminal<cr>
" nnoremap <silent><leader>tl <cmd>wincmd v<cr><cmd>terminal<cr>


" LSP (maps: https://github.com/neovim/nvim-lspconfig#suggested-configuration)
nnoremap <silent><leader>lf <cmd>lua vim.lsp.buf.formatting()<cr>
nnoremap <silent><leader>ld <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <silent><leader>lt <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <silent><leader>lh <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap <silent><leader>lr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent><leader>li <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap <silent><leader>lp <cmd>lua vim.diagnostic.goto_prev{wrap=false,popup_opts={border="single"}}<cr>
nnoremap <silent><leader>ln <cmd>lua vim.diagnostic.goto_next{wrap=false,popup_opts={border="single"}}<cr>

" vimspector:
" mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)
nmap <Leader>dr <cmd>VimspectorReset<cr>

" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

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
" }}}
