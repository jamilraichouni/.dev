vim.g.ale_python_auto_poetry = 0
vim.g.ale_detail_to_floating_preview = 1
vim.g.ale_open_list = 0
vim.g.ale_sign_column_always = 1
vim.g.ale_completion_enabled = 0
vim.g.ale_echo_msg_error_str = "E"
vim.g.ale_echo_msg_info_str = "I"
vim.g.ale_echo_msg_warning_str = "W"
vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"
local sign = require("config.signs").sign
vim.g.ale_sign_error = sign.error
vim.g.ale_sign_warning = sign.warn
vim.g.ale_sign_info = sign.info
-- vim.g.ale_set_loclist = 1  -- can be useful when combining ALE & other plugins setting quickfix errs etc.
vim.g.ale_keep_list_window_open = 1
vim.g.ale_fixers = {
    ["*"] = {
        "remove_trailing_lines",  -- Remove all blank lines at the end of a file
        "trim_whitespace"  -- Remove trailing whitespace chars at the end of every line
    },
    ["json"] = {"fixjson"},
    python = {"black", "isort"},
    toml = {"dprint"},
}
vim.g.ale_fix_on_save = 1
vim.g.ale_fix_on_save_ignore = {
    python = {"isort"}
}
vim.g.ale_linters = {
    dockerfile = {"hadolint"},
    ["json"] = {"jq"},
    python = {"flake8", "mypy", "pyright"},
    yaml = {
        "yaml-language-server",  -- https://github.com/redhat-developer/yaml-language-server
        "yamllint",  -- https://github.com/adrienverge/yamllint
    }
}
vim.g.ale_use_global_executables = 1

-- Linter/ fixer configs:
vim.g.ale_dprint_options = "--config='" .. vim.fn.stdpath("config") .. "/dprint.json'"

-- ESlint (https://eslint.org)
vim.g.ale_javascript_eslint_options = "--config='" .. vim.fn.stdpath("config") .. "/eslintrc.json' --ignore-path='" .. vim.fn.stdpath("config") .. "/eslintignore'"
-- vim.g.ale_yaml_ls_config = {
--     ["yaml.yamlVersion"] = "1.2",
-- }
vim.g.ale_yaml_ls_config = {
    yaml = {
        yamlVersion = "1.2",
    }
}
-- vim.g.ale_yaml_ls_config = {
--     yaml = {
--         yamlVersion = "1.2",
--         validate = true,
--         format = true,
--         hover = true,
--         completion = false,
--         schemaStore = {
--             enable = true
--         },
--         schemas = {
--             ["/Users/jamilraichouni/repos/mddocgen/builddesc_schema.json"] = "builddesc*.yml"
--         }
--     },
-- }
