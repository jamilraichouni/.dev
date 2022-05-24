local vi_mode_utils = require("feline.providers.vi_mode")
-- Initialize the components table
function Get_vim_mode_colors()
    local vim_mode = require("feline.providers.vi_mode").get_vim_mode()
    Fg = "#d4d4d4"
    Bg = "#002240"
    if vim_mode == "INSERT" then
        Fg = "#000000"
        Bg = "#ff0000"
    elseif vim_mode == "NORMAL" then
        Bg = "#0066cc"
        -- Bg = "#007acc"
    elseif vim_mode == "TERMINAL" then
        Bg = "#131416"
    end
    return { fg = Fg, bg = Bg }
end

local components = {
    active = {},
    inactive = {}
}
components.active[1] = {
    {
        provider = "vi_mode",
        hl = function()
            -- local name = require("feline.providers.vi_mode").get_mode_highlight_name()
            return {
                name = require("feline.providers.vi_mode").get_vim_mode(),
                fg = Get_vim_mode_colors().fg,
                bg = Get_vim_mode_colors().bg,
                style = "bold,italic"
            }
        end,
        icon = "",
        left_sep = {
            {
                str = " ",
                hl = function()
                    -- local name = require("feline.providers.vi_mode").get_mode_highlight_name()
                    return {
                        name = require("feline.providers.vi_mode").get_vim_mode() .. "_left",
                        bg = Get_vim_mode_colors().bg,
                    }
                end,
            },
        },
        right_sep = {
            {
                str = " ",
                hl = function()
                    -- local name = require("feline.providers.vi_mode").get_mode_highlight_name()
                    return {
                        name = require("feline.providers.vi_mode").get_vim_mode() .. "_right",
                        bg = Get_vim_mode_colors().bg,
                    }
                end,
            },
        },
    },
    {
        provider = {
            name = "file_info",
            opts = {
                type = "full-path",
            },
        },
        short_provider = {
            name = "file_info",
            opts = {
                type = "short-path"
            }
        },
        hl = {
            fg = "#d4d4d4",
            bg = "#002240",
        },
        left_sep = {
            { str = " ", hl = { bg = "#002240", fg = "NONE" } },
        },
        --     "slant_left_2",
        --     { str = " ", hl = { bg = "#002240", fg = "NONE" } },
        -- },
        -- right_sep = {
        --     { str = " ", hl = { bg = "#002240", fg = "NONE" } },
        --     "slant_right_2",
        --     " ",
        -- },
    },
    {
        provider = {
            name = "file_type",
            opts = {
                case = "lowercase",
            },
        },
        hl = {
            fg = "#d4d4d4",
            bg = "#002240",
        },
        left_sep = {
            { str = " (", hl = { bg = "#002240", fg = "NONE" } },
        },
        right_sep = {
            { str = ") ", hl = { bg = "#002240", fg = "NONE" } },
        },
    },
    {
        provider = "git_branch",
        hl = {
            fg = "#d4d4d4",
            bg = "#002240",
            -- bg = "#52697d",
            style = "bold"
        },
        left_sep = {
            { str = " ", hl = { bg = "#002240", fg = "NONE" } },
        },
        right_sep = {
            { str = " ", hl = { bg = "#002240", fg = "NONE" } },
        },
    },
    {
        provider = "git_diff_added",
        hl = {
            fg = "#00ff00",
            bg = "#002240",
        },
    },
    {
        provider = "git_diff_changed",
        hl = {
            fg = "#cecb00",
            bg = "#002240",
        },
    },
    {
        provider = "git_diff_removed",
        hl = {
            fg = "#ff0000",
            bg = "#002240",
        },
    },
    {
        provider = "position",
        padding = true,
        hl = "StatusLine",
        left_sep = {
            { str = " ", hl = { bg = "#002240", fg = "NONE" } },
        },
    },
    {
        provider = "line_percentage",
        hl = "StatusLine",
        left_sep = {
            { str = " (", hl = { bg = "#002240", fg = "NONE" } },
        },
        right_sep = {
            { str = ") ", hl = { bg = "#002240", fg = "NONE" } },
        },
    },
    {
        provider = "diagnostic_errors",
        hl = { bg = "#002240", fg = "#ff0000" }
    },
    {
        provider = "diagnostic_warnings",
        hl = { bg = "#002240", fg = "#ffff00" }
    },
    {
        provider = "diagnostic_hints",
        hl = "StatusLine",
    },
    {
        provider = "diagnostic_info",
        hl = "StatusLine",
    },
}
components.inactive[1] = {
    {
        provider = {
            name = "file_info",
            opts = {
                type = "full-path",
            },
        },
        hl = "StatusLineNC"
    },
}
require("feline").setup({ components = components })
