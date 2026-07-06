return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
            ensure_installed = {
                "ts_ls",
                "clangd",    -- C/C++
                "omnisharp", -- C#
                "html",      -- HTML
                "jsonls",    -- JSON
                --"jdtls",        -- Java
                "texlab",    -- LaTeX
            },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        lazy = false,
        opts = {
            ensure_installed = {
                "prettierd",             -- formatter JS/TS/HTML/CSS/JSON/YAML/Markdown
                "shfmt",                 -- formatter Bash
                "nixfmt",                -- formatter Nix
                "latexindent",           -- formatter LaTeX
                "shellcheck",            -- linter Bash
                --"yamllint",              -- linter YAML
                "hadolint",              -- linter Dockerfile
                "markdownlint-cli2",     -- linter Markdown
                "bash-debug-adapter",    -- DAP Bash
                "netcoredbg",            -- DAP C#
            },
        },
    },
    -- Formatter
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    python = { "black" },
                    c      = { "clang_format" },
                    cpp    = { "clang_format" },
                    rust   = { "rustfmt" },
                    -- JS/TS/Web
                    javascript = { "prettierd" },
                    typescript = { "prettierd" },
                    javascriptreact = { "prettierd" },
                    typescriptreact = { "prettierd" },
                    html   = { "prettierd" },
                    css    = { "prettierd" },
                    json   = { "prettierd" },
                    yaml   = { "prettierd" },
                    markdown = { "prettierd" },
                    svelte = { "prettierd" },
                    -- Scripts
                    bash = { "shfmt" },
                    sh   = { "shfmt" },
                    zsh  = { "shfmt" },
                    -- Others
                    nix   = { "nixfmt" },
                    tex   = { "latexindent" },
                    latex = { "latexindent" },
                    zig   = { "zigfmt" },
                    proto = { "buf" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            })
        end,
    },
    -- Linter
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                python = { "pylint" },
                c      = { "cpplint" },
                cpp    = { "cpplint" },
                rust   = { "clippy" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                bash = { "shellcheck" },
                sh   = { "shellcheck" },
                yaml = { "yamllint" },
                dockerfile = { "hadolint" },
                markdown = { "markdownlint_cli2" },
            }
            -- Tự động lint khi lưu file
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
    -- DAP
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",         -- UI cho debugger
            "nvim-neodev/neodev.nvim",
            "mfussenegger/nvim-dap-python", -- Python DAP
            "vadimcn/vscode-lldb",          -- C/C++/Rust DAP
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            -- Tự động mở/đóng UI khi debug
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Python
            require("dap-python").setup("python3")

            -- C/C++/Rust (dùng codelldb)
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                    args = { "--port", "${port}" },
                },
            }
            dap.configurations.c = {
                {
                    name = "Launch",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
            dap.configurations.cpp = dap.configurations.c
            dap.configurations.rust = dap.configurations.c

            -- Bash
            dap.adapters.bash = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath("data") .. "/mason/bin/bash-debug-adapter",
                    args = { "--port", "${port}" },
                },
            }
            dap.configurations.sh = {
                {
                    name = "Launch",
                    type = "bash",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to script: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                },
            }
            dap.configurations.bash = dap.configurations.sh
            dap.configurations.zsh = dap.configurations.sh

            -- C#
            dap.adapters.netcoredbg = {
                type = "server",
                host = "127.0.0.1",
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
                    args = { "--interpreter=vscode" },
                },
            }
            dap.configurations.cs = {
                {
                    name = "Launch .NET",
                    type = "netcoredbg",
                    request = "launch",
                    preLaunchTask = "build",
                    program = function()
                        return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }

            -- DAP Keymaps (in keymaps.lua)
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            -- Lua
            vim.lsp.config["lua_ls"] = {
                cmd = { "lua-language-server" },
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            }
            vim.lsp.enable("lua_ls")

            -- Inlay hint handler
            local default_inlay_hint_handler = vim.lsp.handlers["textDocument/inlayHint"]
            vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx, config)
                if err then
                    local msg = err.message or ""
                    if string.match(msg, "inlay hints failed") or err.code == -32802 or err.code == -32001 then
                        return
                    end
                end
                if default_inlay_hint_handler then
                    return default_inlay_hint_handler(err, result, ctx, config)
                end
            end

            -- C/C++
            vim.lsp.config["clangd"] = { capabilities = capabilities }

            -- C#
            vim.lsp.config["omnisharp"] = { capabilities = capabilities }

            -- HTML
            vim.lsp.config["html"] = { capabilities = capabilities }

            -- JSON
            vim.lsp.config["jsonls"] = { capabilities = capabilities }

            -- Java
            vim.lsp.config["jdtls"] = { capabilities = capabilities }

            -- LaTeX
            vim.lsp.config["texlab"] = { capabilities = capabilities }

            -- Web
            vim.lsp.config["ts_ls"] = { capabilities = capabilities }
            vim.lsp.config["eslint"] = { capabilities = capabilities }
            vim.lsp.config["tailwindcss"] = { capabilities = capabilities }
            vim.lsp.config["svelte"] = { capabilities = capabilities }

            -- Systems
            vim.lsp.config["rust_analyzer"] = { capabilities = capabilities }
            vim.lsp.config["zls"] = { capabilities = capabilities }
            vim.lsp.config["asm_lsp"] = { capabilities = capabilities }

            -- DevOps / Config
            vim.lsp.config["yamlls"] = { capabilities = capabilities }
            vim.lsp.config["docker_compose_language_service"] = { capabilities = capabilities }
            vim.lsp.config["bashls"] = { capabilities = capabilities }

            -- Other
            vim.lsp.config["pyright"] = { capabilities = capabilities }
            vim.lsp.config["nil_ls"] = { capabilities = capabilities }
            vim.lsp.config["buf_ls"] = { capabilities = capabilities }
            vim.lsp.config["cobol_ls"] = { capabilities = capabilities }
            vim.lsp.config["buf_language_server"] = { capabilities = capabilities }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "proto",
                callback = function()
                    vim.lsp.enable("buf_language_server")
                end,
            })

            vim.lsp.enable({
                "ts_ls", "eslint", "zls", "yamlls", "tailwindcss",
                "nil_ls", "buf_ls", "docker_compose_language_service",
                "cobol_ls", "svelte", "pyright", "bashls", "asm_lsp",
                "rust_analyzer",
                "clangd", "omnisharp", "html", "jsonls", "jdtls", "texlab",
            })

            -- LSP Keymaps
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
            vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
            -- <leader>rn, <leader>ca, <leader>fm in keymaps.lua
        end,
    },
}
