return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup({
                signs = true, -- Hiện icon ở signcolumn
                keywords = {
                    FIX  = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                    TODO = { icon = " ", color = "info" },
                    HACK = { icon = " ", color = "warning" },
                    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                    PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                },
                highlight = {
                    before  = "",
                    keyword = "wide",
                    after   = "fg",
                },
            })

        end,
    },
}
