return {
    "NickvanDyke/opencode.nvim",
    version = "*",
    dependencies = {
        {
            -- `snacks.nvim` integration is recommended, but optional
            ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
            "folke/snacks.nvim",
            opts = {
                input = {}, -- Enhances `ask()`
                picker = { -- Enhances `select()`
                    actions = {
                        opencode_send = function(...)
                            return require("opencode").snacks_picker_send(...)
                        end,
                    },
                    win = {
                        input = {
                            keys = {
                                ["<M-a>"] = { "opencode_send", mode = { "n", "i" } },
                            },
                        },
                    },
                },
            },
        },
    },
    config = function()
        local opencode = require("opencode")
        local prompts = require("opencode.config").opts.prompts

        if prompts == nil then
            return
        end

        vim.g.opencode_opts = {
            -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on `opencode_opts`.
        }

        -- Required for `vim.g.opencode_opts.auto_reload`.
        vim.o.autoread = true

        -- Recommended/example keymaps.
        vim.keymap.set({ "n", "x" }, "<leader>ae", function()
            opencode.prompt(prompts.explain.prompt, prompts.explain)
        end, { desc = "[A]I [E]xplain" })

        vim.keymap.set({ "n", "x" }, "<leader>ar", function()
            opencode.prompt(prompts.review.prompt, prompts.review)
        end, { desc = "[A]I [R]eview" })

        vim.keymap.set({ "n", "x" }, "<leader>at", function()
            opencode.prompt(prompts.test.prompt, prompts.test)
        end, { desc = "[A]I [T]est" })

        vim.keymap.set({ "n", "x" }, "<leader>af", function()
            opencode.prompt(prompts.fix.prompt, prompts.fix)
        end, { desc = "[A]I [f]ix" })

        vim.keymap.set({ "n", "x" }, "<leader>aF", function()
            opencode.prompt("Fix @diagnostics", { prompt = "Fix @diagnostics", submit = true })
        end, { desc = "[A]I [F]ix Diagnostics" })

        vim.keymap.set({ "n", "x" }, "<leader>ao", function()
            opencode.prompt(prompts.optimize.prompt, prompts.optimize)
        end, { desc = "[A]I [O]ptimize" })

        vim.keymap.set({ "n", "x" }, "<leader>ad", function()
            opencode.prompt(prompts.document.prompt, prompts.document)
        end, { desc = "[A]I [D]ocument" })

        vim.keymap.set({ "n", "x" }, "<leader>ag", function()
            opencode.prompt(prompts.diff.prompt, prompts.diff)
        end, { desc = "[A]I [g]it diff review" })

        vim.keymap.set({ "n", "x" }, "<leader>aa", function()
            opencode.ask("@this: ", { submit = true })
        end, { desc = "[A]I [A]sk" })

        vim.keymap.set({ "n", "x" }, "<leader>as", function()
            opencode.select()
        end, { desc = "[A]I [s]elect prompt" })

        vim.keymap.set({ "n", "t" }, "<leader>ai", function()
            opencode.toggle()
        end, { desc = "[A][I] Toggle" })

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
