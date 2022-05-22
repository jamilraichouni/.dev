local vi_mode_utils = require("feline.providers.vi_mode")
-- Initialize the components table
local components = {
    active = {},
    inactive = {}
}
components.active[1] = {
    {
        provider = "vi_mode",
        hl = function()
            return {
                name = vi_mode_utils.get_mode_highlight_name(),
                fg = vi_mode_utils.get_mode_color(),
                style = "bold",
            }
        end,
    },
    {
        provider = "file_info",
        type = "unique",
        priority = 10,
        hl = {
            fg = "#d4d4d4",
            bg = "#002f54",
            -- bg = "blue",
            style = "bold",
        },
        left_sep = {
            "slant_left_2",
            { str = " ", hl = { bg = "#002f54", fg = "NONE" } },
        },
        right_sep = {
            { str = " ", hl = { bg = "#002f54", fg = "NONE" } },
            "slant_right_2",
            " ",
        },
    },
    {
        provider = "position"
    }
}
require("feline").setup({ components = components })
