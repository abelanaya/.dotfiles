return {
    "milanglacier/minuet-ai.nvim",
    config = function()
        require("minuet").setup({
            virtualtext = {
                auto_trigger_ft = {
                    "go",
                    "python",
                    "lua",
                    "c",
                    "javascript",
                    "typescript",
                    "typescriptreact",
                    "javascriptreact",
                    "markdown",
                },
                keymap = {
                    -- accept whole completion
                    accept = "<M-y>",
                    -- accept one line
                    accept_line = "<M-Y>",
                    -- accept n lines (prompts for number)
                    -- e.g. "A-z 2 CR" will accept 2 lines
                    accept_n_lines = "<M-z>",
                    -- Cycle to prev completion item, or manually invoke completion
                    prev = "<M-p>",
                    -- Cycle to next completion item, or manually invoke completion
                    next = "<M-n>",
                    dismiss = "<M-e>",
                },
            },
            provider = "openai_compatible",
            request_timeout = 2.5,
            throttle = 1500, -- Increase to reduce costs and avoid rate limits
            debounce = 600, -- Increase to reduce costs and avoid rate limits
            provider_options = {
                openai_compatible = {
                    api_key = "OPENCODE_GO_API_KEY",
                    end_point = "https://opencode.ai/zen/go/v1/chat/completions",
                    model = "deepseek-v4-flash",
                    name = "Opencode",
                    optional = {
                        max_tokens = 56,
                        top_p = 0.9,
                        -- disable thinking to avoid first token latency
                        thinking = { type = "disabled" },
                    },
                },
            },
        })
    end,
}
