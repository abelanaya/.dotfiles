return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        input = { enabled = true }, -- Enhances opencode `ask()`
        picker = { -- Enhances opencode `select()`
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
}
