-- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations

-- LSP implementations:
-- https://langserver.org/
-- https://microsoft.github.io/language-server-protocol/implementors/servers/

-- Nice list of tools:
-- https://github.com/dense-analysis/ale/blob/master/doc/ale-supported-languages-and-tools.txt

-- INSTALLATIONS:

-- sudo npm install -g \
-- @angular/language-server \
-- bash-language-server \
-- diagnostic-languageserver \
-- dockerfile-language-server-nodejs \
-- markdownlint-cli \
-- prettier \
-- typescript \
-- typescript-language-server \
-- vscode-json-languageserver \
-- yaml-language-server

-- brew install lua-language-server

local lspconfig = require("lspconfig")
vim.lsp.set_log_level("error")
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local pythonRootPatterns = { ".env", ".git", "pyproject.toml", "setup.cfg", "tox.ini" }

-- https://github.com/iamcco/diagnostic-languageserver
lspconfig.diagnosticls.setup({
    -- cmd = {"diagnostic-languageserver", "--stdio", "--log-level", "3"},
    filetypes = {
        "css",
        "html",
        "json",
        "markdown",
        "python",
        "scss",
        "xml",
    },
    init_options = {
        formatters = {
            black = {
                command = "black",
                args = { "--quiet", "-" },
                rootPatterns = pythonRootPatterns,
            },
            isort = {
                command = "isort",
                args = { "-" },
                rootPatterns = { "pyproject.toml", },
            },
            -- https://prettier.io/
            prettier = {
                command = "prettier",
                args = {
                    "--stdin-filepath",
                    "%filename",
                    "--write",
                    "--no-config",
                    "--print-width",
                    "88",
                    "--loglevel",
                    "silent",
                },
            },
            -- https://github.com/JohnnyMorganz/StyLua
            stylua = {
                command = "stylua",
                args = { "-" },
            },
        },
        formatFiletypes = {
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            lua = { "stylua" },
            python = {
                "black",
                "isort",
            },
            scss = { "prettier" },
            xml = { "prettier" },
        },
        linters = {
            -- pip install flake8 \
            -- flake8-builtins \
            -- flake8-docstrings \  # http://www.pydocstyle.org/en/stable/index.html
            -- flake8-isort \
            -- flake8-json \
            -- flake8-quotes \
            -- flake8-rst-docstrings \
            -- flake8-unused-arguments
            flake8 = {
                command = "flake8",
                args = {
                    "--max-complexity",
                    "12",
                    "--format=json", -- pip install flake8-json
                    "--no-show-source",
                    "--inline-quotes",
                    "double",
                    "-",
                },
                rootPatterns = { "tox.ini" },
                sourceName = "flake8",
                parseJson = {
                    -- to see some example:
                    -- cat /path/to/file | flake8 --format=json -
                    errorsRoot = "stdin",
                    sourceName = "flake8",
                    line = "line_number",
                    column = "column_number",
                    security = "${code[0]}",
                    message = "[flake8] ${text} [${code}]",
                },
                securities = {
                    ["E"] = "error",
                    -- ["D"] = "info",
                    ["I"] = "info",
                    ["W"] = "warning",
                },
            },
            markdownlint = {
                -- https://github.com/igorshubovych/markdownlint-cli
                command = "markdownlint",
                args = { "--stdin", "--disable", "MD013", "-" },
                isStdout = false,
                isStderr = true,
                sourceName = "markdownlint",
                -- parseJson = {
                --     -- to see some example:
                --     -- cat /path/to/file | flake8 --format=json -
                --     errorsRoot = "",
                --     sourceName = "markdownlint",
                --     line = "kineNumber",
                --     column = "errorRange[0]",
                --     security = "ruleNames[0]",
                --     message = "[flake8] ${text} [${code}]",
                -- },
                formatLines = 1,
                formatPattern = {
                    "^stdin:(\\d+):?(\\d+)? (\\w+)/([\\w\\-\\/]+) (.+)$",
                    {
                        line = 1,
                        column = 2,
                        message = { "[", 3, "] ", 5 },
                        security = 3
                    }
                },
            },
            mypy = {
                command = "mypy",
                args = { "--hide-column-numbers", "--no-error-summary", "--no-color-output", "--command", "%text" },
                isStdout = true,
                sourceName = "mypy",
                formatLines = 1,
                formatPattern = {
                    "^<string>:(\\d+): ([\\w]+): (.*)$",
                    {
                        line = 1,
                        message = 3,
                        security = 2
                    }
                },
            }
        },
        filetypes = {
            -- filetype to linter(s) mapping:
            python = {
                "flake8",
                "mypy",
            },
            markdown = { "markdownlint" }
        },
    },
})
lspconfig.angularls.setup({})
-- https://github.com/bash-lsp/bash-language-server
lspconfig.bashls.setup({
    filetypes = { "sh", "zsh" },
})

-- https://github.com/rcjsuen/dockerfile-language-server-nodejs
lspconfig.dockerls.setup({})

-- https://github.com/vscode-langservers/vscode-json-languageserver
lspconfig.jsonls.setup({
    cmd = { "vscode-json-languageserver", "--stdio" },
    settings = {
        -- https://www.npmjs.com/package/vscode-json-languageserver
        json = {
            schemas = {
                {
                    -- https://puremourning.github.io/vimspector/configuration.html#appendix-editor-configuration
                    fileMatch = { ".vimspector.json" },
                    url = "file://" .. vim.fn.stdpath("data") .. "/site/pack/packer/start/vimspector/docs/schema/vimspector.schema.json"
                }
            }
        }
    }
})

-- https://github.com/microsoft/pyright
lspconfig.pyright.setup({})

-- https://github.com/sumneko/lua-language-server
lspconfig.sumneko_lua.setup({

    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    "use", -- packer
                    "vim" -- nvim lua development
                },
            },
        },
    },
})

-- https://github.com/typescript-language-server/typescript-language-server
lspconfig.tsserver.setup({})

-- https://github.com/redhat-developer/yaml-language-server
lspconfig.yamlls.setup({
    settings = {
        yaml = {
            completion = {
                enable = true,
            },
            format = {
                enable = true,
            },
            hover = {
                enable = true,
            },
            schemaStore = {
                enable = true,
            },
            validate = {
                enable = true,
            },
            schemas = {
                ["/Users/jamilraichouni/repos/mddocgen/builddesc_schema.json"] = "/builddesc*.yml",
            },
        },
    },
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = false,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = {
        source = "always", -- Or "if_many"
    },
    float = {
        source = "always", -- Or "if_many"
    },
})
