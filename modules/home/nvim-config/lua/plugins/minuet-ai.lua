return {
    {
        "milanglacier/minuet-ai.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require('minuet').setup {
                -- Do not set lsp.completion.enable or lsp.inline_completion.enable to true.
                -- Or explicitly set them to false:
                lsp = {
                    completion = { enable = false },
                    inline_completion = { enable = false }
                },
                virtualtext = {
                    auto_trigger_ft = { '*' },
                    keymap = {
                        accept = '<A-A>',
                        accept_line = '<A-a>',
                        accept_n_lines = '<A-z>',
                        prev = '<A-[>',
                        next = '<A-]>',
                        dismiss = '<A-e>',
                    },
                },
                provider = 'openai_compatible',
                n_completions = 1,
                context_window = 1024,
                provider_options = {
                    openai_compatible = {
                        api_key = 'TERM',
                        name = 'Ollama',
                        end_point = 'http://localhost:11434/v1/chat/completions',
                        model = 'qwen3-coder-next:cloud',
                        optional = {
                            max_tokens = 70,
                            top_p = 0.9,
                        },
                    },
                },
            }
        end,
    },
}
