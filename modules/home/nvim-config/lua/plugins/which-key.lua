return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({
                preset = "modern",
                delay = 300,         -- Hiện menu sau 300ms
                icons = {
                    mappings = true, -- Hiện icon cho keymap
                },
                win = {
                    border = "rounded",
                },
                triggers = {
                    { "<leader>", mode = { "n", "v" } },
                    { "g",        mode = { "n", "v" } }, -- gd, gi, gr, gc, go…
                    { "]",        mode = { "n" } },      -- ]t, ]d
                    { "[",        mode = { "n" } },      -- [t, [d
                    { "z",        mode = { "n" } },      -- folding
                },
            })

            -- Phím học: hiện tất cả mappings
            vim.keymap.set("n", "<leader>?", function()
                wk.show({ global = true })
            end, { desc = "Show ALL keymaps" })

            -- Mô tả cho Ctrl/Alt mappings còn lại
            wk.add({
                { "<C-d>", desc = "Scroll down centered" },
                { "<C-u>", desc = "Scroll up centered" },
                { "<C-s>", desc = "Save file" },
                { "<C-q>", desc = "Quit" },
                { "<A-Left>", desc = "Start of line" },
                { "<A-Right>", desc = "End of line" },
                { "<C-Left>", desc = "Go left split" },
                { "<C-Right>", desc = "Go right split" },
                { "<C-Down>", desc = "Go down split" },
                { "<C-Up>", desc = "Go up split" },
                { "<A-]>", desc = "Grow height" },
                { "<A-[>", desc = "Shrink height" },
                { "<A-.>", desc = "Grow width" },
                { "<A-,>", desc = "Shrink width" },
                { "<A-=>", desc = "Equalize splits" },
            })

            -- Đặt tên nhóm cho các leader key
            wk.add({
                { "<leader>a", group = "AI" },
                { "<leader>b", group = "Buffer" },
                { "<leader>c", group = "Code" },
                { "<leader>d", group = "Debug" },
                { "<leader>e", desc = "Toggle Neotree" },
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Git" },
                { "<leader>n", group = "Notifications" },
                { "<leader>o", group = "Open / Opencode" },
                { "<leader>s", group = "Split" },
                { "<leader>t", group = "Terminal" },
                { "<leader>u", group = "UI" },
                { "<leader>w", desc = "Save file" },
                { "<leader>y", group = "Yank" },
            })
        end,
    },
}
