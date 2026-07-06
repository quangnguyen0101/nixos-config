return {
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        priority = 999,
        config = function()
            -- Set default theme
            local themes = {
                "rose-pine",  -- for fun
                "tokyonight", -- for recording
                "accent",     -- this guy is for my eyes
                "catppuccin", -- for recording
            }
            local current_theme_index = 4
            -- Set default theme (first theme)
            vim.cmd.colorscheme(themes[current_theme_index])

            -- Key mapping to switch themes (defined in keymaps.lua)
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 800,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
    },
    {
        "alligator/accent.vim",
        name = "accent",
        priority = 1100,
    },
}
