return {
    "mfussenegger/nvim-lint",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    config = function()
        local lint = require("lint")

        -- Will call these linters with a command. If system wide available or on project folder
        -- You can only use linters that are availble in that plugin
        lint.linters_by_ft = {
            cpp = { "cpplint" },
            -- For JS and TS use LSP linting
            javascript = { "standardjs" },
            typescript = { "standardjs" },
            javascriptreact = { "standardjs" },
            typescriptreact = { "standardjs" },
            python = { "pylint", "pydocstyle", "mypy" },
        }

        local binary_name = "standard"

        local cmd_string = function()
            local local_binary = vim.fn.fnamemodify("./node_modules/.bin/" .. binary_name, ":p")
            return vim.loop.fs_stat(local_binary) and local_binary or binary_name
        end

        -- Use always local standard
        local standardjs = lint.linters.standardjs
        standardjs.cmd = cmd_string()

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        -- Lint always ignoring errors to avoid problems when linters are not locally installed
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint(nil, { ignore_errors = true })
            end,
        })

        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint(nil, { ignore_errors = true })
        end, { desc = "Trigger linting for current file" })
    end,
}
