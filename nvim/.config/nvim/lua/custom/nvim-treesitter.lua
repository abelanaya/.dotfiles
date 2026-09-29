return {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- the main branch does not support lazy-loading
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
        local treesitter_context = require("treesitter-context")

        treesitter_context.setup({
            max_lines = 5,
            multiline_threshold = 1,
            separator = "-",
            trim_scope = "inner",
        })

        -- Parsers are installed via `install`, no `ensure_installed`/`auto_install` anymore.
        local parsers = {
            "c",
            "cpp",
            "go",
            "lua",
            "python",
            "rust",
            "tsx",
            "javascript",
            "typescript",
            "vimdoc",
            "vim",
            "markdown",
            "markdown_inline",
            "dockerfile",
            "gitignore",
            "bash",
            "query",
            "yaml",
            "xml",
            "html",
            "json",
            "css",
        }
        require("nvim-treesitter").install(parsers)

        -- Highlighting is provided by Neovim itself now; enable it per filetype.
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "*" },
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })

        -- Treesitter indentation (experimental on the main branch).
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "*" },
            callback = function()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
