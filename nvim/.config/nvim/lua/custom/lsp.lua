return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },

    config = function()
        -- Mason configuration
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_tool_installer.setup({
            -- Add only tools you want installed system wide and not per project
            ensure_installed = {
                "bashls",
                "clangd",
                "cssls",
                "html",
                "lua_ls",
                "eslint",
                "prettierd", -- prettierd increases prettier speed
                "prettier", -- prettier formatter
                "pylsp",
                "pydocstyle", -- python doc linter
                "pylint", -- python linter
                "isort", -- python formatter to sort imports alphabetically
                "black", -- python formatter
                "mypy", -- python linter
                "tailwindcss",
                "tsserver",
                "rust_analyzer",
                "stylua", -- lua formatter
                "clang-format", -- c/c++ formatter
                "cpplint", -- cpp linter
                "markdownlint", -- markdown linter
            },
        })

        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- [[ Configure LSP ]]
        --  This function gets run when an LSP connects to a particular buffer.
        local on_attach = function(client, bufnr)
            -- Disable TSServer formatting
            if client.name == "tsserver" then
                client.server_capabilities.documentFormattingProvider = false
            end

            -- NOTE: Remember that lua is a real programming language, and as such it is possible
            -- to define small helper and utility functions so you don't have to repeat yourself
            -- many times.
            --
            -- In this case, we create a function that lets us more easily define mappings specific
            -- for LSP related items. It sets the mode, buffer and description for us each time.
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

            nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

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
            vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })

            -- Lesser used LSP functionality
            nmap("<leader>rs", ":LspRestart<CR>", "[R]e[s]tart LSP")
            nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
            nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
            nmap("<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, "[W]orkspace [L]ist Folders")

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, "LspFormat", function(_)
                vim.lsp.buf.format()
            end, { desc = "Format current buffer with LSP" })

            nmap("<leader>fb", ":LspFormat<CR>", "[F]ormat [B]uffer using LSP")

            -- The following two autocommands are used to highlight references of the
            -- word under your cursor when your cursor rests there for a little while.
            --    See `:help CursorHold` for information about when this is executed
            --
            -- When you move your cursor, the highlights will be cleared (the second autocommand).
            if client and client.server_capabilities.documentHighlightProvider then
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

            -- The following autocommand is used to enable inlay hints in your
            -- code, if the language server you are using supports them
            --
            -- This may be unwanted, since they displace some of your code
            if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                nmap("<leader>th", function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end, "[T]oggle Inlay [H]ints")
            end
        end

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- Change the Diagnostic symbols in the sign column (gutter)
        local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        mason_lspconfig.setup({
            handlers = {
                function(server_name) -- default lsp server
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,
            },

            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
        })
    end,
}
