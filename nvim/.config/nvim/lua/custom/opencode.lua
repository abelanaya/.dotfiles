return {
    "NickvanDyke/opencode.nvim",
    version = "*",
    dependencies = {
        -- `snacks.nvim` integration is recommended, but optional
        "folke/snacks.nvim",
    },
    config = function()
        local opencode = require("opencode")

        local opencode_cmd = "opencode --port"
        ---@type snacks.terminal.Opts
        local snacks_terminal_opts = {
            win = {
                position = "right",
                enter = false,
            },
        }

        vim.g.opencode_opts = {
            -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on `opencode_opts`.
            server = {
                start = function()
                    require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
                end,
            },
        }

        -- Toggle functionality (removed from plugin in v0.11.0; use snacks.terminal).
        vim.keymap.set({ "n", "t", "x" }, "<leader>ai", function()
            require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
        end, { desc = "[A][I] Toggle" })

        -- Optionally show upon submitting prompt
        vim.api.nvim_create_autocmd("User", {
            pattern = { "OpencodeEvent:tui.command.execute" },
            callback = function(args)
                ---@type opencode.server.Event
                local event = args.data.event
                if event.properties.command == "prompt.submit" then
                    local win = require("snacks.terminal").get(opencode_cmd, { create = false })
                    if win then
                        win:show()
                    end
                end
            end,
        })

        -- Required for `vim.g.opencode_opts.auto_reload`.
        vim.o.autoread = true

        -- Recommended/example keymaps.
        vim.keymap.set({ "n", "x" }, "<leader>ae", function()
            opencode.prompt("Explain @this and its context")
        end, { desc = "[A]I [E]xplain" })

        vim.keymap.set({ "n", "x" }, "<leader>ar", function()
            opencode.prompt("Review @this for correctness and readability")
        end, { desc = "[A]I [R]eview" })

        vim.keymap.set({ "n", "x" }, "<leader>at", function()
            opencode.prompt("Add tests for @this")
        end, { desc = "[A]I [T]est" })

        vim.keymap.set({ "n", "x" }, "<leader>af", function()
            opencode.prompt("Fix @diagnostics")
        end, { desc = "[A]I [f]ix" })

        vim.keymap.set({ "n", "x" }, "<leader>aD", function()
            opencode.prompt("Explain @diagnostics")
        end, { desc = "[A]I Explain [D]iagnostics" })

        vim.keymap.set({ "n", "x" }, "<leader>ao", function()
            opencode.prompt("Optimize @this for performance and readability")
        end, { desc = "[A]I [O]ptimize" })

        vim.keymap.set({ "n", "x" }, "<leader>ad", function()
            opencode.prompt("Add documentation for @this")
        end, { desc = "[A]I [D]ocument" })

        vim.keymap.set({ "n", "x" }, "<leader>ag", function()
            opencode.prompt("Review git diff output for @buffer")
        end, { desc = "[A]I [g]it diff review" })

        vim.keymap.set({ "n", "x" }, "<leader>aa", function()
            opencode.ask("@this: ")
        end, { desc = "[A]I [A]sk" })

        vim.keymap.set({ "n", "x" }, "<leader>as", function()
            opencode.select()
        end, { desc = "[A]I [s]elect prompt" })

        -- Bare `@this` with no instruction: sends only the current context
        -- reference to opencode, leaving you to type the actual prompt there.
        vim.keymap.set({ "n", "x" }, "<leader>aP", function()
            opencode.prompt("@this")
        end, { desc = "[O]pencode [p]aste this" })

        vim.keymap.set("n", "<leader>aN", function()
            opencode.command("session.new")
        end, { desc = "[O]pencode [n]ew session" })

        vim.keymap.set("n", "<leader>aI", function()
            opencode.command("session.interrupt")
        end, { desc = "[O]pencode [i]nterrupt session" })

        vim.keymap.set("n", "<leader>aA", function()
            opencode.command("agent.cycle")
        end, { desc = "[O]pencode [A]gent cycle" })

        vim.keymap.set("n", "<M-u>", function()
            opencode.command("session.half.page.up")
        end, { desc = "[O]pencode [m]essages half page up", noremap = true })

        vim.keymap.set("n", "<M-d>", function()
            opencode.command("session.half.page.down")
        end, { desc = "[O]pencode [m]essages half page down" })

        vim.keymap.set({ "n", "x" }, "go", function()
            return require("opencode").operator("@this ")
        end, { desc = "Add range to opencode", expr = true })

        vim.keymap.set("n", "goo", function()
            return require("opencode").operator("@this ") .. "_"
        end, { desc = "Add line to opencode", expr = true })
    end,
}
