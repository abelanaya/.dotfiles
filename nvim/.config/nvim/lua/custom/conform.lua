return { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    lazy = false,
    config = function()
        require("conform").setup({
            notify_on_error = false,
            notify_no_formatters = false,
            format_on_save = function(bufnr)
                -- Disable autoformat for certain filetypes
                local disable_filetypes = { c = true, cpp = true }
                if
                    vim.g.disable_autoformat
                    or vim.b[bufnr].disable_autoformat
                    or disable_filetypes[vim.bo[bufnr].filetype]
                then
                    return
                end
                return {
                    timeout_ms = 1000,
                    lsp_format = "fallback",
                }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                -- For JS and TS fallback to LSP eslint
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
            },
        })

        -- User command to disable autoformatting
        vim.api.nvim_create_user_command("FormatDisable", function()
            vim.g.disable_autoformat = true
        end, {
            desc = "Disable autoformat-on-save",
            bang = true,
        })

        -- User command to enable autoformatting
        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat-on-save",
        })
    end,
}
