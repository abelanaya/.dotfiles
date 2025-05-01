return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
        provider = "copilot",
        -- Should work but currently doesn't
        copilot = {
            model = "claude-3.5-sonnet",
            disabled_tools = {
                "list_files",
                "web_serach",
                "search_files",
                "read_file",
                "create_file",
                "rename_file",
                "delete_file",
                "create_dir",
                "rename_dir",
                "delete_dir",
                "bash",
            },
        },
        auto_suggestions_provider = "copilot",
        cursor_applying_provider = "copilot",
        mappings = {
            ask = "<leader>aa",
            edit = "<leader>ak",
        },
        behaviour = {
            enable_cursor_planning_mode = true,
            enable_claude_text_editor_tool_mode = true,
        },
        system_prompt = function()
            local hub = require("mcphub").get_hub_instance()

            if hub == nil then
                return nil
            end

            return hub:get_active_servers_prompt()
        end,
        custom_tools = function()
            return {
                require("mcphub.extensions.avante").mcp_tool(),
            }
        end,
    },

    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
