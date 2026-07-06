vim.g.nvim_options_loaded = true
-- ==========================================
-- Sane Editing Defaults
-- ==========================================
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.number = true         -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers for easy jumping
vim.opt.mouse = "a"           -- Enable mouse support for all modes
vim.opt.tabstop = 4           -- Number of visual spaces per <Tab>
vim.opt.softtabstop = 4       -- Backspace deletes 4 spaces like a tab
vim.opt.shiftwidth = 4        -- Number of spaces per indent step
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.smartindent = true    -- Smart autoindent
vim.opt.wrap = true           -- Wrap lines
vim.opt.ignorecase = true     -- Case-insensitive searching
vim.opt.smartcase = true      -- Override ignorecase if search has capitals
vim.opt.hlsearch = true       -- Highlight search results
vim.opt.incsearch = true      -- Incremental searching
vim.opt.termguicolors = true  -- Enable 24-bit RGB colors
-- vim.opt.colorcolumn = "94"      -- Column width ruler

-- ==========================================
-- UX / Feel
-- ==========================================
vim.opt.scrolloff = 8      -- Always keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8  -- Same but horizontal
vim.opt.cursorline = true  -- Highlight current line
vim.opt.signcolumn = "yes" -- Always show sign column (prevents layout shift)
vim.opt.updatetime = 50    -- Faster CursorHold trigger (ms)
vim.opt.timeoutlen = 300   -- Time to wait for key sequence (ms)
vim.opt.splitright = true  -- Vertical split opens to the right
vim.opt.splitbelow = true  -- Horizontal split opens below

-- ==========================================
-- Undo
-- ==========================================
vim.opt.undofile = true -- Persistent undo history across restarts

-- ==========================================
-- File Navigation
-- ==========================================
vim.opt.path:append("**") -- Recursive file search with :find
vim.opt.wildmenu = true   -- Better command-line autocomplete

-- ==========================================
-- OS Integration
-- ==========================================
vim.opt.clipboard = "unnamedplus" -- Sync with Wayland/X11 clipboard

-- ==========================================
-- Line Number Colors
-- ==========================================
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "white" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#ead84e" })

-- ==========================================
-- Suppress LSP Noise
-- ==========================================
local notify_original = vim.notify
vim.notify = function(msg, ...)
    if msg and (
            msg:match("position_encoding param is required")
            or msg:match("Defaulting to position encoding of the first client")
            or msg:match("multiple different client offset_encodings")
        ) then
        return
    end
    return notify_original(msg, ...)
end

-- Popup Diagnostic
vim.o.updatetime = 250

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, {
            focus = false
        })
    end
})

vim.g.mapleader = " "
