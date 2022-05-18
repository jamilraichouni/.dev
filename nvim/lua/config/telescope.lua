require("telescope").setup{
    defaults = {
        preview = {
          filesize_hook = function(filepath, bufnr, opts)
            local max_bytes = 10000
            local cmd = {"head", "-c", max_bytes, filepath}
            require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
          end,
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--hidden",
          "--smart-case"
        },
        selection_strategy = "reset",
        sorting_strategy = "descending",
        file_ignore_patterns = {
          "dist/.*",
          "%.git/.*",
          "%.vim/.*",
          "node_modules/.*",
          "%.idea/.*",
          "%.vscode/.*",
          "%.history/.*"
        },
        file_ignore_patterns = {
            ".DS_Store",
            ".git",
            ".mypy_cache",
            ".pytest_cache",
            "__pycache__",
            "node_modules"
        },
        layout_strategy = "vertical",
        layout_config = {
            width = 0.99,
            height = 0.99,
            prompt_position = "bottom",
            -- mirror = true
        }
    }
}

-- https://github.com/nvim-telescope/telescope.nvim/issues/1661
vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number wrap")
