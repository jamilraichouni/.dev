local cmp = require("cmp")

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local cmp_kinds = {
    Text = "  ",
    Method = "  ",
    Function = "  ",
    Constructor = "  ",
    Field = "  ",
    Variable = "  ",
    Class = "  ",
    Interface = "  ",
    Module = "  ",
    Property = "  ",
    Unit = "  ",
    Value = "  ",
    Enum = "  ",
    Keyword = "  ",
    Snippet = "  ",
    Color = "  ",
    File = "  ",
    Reference = "  ",
    Folder = "  ",
    EnumMember = "  ",
    Constant = "  ",
    -- Constant = "  ",
    Struct = "  ",
    Event = "  ",
    Operator = "  ",
    TypeParameter = "  ",
}

-- Alternative symbols {{{
    --   (Text) ",
    --   (Method)",
    --   (Function)",
    --   (Constructor)",
    -- ﴲ  (Field)",
    -- "[] (Variable)",
    --   (Class)",
    -- ﰮ  (Interface)",
    --   (Module)",
    -- 襁 (Property)",
    --   (Unit)",
    --   (Value)",
    -- 練 (Enum)",
    --   (Keyword)",
    --   (Snippet)",
    --   (Color)",
    --   (File)",
    --   (Reference)",
    --   (Folder)",
    --   (EnumMember)",
    -- ﲀ  (Constant)",
    -- ﳤ  (Struct)",
    --   (Event)",
    --   (Operator)",
    --   (TypeParameter)",

    -- 	Class = " ",
    -- 	Color = " ",
    -- 	Constant = " ",
    -- 	Constructor = " ",
    -- 	Enum = "了 ",
    -- 	EnumMember = " ",
    -- 	Field = " ",
    -- 	File = " ",
    -- 	Folder = " ",
    -- 	Function = " ",
    -- 	Interface = "ﰮ ",
    -- 	Keyword = " ",
    -- 	Method = "ƒ ",
    -- 	Module = " ",
    -- 	Property = " ",
    -- 	Snippet = "﬌ ",
    -- 	Struct = " ",
    -- 	Text = " ",
    -- 	Unit = " ",
    -- 	Value = " ",
    -- 	Variable = " ",
-- }}}

cmp.setup({
    formatting = {
        -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-codicons-to-the-menu
        format = function(_, vim_item)
            vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
            return vim_item
        end,
    },
    snippet = {
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body)
            vim.fn["UltiSnips#Anon"](args.body)
            -- require'luasnip'.lsp_expand(args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
        {
            name = "buffer",
            option = {
                keyword_pattern = [[\K\k*]],
            },
        },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_document_symbol" },
        { name = "nvim_lsp_signature_help" },
        {
            name = "path",
            option = {
                trailing_slash = true
            }
        },
        -- { name = "vsnip" },
        { name = "ultisnips" },
        -- { name = "luasnip", option = { use_show_condition = false } },
    }),
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping({
            --     c = function()
            --         if cmp.visible() then
            --             cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            --         else
            --             cmp.complete()
            --         end
            --     end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
            s = function(fallback)
                fallback()
            end,
        }),
        ["<S-Tab>"] = cmp.mapping({
            -- c = function()
            --     if cmp.visible() then
            --         cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            --     else
            --         cmp.complete()
            --     end
            -- end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
            s = function(fallback)
                fallback()
            end,
        }),
        ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
        ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),
        ["<C-n>"] = cmp.mapping({
            -- c = function()
            --     if cmp.visible() then
            --         cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            --     else
            --         vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
            --     end
            -- end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end,
        }),
        ["<C-p>"] = cmp.mapping({
            -- c = function()
            --     if cmp.visible() then
            --         cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            --     else
            --         vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
            --     end
            -- end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end,
        }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
        ["<CR>"] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
            -- c = function(fallback)
            --     if cmp.visible() then
            --         cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            --     else
            --         fallback()
            --     end
            -- end
        }),
    }),
})
