return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = function()
        local select = require("nvim-treesitter-textobjects.select")
        local move = require("nvim-treesitter-textobjects.move")
        local swap = require("nvim-treesitter-textobjects.swap")

        require("nvim-treesitter-textobjects").setup({
            select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
            },
            move = {
                -- whether to set jumps in the jumplist
                set_jumps = true,
            },
        })

        -- Select keymaps. You can use the capture groups defined in textobjects.scm
        local selects = {
            ["a="] = { "@assignment.outer", "Select outer part of an assignment" },
            ["i="] = { "@assignment.inner", "Select inner part of an assignment" },
            ["l="] = { "@assignment.lhs", "Select left hand side of an assignment" },
            ["r="] = { "@assignment.rhs", "Select right hand side of an assignment" },

            ["aa"] = { "@parameter.outer", "Select outer part of a parameter/argument" },
            ["ia"] = { "@parameter.inner", "Select inner part of a parameter/argument" },

            ["al"] = { "@loop.outer", "Select outer part of a loop" },
            ["il"] = { "@loop.inner", "Select inner part of a loop" },

            ["af"] = { "@call.outer", "Select outer part of a function call" },
            ["if"] = { "@call.inner", "Select inner part of a function call" },

            ["am"] = { "@function.outer", "Select outer part of a method/function definition" },
            ["im"] = { "@function.inner", "Select inner part of a method/function definition" },

            ["ac"] = { "@class.outer", "Select outer part of a class" },
            ["ic"] = { "@class.inner", "Select inner part of a class" },
        }
        for keymap, obj in pairs(selects) do
            vim.keymap.set({ "x", "o" }, keymap, function()
                select.select_textobject(obj[1], "textobjects")
            end, { desc = obj[2] })
        end

        -- Move keymaps
        local moves = {
            ["]m"] = { move.goto_next_start, "@function.outer", "Next method/function def start" },
            ["]c"] = { move.goto_next_start, "@class.outer", "Next class start" },
            ["]M"] = { move.goto_next_end, "@function.outer", "Next method/function def end" },
            ["]C"] = { move.goto_next_end, "@class.outer", "Next class end" },
            ["[m"] = { move.goto_previous_start, "@function.outer", "Prev method/function def start" },
            ["[c"] = { move.goto_previous_start, "@class.outer", "Prev class start" },
            ["[M"] = { move.goto_previous_end, "@function.outer", "Prev method/function def end" },
            ["[C"] = { move.goto_previous_end, "@class.outer", "Prev class end" },
        }
        for keymap, obj in pairs(moves) do
            vim.keymap.set({ "n", "x", "o" }, keymap, function()
                obj[1](obj[2], "textobjects")
            end, { desc = obj[3] })
        end

        -- Swap keymaps
        vim.keymap.set("n", "<leader>tsi", function()
            swap.swap_next("@parameter.inner")
        end, { desc = "Swap parameter/argument with next" })
        vim.keymap.set("n", "<leader>tsI", function()
            swap.swap_previous("@parameter.inner")
        end, { desc = "Swap parameter/argument with prev" })

        local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

        -- vim way: ; goes to the direction you were moving.
        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
        vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

        -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
}
