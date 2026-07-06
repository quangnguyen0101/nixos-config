return {
    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    -- Dùng noice để hiện LSP progress
                    progress = { enabled = true },
                    -- Override các LSP hover/signature
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                    hover = { enabled = true },
                    signature = { enabled = true },
                },
                presets = {
                    bottom_search = true,         -- Search bar ở dưới
                    command_palette = true,       -- Command palette đẹp hơn
                    long_message_to_split = true, -- Message dài tự mở split
                    inc_rename = false,
                    lsp_doc_border = true,        -- Border cho LSP docs
                },
                routes = {
                    -- Ẩn thông báo "written" khi lưu file
                    {
                        filter = {
                            event = "msg_show",
                            kind = "",
                            find = "written",
                        },
                        opts = { skip = true },
                    },
                },
            })

        end,
    },
}
