return {
    "NickvanDyke/opencode.nvim",
    dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `toggle()`.
        { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
    },
    config = function()
        local opencode = require("opencode")

        vim.g.opencode_opts = {
            -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on `opencode_opts`.
        }

        -- Required for `vim.g.opencode_opts.auto_reload`.
        vim.o.autoread = true

        -- Recommended/example keymaps.
        vim.keymap.set({ "n", "x" }, "<leader>oa", function()
            opencode.ask("@this: ", { submit = true })
        end, { desc = "Ask about this" })
        vim.keymap.set({ "n", "x" }, "<leader>os", function()
            opencode.select()
        end, { desc = "Select prompt" })
        vim.keymap.set({ "n", "x" }, "<leader>o+", function()
            opencode.prompt("@this")
        end, { desc = "Add this" })
        vim.keymap.set("n", "<leader>ot", function()
            opencode.toggle()
        end, { desc = "Toggle embedded" })
        vim.keymap.set("n", "<leader>oc", function()
            opencode.command()
        end, { desc = "Select command" })
        vim.keymap.set("n", "<leader>on", function()
            opencode.command("session_new")
        end, { desc = "New session" })
        vim.keymap.set("n", "<leader>oi", function()
            opencode.command("session_interrupt")
        end, { desc = "Interrupt session" })
        vim.keymap.set("n", "<leader>oA", function()
            opencode.command("agent_cycle")
        end, { desc = "Cycle selected agent" })
        vim.keymap.set("n", "<S-C-u>", function()
            opencode.command("messages_half_page_up")
        end, { desc = "Messages half page up" })
        vim.keymap.set("n", "<S-C-d>", function()
            opencode.command("messages_half_page_down")
        end, { desc = "Messages half page down" })
    end,
}
