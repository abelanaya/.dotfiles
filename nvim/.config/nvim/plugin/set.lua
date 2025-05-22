-- [[ Setting options ]]
-- See `:help vim.o`

-- Using nerd font
vim.g.have_nerd_font = true

-- Set Ruler, TextWidth and indentation configuration
vim.opt.textwidth = 120
vim.opt.colorcolumn = { 120 }

-- Disable show mode below lualine as it is already shown in lualine
vim.opt.showmode = false

-- Set breakline
vim.opt.breakindent = true

-- Disable wrapping
vim.opt.wrap = true

-- Set relative number
vim.opt.nu = true
vim.opt.rnu = true

-- Append completion messages to shortmess to avoid having to hit-enter
vim.opt.shortmess:append("c")

-- Set EOL, Whitespace, Trailing, Whitespace
vim.opt.listchars:append({
    eol = "↵",
    trail = "·",
    -- tab = "→ ",
    tab = "  ",
    -- space = "·",
    -- lead = "·",
    precedes = "<",
    extends = ">",
})
vim.opt.list = true

-- Configure tab size
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Configure vim smart indent
vim.opt.smartindent = true

-- Set highlight on search. Useful to highlight words. To clear highlight use :noh or <ESC> keymapped
vim.o.hlsearch = true
vim.o.incsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlight" })

-- Add scroll buffer of 8 lines (means that going down will ensure 8 lines are maintained at the botttom form cursor)
vim.o.scrolloff = 8

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Draw relative number column first and then signcolumn
vim.o.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum}%s"

-- Show statusline only in last window
vim.o.laststatus = 3

-- Configure how new splits would be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Preview substitutions live as you type
vim.o.inccommand = "split"

-- Disable automatically adding comments consequent to the line
vim.opt.formatoptions:remove("o")

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Append files with @ in filename to recognized files
vim.opt.isfname:append("@-@")

-- Enable mouse mode in all vim modes
vim.o.mouse = "a"

--  Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- Use C-V while in insert mode or other OS window to paste yanked contents.
vim.o.clipboard = "unnamedplus"

-- Disable backup and swapfile and enable long history for undo tree plugin
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 50
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,preview"

-- Configure diagnostic windows
vim.diagnostic.config({
    virtual_text = true,
    float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
})

-- Autocmd to remove trailing whitespaces and newlines on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function()
        if vim.g.disable_autoformat then
            return
        end
        vim.cmd(".lua MiniTrailspace.trim()")
        vim.cmd(".lua MiniTrailspace.trim_last_lines()")
    end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 200,
        })
    end,
    group = highlight_group,
    pattern = "*",
})

-- Set color scheme
vim.cmd("colorscheme onedark_vivid")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
