return {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },

    config = function()
        require("codecompanion").setup({

            adapters = {
                http = {
                    ollama = function()
                        return require("codecompanion.adapters").extend(
                            "ollama",
                            {
                                name = "ollama",

                                schema = {
                                    model = {
                                        default = "qwen3-coder-next:cloud",
                                    },
                                },

                                env = {
                                    url = "http://localhost:11434",
                                },

                                parameters = {
                                    sync = true,
                                },
                            }
                        )
                    end,
                },
            },

            strategies = {

                chat = {
                    adapter = "ollama",
                },

                inline = {
                    adapter = "ollama",
                },

                cmd = {
                    adapter = "ollama",
                },

            },
        })

    end,
}
