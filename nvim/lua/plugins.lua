return require("packer").startup(function()

    -- CORE {{{

    -- https://github.com/wbthomason/packer.nvim
    use "wbthomason/packer.nvim"

    -- https://github.com/tpope/vim-commentary
    use "tpope/vim-commentary"

    -- https://github.com/tpope/vim-surround
    use "tpope/vim-surround"

    -- https://github.com/tpope/vim-repeat
    use "tpope/vim-repeat"

    -- https://github.com/feline-nvim/feline.nvim
    use {
      "feline-nvim/feline.nvim",
      config = function()
          require('feline').setup()
      end
    }

    -- https://github.com/vim-airline/vim-airline
    -- use {
    --     "vim-airline/vim-airline",
    --     -- requires = {
    --     --     "vim-airline/vim-airline-themes"
    --     -- },
    --     config = function() require("config.vim-airline") end
    -- }

    -- https://github.com/tpope/vim-fugitive
    use "tpope/vim-fugitive"

    --- https://github.com/fladson/vim-kitty
    use "fladson/vim-kitty"

    -- }}}

    -- COMPLETION {{{

    -- use {
    --     -- IMPORTANT: I could only build YouCompleteMe via:
    --     -- cd ~/.local/share/nvim/site/pack/packer/start/YouCompleteMe
    --     -- YCM_CORES=1 python3 install.py --verbose
    --     "ycm-core/YouCompleteMe"
    -- }

    use {
        -- https://github.com/hrsh7th/nvim-cmp
        "hrsh7th/nvim-cmp", -- ENGINE
        config = function() require("config.nvim-cmp") end,
        requires = {
            -- SOURCES/ PROVIDERS
            -- (sources are the bridge between provider and nvim-cmp):
            {
                -- https://github.com/hrsh7th/cmp-buffer
                "hrsh7th/cmp-buffer",
            },
            {
                -- https://github.com/hrsh7th/cmp-nvim-lsp
                "hrsh7th/cmp-nvim-lsp", -- source
                requires = { "neovim/nvim-lspconfig" } -- provider
            },
            {
                -- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
                "hrsh7th/cmp-nvim-lsp-signature-help", -- source
                requires = { "neovim/nvim-lspconfig" } -- provider
            },
            {
                "quangnguyen30192/cmp-nvim-ultisnips",
                config = function() require("config.cmp-nvim-ultisnips") end,
                requires = {
                    "SirVer/ultisnips",
                    config = function() require("config.ultisnips") end
                }
            },
            {
                -- https://github.com/hrsh7th/cmp-path
                "hrsh7th/cmp-path",
            },
        }
    }

    -- https://github.com/SirVer/ultisnips
    use { "SirVer/ultisnips", config = function() require("config.ultisnips") end }

    -- }}}

    -- TELESCOPE {{{

    -- https://github.com/nvim-telescope/telescope.nvim
    use {
        "nvim-telescope/telescope.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("config.telescope")
        end
    }

    -- https://github.com/LinArcX/telescope-env.nvim
    use {
        "LinArcX/telescope-env.nvim",
        config = function() require("config.telescope-env") end
    }
    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        config = function() require("config.telescope-fzf-native") end,
        run = "make"
    }
    -- }}}

    -- LSP {{{

    -- https://github.com/neovim/nvim-lspconfig
    use {
        "neovim/nvim-lspconfig",
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
        ft = { "markdown" },
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
    use { "mechatroner/rainbow_csv", ft = { "csv" } }

    -- https://github.com/Glench/Vim-Jinja2-Syntax
    use { "Glench/Vim-Jinja2-Syntax", ft = { "jinja", "jinja.html" } }

    --
    use {
        "hanschen/vim-ipython-cell",
        requires = {
            "jpalardy/vim-slime",
            ft = { "python" }
        },
        ft = { "python" }
    }

    -- }}}

    -- OTHER {{{

    -- https://github.com/nvim-treesitter/nvim-treesitter
    -- (Better syntax highlighting)
    use {
        "nvim-treesitter/nvim-treesitter",
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
    use "MattesGroeger/vim-bookmarks"


    -- https://github.com/lewis6991/gitsigns.nvim
    use {
        "lewis6991/gitsigns.nvim",
        config = function() require("gitsigns").setup() end
    }

    -- https://github.com/folke/trouble.nvim
    use {
        "folke/trouble.nvim",
        requires = {
            -- https://github.com/kyazdani42/nvim-web-devicons
            "kyazdani42/nvim-web-devicons",
            -- https://github.com/folke/lsp-colors.nvim
            "folke/lsp-colors.nvim"
        },
        config = function() require("config.trouble") end
    }

    -- https://github.com/lukas-reineke/indent-blankline.nvim
    use { "lukas-reineke/indent-blankline.nvim" }
    -- use {"jamilraichouni/jarvim"}
    -- }}}

end)
