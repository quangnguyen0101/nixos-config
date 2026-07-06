-- Central keymaps file
-- All keymaps are defined here with `desc` for which-key compatibility
-- Plugin commands use function() wrappers for lazy loading

local map = vim.keymap.set

-- ── Editor: Scrolling ──────────────────────────────────────────
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- ── Editor: Line Movement (Visual) ─────────────────────────────
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move line up" })

-- ── Editor: Clipboard ──────────────────────────────────────────
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
map("n", "<leader>dd", '"_dd', { desc = "Delete line to void" })
map("v", "<leader>d", '"_d', { desc = "Delete selection to void" })

-- ── Editor: Line Navigation ────────────────────────────────────
map({ "n", "v" }, "<A-Left>", "^", { desc = "Start of line" })
map({ "n", "v" }, "<A-Right>", "$", { desc = "End of line" })

-- ── File: Save / Quit ──────────────────────────────────────────
map("n", "<leader>w", ":w<CR>", { silent = true, desc = "Save file" })
map("n", "<C-s>", ":w<CR>", { silent = true, desc = "Save file" })
map("n", "<C-q>", ":q<CR>", { silent = true, desc = "Quit" })

-- ── File: Explorer ─────────────────────────────────────────────
map({ "n", "v" }, "<leader>e", ":Neotree toggle<CR>", { silent = true, desc = "Toggle Neotree" })

