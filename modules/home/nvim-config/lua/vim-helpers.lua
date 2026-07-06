-- ==========================================
-- all vim helper functions here
-- ==========================================

-- ==========================================
-- Auto switch input method (fcitx5 + unikey)
-- ==========================================
local last_layout = "keyboard-us"

local function get_fcitx_layout()
    local f = io.popen("fcitx5-remote -n")
    if f ~= nil then
        local result = f:read("*all")
        f:close()
        if result then
            return result:gsub("%s+", "")
        end
    end
    return "keyboard-us"
end

local function set_fcitx_layout(layout)
    os.execute("fcitx5-remote -s " .. layout)
end

vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        last_layout = get_fcitx_layout()
        set_fcitx_layout("keyboard-us")
    end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        set_fcitx_layout(last_layout)
    end,
})

vim.api.nvim_create_autocmd("FocusGained", {
    callback = function()
        if vim.fn.mode() == "i" then
            set_fcitx_layout(last_layout)
        else
            set_fcitx_layout("keyboard-us")
        end
    end,
})

-- ==========================================
-- Show folder/dir structure
-- ==========================================
vim.api.nvim_create_user_command("ShowTree", function()
    local buf = vim.api.nvim_create_buf(false, true)
    local editor_width = vim.o.columns
    local editor_height = vim.o.lines
    local width = math.floor(editor_width * 0.6)
    local height = math.floor(editor_height * 0.9)
    local row = math.floor((editor_height - height) / 2)
    local col = math.floor((editor_width - width) / 2)
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded",
        style = "minimal",
    }

    vim.api.nvim_open_win(buf, true, opts)
    vim.fn.jobstart("tree -L 4", {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    vim.api.nvim_buf_set_lines(buf, -1, -1, true, { line })
                end
            end
        end,
    })
end, {})

-- <leader>st keymap defined in keymaps.lua
