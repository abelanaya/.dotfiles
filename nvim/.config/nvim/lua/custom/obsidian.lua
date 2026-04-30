return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    cmd = { "Obsidian" },
    keys = {
        { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "[O]bsidian: [o]pen note in app" },
        { "<leader>on", "<cmd>Obsidian new<cr>", desc = "[O]bsidian: [n]ew note" },
        { "<leader>od", "<cmd>Obsidian today<cr>", desc = "[O]bsidian: today's [d]aily note" },
        { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "[O]bsidian: [y]esterday's daily note" },
        { "<leader>oT", "<cmd>Obsidian tomorrow<cr>", desc = "[O]bsidian: [T]omorrow's daily note" },
        { "<leader>oD", "<cmd>Obsidian dailies<cr>", desc = "[O]bsidian: pick from [D]ailies" },
        { "<leader>og", "<cmd>Obsidian grep<cr>", desc = "[O]bsidian: [g]rep notes" },
        { "<leader>op", "<cmd>Obsidian quick_switch<cr>", desc = "[O]bsidian: [q]uick switch" },
        { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "[O]bsidian: [b]acklinks" },
        { "<leader>ot", "<cmd>Obsidian tags<cr>", desc = "[O]bsidian: [t]ags" },
        { "<leader>or", "<cmd>Obsidian rename<cr>", desc = "[O]bsidian: [r]ename (link-safe)" },
        { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "[O]bsidian: list [l]inks in note" },
        { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "[O]bsidian: switch [w]orkspace" },
        { "<leader>oi", "<cmd>Obsidian template<cr>", desc = "[O]bsidian: [i]nsert template" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "hrsh7th/nvim-cmp",
    },
    opts = {

        legacy_commands = false,

        -- Where new notes go: "current_dir" | "notes_subdir"
        new_notes_location = "notes_subdir",
        notes_subdir = "Notes",

        workspaces = {
            {
                name = "Abel Vault",
                path = "~/Dropbox/Apps/remotely-save/Abel Vault",
            },
        },

        -- Use telescope as the picker (already wired up in this config)
        picker = {
            name = "telescope.nvim",
        },

        templates = {
            folder = "Templates",
        },

        -- Daily notes
        daily_notes = {
            folder = "Notes/Dailies",
            date_format = "%Y-%m-%d",
            alias_format = "%B %-d, %Y",
            template = "Daily Note Template",
        },

        -- nvim-cmp completion (the obsidian source is registered for markdown
        -- buffers in the config function below).
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },

        attachments = {
            folder = "Attachments",
        },
    },
    config = function(_, opts)
        require("obsidian").setup(opts)

        -- Wire the obsidian completion sources into nvim-cmp for markdown
        -- buffers only, so they don't pollute completion elsewhere.
        local ok, cmp = pcall(require, "cmp")
        if ok then
            cmp.setup.filetype("markdown", {
                sources = cmp.config.sources({
                    { name = "obsidian" },
                    { name = "obsidian_new" },
                    { name = "obsidian_tags" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end
    end,
}