-- ── UI: Cycle themes ───────────────────────────────────────────
local _themes = { "rose-pine", "tokyonight", "accent", "catppuccin" }
local _theme_idx = 4
map("n", "<leader>ut", function()
    _theme_idx = (_theme_idx % #_themes) + 1
    vim.cmd.colorscheme(_themes[_theme_idx])
    print("Theme: " .. _themes[_theme_idx])
end, { noremap = true, silent = true, desc = "Cycle theme" })

-- ── File: Copy path / Open in browser ──────────────────────────
map("n", "<leader>yc", function()
    local fp = vim.fn.expand("%:p")
    vim.fn.setreg("+", fp)
    print("Copied: " .. fp)
end, { desc = "Copy file path" })

map("n", "<leader>ob", function()
    local fp = vim.fn.expand("%:p")
    if fp ~= "" then
        local browser = (vim.fn.executable("firefox") == 1) and "firefox" or "google-chrome"
        os.execute(browser .. " '" .. fp .. "' &")
    end
end, { desc = "Open file in browser" })

-- ── Diagnostics ─────────────────────────────────────────────────
map("n", "<leader>ce", function()
    local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
    if #diags > 0 then
        vim.fn.setreg("+", diags[1].message)
        print("Copied: " .. diags[1].message)
    else
        print("No diagnostic at cursor")
    end
end, { noremap = true, silent = true, desc = "Copy diagnostic" })

map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

-- ── Utilities ────────────────────────────────────────────────────
map("n", "<leader>st", ":ShowTree<CR>", { desc = "Show directory tree" })

-- ── Split / Window Management ──────────────────────────────────
map("n", "<leader>sv", ":vsplit<CR>", { silent = true, desc = "Vertical split" })
map("n", "<leader>sh", ":split<CR>", { silent = true, desc = "Horizontal split" })
map("n", "<leader>sx", ":close<CR>", { silent = true, desc = "Close split" })
map("n", "<leader>so", ":only<CR>", { silent = true, desc = "Close other splits" })
map("n", "<leader>sr", ":wincmd r<CR>", { silent = true, desc = "Rotate splits" })

-- Split navigation
map("n", "<C-Left>", "<C-w>h", { desc = "Go left" })
map("n", "<C-Right>", "<C-w>l", { desc = "Go right" })
map("n", "<C-Down>", "<C-w>j", { desc = "Go down" })
map("n", "<C-Up>", "<C-w>k", { desc = "Go up" })

-- Split resize
map("n", "<A-]>", ":resize +2<CR>", { silent = true, desc = "Grow height" })
map("n", "<A-[>", ":resize -2<CR>", { silent = true, desc = "Shrink height" })
map("n", "<A-,>", ":vertical resize -2<CR>", { silent = true, desc = "Shrink width" })
map("n", "<A-.>", ":vertical resize +2<CR>", { silent = true, desc = "Grow width" })
map("n", "<A-=>", ":wincmd =<CR>", { silent = true, desc = "Equalize splits" })

-- ── Bufferline ──────────────────────────────────────────────────
map("n", "<S-l>", function() vim.cmd("BufferLineCycleNext") end, { desc = "Next buffer" })
map("n", "<S-h>", function() vim.cmd("BufferLineCyclePrev") end, { desc = "Prev buffer" })
map("n", "<leader>b>", function() vim.cmd("BufferLineMoveNext") end, { desc = "Move buffer right" })
map("n", "<leader>b<", function() vim.cmd("BufferLineMovePrev") end, { desc = "Move buffer left" })
map("n", "<leader>bp", function() vim.cmd("BufferLinePick") end, { desc = "Pick buffer" })
map("n", "<leader>bi", function() vim.cmd("BufferLineTogglePin") end, { desc = "Pin buffer" })
map("n", "<leader>bx", ":bdelete<CR>", { silent = true, desc = "Close buffer" })

for i = 1, 9 do
    map("n", "<leader>" .. i, function()
        vim.cmd("BufferLineGoToBuffer " .. i)
    end, { desc = "Buffer " .. i })
end

-- ── Telescope ───────────────────────────────────────────────────
local function tel()
    return require("telescope.builtin")
end
map("n", "<leader>ff", function() tel().find_files() end, { desc = "Find files" })
map("n", "<leader>fg", function() tel().live_grep() end, { desc = "Live grep" })
map("n", "<leader>fb", function() tel().buffers() end, { desc = "Buffers" })
map("n", "<leader>fh", function() tel().help_tags() end, { desc = "Help tags" })

-- ── Terminal ────────────────────────────────────────────────────
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("n", "<leader>th", function() vim.cmd("ToggleTerm direction=horizontal") end,
    { silent = true, desc = "Terminal horizontal" })
map("n", "<leader>tv", function() vim.cmd("ToggleTerm direction=vertical") end,
    { silent = true, desc = "Terminal vertical" })
map("n", "<leader>tf", function() vim.cmd("ToggleTerm direction=float") end,
    { silent = true, desc = "Terminal float" })

-- ── AI: CodeCompanion ───────────────────────────────────────────
map("n", "<leader>ac", function() vim.cmd("CodeCompanionChat") end, { desc = "AI Chat" })
map("v", "<leader>ae", function() vim.cmd("CodeCompanionActions") end, { desc = "AI Actions" })
map("n", "<leader>aa", function() vim.cmd("CodeCompanion") end, { desc = "AI Inline" })

-- ── Notifications (Noice) ───────────────────────────────────────
map("n", "<leader>nm", function() vim.cmd("Noice") end,
    { silent = true, desc = "Show messages" })
map("n", "<leader>nd", function() vim.cmd("NoiceDismiss") end,
    { silent = true, desc = "Dismiss notifications" })

-- ── Todo Comments ───────────────────────────────────────────────
map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev TODO" })

-- ── Opencode ────────────────────────────────────────────────────
map({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end,
    { desc = "Ask opencode" })
map({ "n", "x" }, "<leader>ox", function() require("opencode").select() end, { desc = "Select opencode" })
map({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
    { desc = "Add range to opencode", expr = true })
map("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
    { desc = "Add line to opencode", expr = true })
map("n", "<leader>ou", function() require("opencode").command("session.half.page.up") end,
    { desc = "Scroll opencode up" })
map("n", "<leader>od", function() require("opencode").command("session.half.page.down") end,
    { desc = "Scroll opencode down" })

-- ── LSP ─────────────────────────────────────────────────────────
map("n", "<leader>rn", function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })
map({ "n", "v" }, "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code action" })

-- ── LSP: File Symbols (Telescope) ──────────────────────────────
map("n", "<leader>fm", function()
    local ft = vim.bo.filetype
    local sym_map = {
        python = "function",
        javascript = "function",
        typescript = "function",
        java = "class",
        lua = "function",
        c = { "function", "struct" },
        cpp = { "function", "class", "struct" },
        rust = { "function", "struct", "impl" },
    }
    tel().lsp_document_symbols({ symbols = sym_map[ft] or "function" })
end, { desc = "File symbols" })

-- ── DAP (Debug) ──────────────────────────────────────────────────
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
map("n", "<leader>do", function() require("dap").step_over() end, { desc = "Step over" })
map("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step into" })
map("n", "<leader>dx", function() require("dap").terminate() end, { desc = "Terminate" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })

-- ── Git (Telescope) ─────────────────────────────────────────────
map("n", "<leader>gs", function() tel().git_status() end, { desc = "Git status" })
map("n", "<leader>gc", function() tel().git_commits() end, { desc = "Git commits" })
map("n", "<leader>gb", function() tel().git_branches() end, { desc = "Git branches" })
map("n", "<leader>gd", function() tel().git_diff() end, { desc = "Git diff" })
map("n", "<leader>gf", function() tel().git_files() end, { desc = "Git files" })
