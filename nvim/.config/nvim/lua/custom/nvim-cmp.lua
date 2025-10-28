return {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lua", -- source for nvim lua API
        "hrsh7th/cmp-buffer", -- source for text in buffer
        "hrsh7th/cmp-path", -- source for file system paths
        "hrsh7th/cmp-cmdline", -- source for cmd line
        -- Snippet Engine & its associated nvim-cmp source
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind.nvim", -- vs-code like pictograms

        -- Adds LSP completion capabilities
        "hrsh7th/cmp-nvim-lsp",

        -- Adds a number of user-friendly snippets
        "rafamadriz/friendly-snippets",

        -- Lua completion
        { "folke/lazydev.nvim", opts = {} },
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        lspkind.init({})

        local cmp_insert = { behavior = cmp.SelectBehavior.Insert }

        require("luasnip.loaders.from_vscode").lazy_load()
        luasnip.config.setup({})

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,preview",
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                documentation = cmp.config.window.bordered(),
                completion = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_insert),
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_insert),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<C-e>"] = cmp.mapping.abort(),

                ["<C-y>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                }),

                -- <c-l> will move you to the right of each of the expansion locations.
                -- <c-h> is similar, except moving you backwards.
                -- These help to navigate through the snippet.
                ["<C-l>"] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { "i", "s" }),

                ["<C-h>"] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { "i", "s" }),

                ["<Tab>"] = nil,
                ["<S-Tab>"] = nil,
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" }, -- nvim lsp suggestions
                { name = "luasnip" }, -- snippets
                { name = "buffer" }, -- text within current buffer
                { name = "path" }, -- file system paths
            }, {
                { name = "buffer" },
            }),

            -- configure lspkind for vs-code like pictograms in completion menu
            formatting = {
                fields = { "abbr", "kind", "menu" },
                format = function(entry, item)
                    local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
                    item = lspkind.cmp_format({
                        menu = {
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snip]",
                            buffer = "[Buf]",
                            path = "[Path]",
                            cmdline = "[Cmd]",
                        },
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                        show_labelDetails = true,
                    })(entry, item)
                    if color_item.abbr_hl_group then
                        item.kind_hl_group = color_item.abbr_hl_group
                        item.kind = color_item.abbr
                    end
                    return item
                end,

                expandable_indicator = true,
            },
        })

        -- `/` cmdline setup.
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- `:` cmdline setup.
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
            matching = { disallow_symbol_nonprefix_matching = false },
        })
    end,
}
