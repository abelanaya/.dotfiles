return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            -- NOTE: If you are having trouble with this installation,
            --       refer to the README for telescope-fzf-native for more instructions.
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },

        { "nvim-telescope/telescope-ui-select.nvim" },
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "TelescopeResults",
            callback = function(ctx)
                vim.api.nvim_buf_call(ctx.buf, function()
                    vim.fn.matchadd("TelescopeParent", "\t\t.*$")
                    vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
                end)
            end,
        })

        local function filenameFirst(_, path)
            local tail = vim.fs.basename(path)
            local parent = vim.fs.dirname(path)
            if parent == "." then
                return tail
            end
            return string.format("%s\t\t%s", tail, parent)
        end

        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                mappings = { i = { ["<C-k>"] = "to_fuzzy_refine" } },

                path_display = { "smart" },

                dynamic_preview_title = true,
            },

            pickers = {
                find_files = {
                    path_display = filenameFirst,
                },
                git_files = {
                    path_display = filenameFirst,
                },
            },

            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        })

        -- Enable telescope fzf native, if installed
        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "ui-select")

        local builtin = require("telescope.builtin")

        -- See `:help telescope.builtin`
        vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
        vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
        vim.keymap.set("n", "<leader>/", function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = "[/] Fuzzily search in current buffer" })

        vim.keymap.set("n", "<leader>s/", function()
            builtin.live_grep({
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files",
            })
        end, { desc = "[S]earch [/] in Open Files" })

        -- Shortcut for searching your Neovim configuration files
        vim.keymap.set("n", "<leader>sn", function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
        end, { desc = "[S]earch [N]eovim files" })

        vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Search [G]it [F]iles" })
        vim.keymap.set("n", "<leader>sF", function()
            builtin.find_files({ hidden = true, no_ignore = true })
        end, { desc = "[S]earch [F]iles including hidden and ignored files" })
        vim.keymap.set("n", "<leader>sc", builtin.git_commits, { desc = "[S]earch [c]ommits in current repository" })
        vim.keymap.set("n", "<leader>sC", builtin.git_bcommits, { desc = "[S]earch [C]ommits in current buffer" })
        vim.keymap.set("n", "<leader>gS", builtin.git_stash, { desc = "[G]it [S]tash" })
        vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [f]iles" })
        vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
        vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
        vim.keymap.set("n", "<leader>sG", function()
            builtin.live_grep({ additional_args = { "--hidden", "--no-ignore" } })
        end, { desc = "[S]earch by [G]rep including hidden and ignored files" })
        vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [g]rep" })
        vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
        vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
        vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "[S]earch selecting [T]elescope builtin" })
        vim.keymap.set(
            "n",
            "<leader>sb",
            builtin.resume,
            { desc = "[S]earch [B]rief. Shows output of last Telescope picker" }
        )
    end,
}
