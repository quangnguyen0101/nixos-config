return {
    {
        "akinsho/bufferline.nvim",
        version = "*",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            require("bufferline").setup({
                options = {

                    --------------------------
                    -- UI
                    --------------------------
                    mode = "buffers",

                    separator_style = "slant", -- slant | slope | thick | thin

                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = { "close" },
                    },

                    indicator = {
                        style = "underline",
                    },

                    always_show_bufferline = true,

                    show_close_icon = false,
                    show_buffer_close_icons = true,

                    diagnostics = "nvim_lsp",

                    diagnostics_indicator = function(count, level)
                        local icon = level:match("error")
                            and " "
                            or " "

                        return " " .. icon .. count
                    end,

                    --------------------------
                    -- Numbers
                    --------------------------
                    numbers = "ordinal",
                    -- "ordinal"
                    -- "buffer_id"

                    --------------------------
                    -- Unique filenames
                    --------------------------
                    enforce_regular_tabs = false,
                    persist_buffer_sort = true,

                    --------------------------
                    -- Picking
                    --------------------------
                    pick = {
                        alphabet = "asdfjkl;ghnmxcvbziowerutyqp",
                    },

                    --------------------------
                    -- Pinning
                    --------------------------
                    sort_by = "insert_after_current",

                    --------------------------
                    -- Neo-tree sidebar
                    --------------------------
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "󰙅 File Explorer",
                            text_align = "center",
                            separator = true,
                        },
                    },

                    --------------------------
                    -- Groups
                    --------------------------
                    groups = {
                        items = {

                            {
                                name = "Tests",

                                matcher = function(buf)
                                    return buf.name:match("_test")
                                end,
                            },

                            {
                                name = "Docs",

                                matcher = function(buf)
                                    return buf.name:match("%.md")
                                end,
                            },

                            {
                                name = "Config",

                                matcher = function(buf)
                                    return buf.path:match(".config")
                                end,
                            },
                        },
                    },

                    --------------------------
                    -- Custom right area
                    --------------------------
                    custom_areas = {
                        right = function()
                            return {
                                {
                                    text = " "
                                        .. os.date("%H:%M"),
                                },
                            }
                        end,
                    },
                },
            })

        end,
    },
}
