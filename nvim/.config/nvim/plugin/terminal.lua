local set = vim.opt_local

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", {}),
    callback = function()
        set.number = false
        set.relativenumber = false
        set.scrolloff = 0
    end,
})

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Open a bottom terminal with <leader>bt, toggle it from anywhere —
-- including inside the terminal pane, where it closes it.
local bottom_term_cmd = vim.o.shell
local bottom_term_opts = {
    win = {
        position = "bottom",
        height = 12,
        enter = true,
    },
}
vim.keymap.set({ "n", "t", "x" }, "<leader>bt", function()
    require("snacks.terminal").toggle(bottom_term_cmd, bottom_term_opts)
end, { desc = "[b]ottom [t]erminal toggle" })
