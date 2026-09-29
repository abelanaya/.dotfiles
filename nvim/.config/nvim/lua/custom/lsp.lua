return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            },
        },
        {
            "mason-org/mason-lspconfig.nvim",
        },
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            opts = {
                -- Add only tools you want installed system wide and not per project
                ensure_installed = {
                    "prettierd", -- prettierd increases prettier speed
                    "prettier", -- prettier formatter
                    "pydocstyle", -- python doc linter
                    "pylint", -- python linter
                    "isort", -- python formatter to sort imports alphabetically
                    "black", -- python formatter
                    "mypy", -- python linter
                    "stylua", -- lua formatter
                    "clang-format", -- c/c++ formatter
                    "cpplint", -- cpp linter
                    "markdownlint", -- markdown linter
                },
            },
        },

        "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
        -- [[ Configure LSP ]]
        --  This autocmd gets run when an LSP attaches to a particular buffer.
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
            callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                local bufnr = event.buf

                -- Disable TS server formatting (renamed tsserver -> ts_ls in lspconfig)
                if client and (client.name == "ts_ls" or client.name == "tsserver") then
                    client.server_capabilities.documentFormattingProvider = false
                end

                local nmap = function(keys, func, desc)
                    if desc then
                        desc = "LSP: " .. desc
                    end

                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
                end

                nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")

                nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")

                nmap("gt", vim.lsp.buf.type_definition, "[G]oto [t]ype definition")

                nmap("grn", vim.lsp.buf.rename, "[R]e[n]ame")
                nmap("grx", vim.lsp.codelens.run, "Codelens run")

                vim.keymap.set(
                    { "n", "v" },
                    "<leader>ca",
                    vim.lsp.buf.code_action,
                    { buffer = bufnr, desc = "[C]ode [A]ction", noremap = true, silent = true }
                )

                nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

                -- See `:help K` for why this keymap
                nmap("K", vim.lsp.buf.hover, "Hover Documentation")
                vim.keymap.set({ "n", "i" }, "<C-f>", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })

                -- Lesser used LSP functionality
                nmap("<leader>rs", ":lsp restart<CR>", "[R]e[s]tart LSP")
                nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
                nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
                nmap("<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, "[W]orkspace [L]ist Folders")

                -- Create a command `:LspFormat` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function(_)
                    vim.lsp.buf.format()
                end, { desc = "Format current buffer with LSP" })

                nmap("<leader>fb", ":LspFormat<CR>", "[F]ormat [B]uffer using LSP")

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                if client and client:supports_method("textDocument/documentHighlight") then
                    local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = bufnr,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = bufnr,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
                        end,
                    })
                end

                -- The following keymap is used to enable inlay hints in your
                -- code, if the language server you are using supports them
                --
                -- This may be unwanted, since they displace some of your code
                if client and client:supports_method("textDocument/inlayHint") then
                    nmap("<leader>th", function()
                        vim.lsp.inlay_hint.enable(
                            not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
                            { bufnr = bufnr }
                        )
                    end, "[T]oggle Inlay [H]ints")
                end

                if client and client:supports_method("textDocument/codeLens") then
                    nmap("<leader>tc", function()
                        vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
                    end, "[T]oggle [C]odeLens")
                end
            end,
        })

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers.
        -- The "*" config is merged into every server enabled via vim.lsp.enable().
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
        )
        vim.lsp.config("*", { capabilities = capabilities })

        -- Change the Diagnostic symbols in the sign column (gutter).
        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = " ",
                    [vim.diagnostic.severity.INFO] = " ",
                },
            },
        })

        -- mason-lspconfig v2: installed servers are automatically enabled
        -- via vim.lsp.enable(), using the configs provided by nvim-lspconfig's lsp/ directory.
        require("mason-lspconfig").setup({
            ensure_installed = {
                "astro",
                "bashls",
                "clangd",
                "cssls",
                "html",
                "lua_ls",
                "eslint",
                "pylsp",
                "tailwindcss",
                "ts_ls",
                "rust_analyzer",
            },
            automatic_enable = true,
        })
    end,
}
