return require("packer").startup(function()

    -- CORE {{{

    -- https://github.com/wbthomason/packer.nvim
    use {
        "wbthomason/packer.nvim",
        lock = true,
    }

    -- https://github.com/tpope/vim-commentary
    use {
        "tpope/vim-commentary",
        lock = true,
        event = "BufWinEnter"
    }

    -- https://github.com/tpope/vim-surround
    -- (e. g. cs"' to replace double by single quotes)
    use {
        "tpope/vim-surround",
        lock = true,
        event = "BufWinEnter"
    }

    -- https://github.com/tpope/vim-repeat
    use {
        "tpope/vim-repeat",
        lock = true,
        event = "BufWinEnter"
    }

    -- https://github.com/feline-nvim/feline.nvim
    use {
        "feline-nvim/feline.nvim",
        lock = true,
        event = "BufWinEnter",
        config = function() require("config.feline") end,
        requires = {
            -- https://github.com/lewis6991/gitsigns.nvim
            use {
                "lewis6991/gitsigns.nvim",
                lock = true,
                event = "BufWinEnter",
                config = function() require("gitsigns").setup() end
            }
        }
    }

    -- https://github.com/tpope/vim-fugitive
    use {
        "tpope/vim-fugitive",
        lock = true
    }

    --- https://github.com/fladson/vim-kitty
    use {
        "fladson/vim-kitty",
        lock = true,
        ft = "kitty"
    }

    -- }}}

    -- COMPLETION AND LSP {{{

    -- use {
    --     -- IMPORTANT: I could only build YouCompleteMe via:
    --     -- cd ~/.local/share/nvim/site/pack/packer/start/YouCompleteMe
    --     -- YCM_CORES=1 python3 install.py --verbose
    --     "ycm-core/YouCompleteMe"
    -- }

    use {
        -- https://github.com/hrsh7th/nvim-cmp
        "hrsh7th/nvim-cmp", -- ENGINE
        lock = true,
        event = "BufWinEnter",
        config = function() require("config.nvim-cmp") end,
        requires = {
            -- SOURCES/ PROVIDERS
            -- (sources are the bridge between provider and nvim-cmp):
            {
                -- https://github.com/hrsh7th/cmp-buffer
                "hrsh7th/cmp-buffer",
                lock = true,
                after = "nvim-cmp"
            },
            {
                -- https://github.com/hrsh7th/cmp-nvim-lsp
                "hrsh7th/cmp-nvim-lsp", -- source
                lock = true,
                after = "nvim-cmp",
                requires = { "neovim/nvim-lspconfig" } -- provider
            },
            {
                -- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
                "hrsh7th/cmp-nvim-lsp-signature-help", -- source
                lock = true,
                after = "nvim-cmp",
                requires = { "neovim/nvim-lspconfig" } -- provider
            },
            {
                -- https://github.com/quangnguyen30192/cmp-nvim-ultisnips
                "quangnguyen30192/cmp-nvim-ultisnips", -- source
                lock = true,
                after = "nvim-cmp",
                config = function() require("config.cmp-nvim-ultisnips") end,
                requires = {
                    -- https://github.com/SirVer/ultisnips
                    "SirVer/ultisnips", -- provider
                    lock = true,
                    after = "nvim-cmp",
                    config = function() require("config.ultisnips") end
                }
            },
            {
                -- https://github.com/hrsh7th/cmp-path
                "hrsh7th/cmp-path", -- source
                lock = true,
                after = "nvim-cmp"
            },
        }
    }

    -- use { "SirVer/ultisnips", config = function() require("config.ultisnips") end }

    -- }}}

    -- TELESCOPE {{{

    -- https://github.com/nvim-telescope/telescope.nvim
    -- use {
    --     "nvim-telescope/telescope.nvim",
    --     lock = true,
    --     cmd = "Telescope",
    --     requires = "nvim-lua/plenary.nvim",
    --     config = function()
    --         require("config.telescope")
    --     end
    -- }

    -- https://github.com/LinArcX/telescope-env.nvim
    -- use {
    --     "LinArcX/telescope-env.nvim",
    --     lock = true,
    --     after = "telescope.nvim",
    --     config = function() require("config.telescope-env") end
    -- }
    -- use {
    --     "nvim-telescope/telescope-fzf-native.nvim",
    --     lock = true,
    --     after = "telescope.nvim",
    --     config = function() require("config.telescope-fzf-native") end,
    --     run = "make"
    -- }
    -- }}}

    -- LSP {{{

    -- https://github.com/neovim/nvim-lspconfig
    use {
        "neovim/nvim-lspconfig",
        lock = true,
        config = function() require("config.nvim-lspconfig") end,
    }

    -- }}}

    -- DEBUG ADAPTER {{{

    -- nvim-dap {{{
    -- https://github.com/mfussenegger/nvim-dap
    -- use {
    --     "mfussenegger/nvim-dap",
    --     config = function() require("config.nvim-dap") end,
    -- }

    -- https://github.com/rcarriga/nvim-dap-ui
    -- use {
    --     "rcarriga/nvim-dap-ui",
    --     requires = "mfussenegger/nvim-dap",
    --     config = function() require("config.nvim-dap-ui") end,
    -- }

    -- }}}

    -- vimspector {{{
    -- https://github.com/puremourning/vimspector
    -- https://puremourning.github.io/vimspector/configuration.html
    use {
        "puremourning/vimspector",
        lock = true,
        ft = "python",
        config = function()
            vim.cmd [[let g:vimspector_enable_mappings = 'HUMAN' ]]
            vim.cmd [[let g:vimspector_install_gadgets = ['debugpy'] ]]
            vim.cmd [[let g:vimspector_base_dir = stdpath('data') .. '/site/pack/packer/start/vimspector' ]]
        end,
    }
    -- }}}

    -- }}}

    -- FILETYPE SPECIFIC {{{

    -- https://github.com/iamcco/markdown-preview.nvim
    use {
        "iamcco/markdown-preview.nvim",
        lock = true,
        ft = "markdown",
        run = ":call mkdp#util#install()",
        setup = function()
            vim.cmd([[
            let g:mkdp_auto_close = 0
            let g:mkdp_preview_options = {
            \ 'mkit': {},
            \ 'katex': {},
            \ 'uml': {},
            \ 'maid': {},
            \ 'disable_sync_scroll': 0,
            \ 'sync_scroll_type': 'top',
            \ 'hide_yaml_meta': 1,
            \ 'sequence_diagrams': {},
            \ 'flowchart_diagrams': {},
            \ 'content_editable': v:false,
            \ 'disable_filename': 0
            \ }
            ]])
        end
    }

    -- https://github.com/mechatroner/rainbow_csv
    use {
        "mechatroner/rainbow_csv",
        lock = true,
        ft = "csv"
    }

    -- https://github.com/Glench/Vim-Jinja2-Syntax
    use {
        "Glench/Vim-Jinja2-Syntax",
        lock = true,
        ft = { "jinja", "jinja.html" }
    }

    -- }}}

    -- OTHER {{{

    -- https://github.com/nvim-treesitter/nvim-treesitter
    -- (Better syntax highlighting)
    use {
        "nvim-treesitter/nvim-treesitter",
        lock = true,
        event = "BufWinEnter",
        run = function()
            vim.cmd(":TSUpdate")
            -- vim.cmd(":TSInstall! bash c cpp css dockerfile html java javascript json lua python rst scss toml typescript vue yaml")
            -- No vim. Otherwise we break the syntax highlighting for 'lua<<EOF' stuff !!
        end,
        config = function()
            require "nvim-treesitter.configs".setup {
                highlight = { enable = true }
            }
        end
    }

    -- https://github.com/MattesGroeger/vim-bookmarks
    use {
        "MattesGroeger/vim-bookmarks",
        lock = true,
        event = "BufWinEnter"
    }

    -- https://github.com/folke/trouble.nvim
    use {
        "folke/trouble.nvim",
        lock = true,
        event = "BufWinEnter",
        requires = {
            -- https://github.com/kyazdani42/nvim-web-devicons
            use {
                "kyazdani42/nvim-web-devicons",
                lock = true,
                after = "trouble.nvim"
            },
            -- https://github.com/folke/lsp-colors.nvim
            use {
                "folke/lsp-colors.nvim",
                lock = true,
                after = "trouble.nvim"
            }
        },
        config = function() require("config.trouble") end
    }

    -- https://github.com/lukas-reineke/indent-blankline.nvim
    -- use { "lukas-reineke/indent-blankline.nvim" }
    -- use {
    --     "preservim/tagbar",
    --     config = function() vim.cmd("let g:tagbar_position = 'topleft vertical'") end
    -- }
    -- use {"jamilraichouni/jarvim"}
    -- }}}

end)
