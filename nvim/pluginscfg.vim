lua<<EOF
require'vim.lsp.log'.set_level("INFO")

for type, icon in pairs{Error = " ", Warning = " ", Information = " ", Hint = " "} do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {signs = true}
)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = "single"}
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = "single"}
)

local lspconfig = require('lspconfig')
local function on_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = {noremap=true, silent=true}

  local cap = client.resolved_capabilities
  if cap.completion then
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    buf_set_keymap('i', '<C-N>', '<C-X><C-O>', opts)
  end

  -- Set some keybinds conditional on server capabilities
  if cap.hover then
    buf_set_keymap('n', 'K', '<CMD>lua vim.lsp.buf.hover()<CR>', opts)
  end
  if cap.declaration then
    buf_set_keymap('n', 'gD', '<CMD>lua vim.lsp.buf.declaration()<CR>', opts)
  end
  if cap.goto_definition then
    buf_set_keymap('n', 'gd', '<CMD>lua vim.lsp.buf.definition()<CR>', opts)
  end

  -- Set autocommands conditional on server_capabilities
  if cap.document_formatting then
    vim.api.nvim_exec([[
      augroup lsp_document_formatting
        autocmd!
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
      augroup END
    ]], false)
  end

  if cap.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

lspconfig.util.default_config.on_attach = on_attach

-- lspconfig.bashls.setup{}
-- lspconfig.clangd.setup{}
-- lspconfig.cssls.setup{}
-- lspconfig.dockerls.setup{}
-- lspconfig.html.setup{}
-- lspconfig.jedi_language_server.setup{}
-- lspconfig.jsonls.setup{cmd = {"vscode-json-languageserver", "--stdio"},}

lspconfig.pylsp.setup{
  cmd = {"pylsp"},
  flags = {
    debounce_text_changes = 500,
  },
  settings = {
    pylsp = {
      plugins = {
        flake8 = {
            enabled = true
        },
        jedi_completion = {
          enabled = true,
          fuzzy = true,
        },
        jedi_definition = {
          enabled = true,
        },
        mccabe = {enabled = true},
        pycodestyle = {enabled = false},
        pydocstyle = {enabled = true},
        pyflakes = {enabled = false},
        pylint = {enabled = false, executable = "pylint"},
        pyls_black = {enabled = true},
        pyls_isort = {enabled = true},
        pylsp_mypy = {enabled = true},
      },
    },
  },
}

-- lspconfig.sumneko_lua.setup{
--   cmd = {"/usr/bin/lua-language-server"},
--   settings = {
--     Lua = {
--       runtime = {
--         version = "LuaJIT",
--         path = vim.split(package.path, ";"),
--       },
--       diagnostics = {
--         globals = {"vim"},
--       },
--       workspace = {
--         library = {
--           [vim.fn.expand("$VIMRUNTIME/lua")] = true,
--           [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
--         },
--       },
--     },
--   },
-- }

-- lspconfig.yamlls.setup{}
EOF

" luasnip setup
lua<<EOF
local luasnip = require 'luasnip'
-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
EOF

hi link DapBreakpointSign LspDiagnosticsSignError
hi DapStoppedLine ctermbg=darkblue guibg=#000055
lua vim.fn.sign_define("DapBreakpoint", {text = "O", signhl = "DapBreakpointSign"})
lua vim.fn.sign_define("DapStopped", {text = "→", linehl = "DapStoppedLine"})
lua require"dap-python".setup("/usr/local/bin/python3")
lua require"dap.ext.vscode".load_launchjs()
" lua require"dap-python".test_runner("pytest")
lua<<EOF
require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "watches", size = 0.1 },
    },
    size = 50,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = 50, -- These can be integers or a float between 0 and 1.
    max_width = 50, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})
EOF

" Telescope:
lua<<EOF
require('telescope').setup({
  defaults = {
    layout_config = {
      vertical = { width = 0.3 }
      -- other layout configuration here
    },
    -- other defaults configuration here
  },
  -- other configuration values here
})
EOF
