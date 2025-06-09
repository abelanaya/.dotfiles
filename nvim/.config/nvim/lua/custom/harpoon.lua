return {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        -- set keymaps
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "Mark file with harpoon" })
        vim.keymap.set("n", "<leader>he", ui.toggle_quick_menu, { desc = "Toggle harpoon quick menu" })

        -- Vind navigation on files to Alt-QWER
        vim.keymap.set("n", "<M-q>", function()
            ui.nav_file(1)
        end, { desc = "Navigate to harpoon file 1" })
        vim.keymap.set("n", "<M-w>", function()
            ui.nav_file(2)
        end, { desc = "Navigate to harpoon file 2" })
        vim.keymap.set("n", "<M-e>", function()
            ui.nav_file(3)
        end, { desc = "Navigate to harpoon file 3" })
        vim.keymap.set("n", "<M-r>", function()
            ui.nav_file(4)
        end, { desc = "Navigate to harpoon file 4" })

        vim.keymap.set("n", "<M-n>", function()
            ui.nav_next()
        end, { desc = "Go to next harpoon mark" })
        vim.keymap.set("n", "<M-p>", function()
            ui.nav_prev()
        end, { desc = "Go to previous harpoon mark" })
    end,
}
