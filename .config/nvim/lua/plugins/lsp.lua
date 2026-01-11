return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "saghen/blink.cmp",
    },
    config = function()

        vim.keymap.del("n", "grn")
        vim.keymap.del("n", "gra")
        vim.keymap.del("n", "grr")
        vim.keymap.del("n", "gri")
        vim.keymap.del("n", "grt")

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(args)

                local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
                if not client then return end

                local builtin = require("telescope.builtin")
                local opts = { buffer = args.buf, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "<leader>si", builtin.lsp_implementations, opts)
                vim.keymap.set("n", "<leader>sd", builtin.lsp_document_symbols, opts)

                if client:supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("UserLspConfig", {clear=false}),
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                        end,
                    })
                end

            end,
        })


        local capabilities = require("blink.cmp").get_lsp_capabilities()

        vim.diagnostic.config({
            virtual_text = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        vim.lsp.config("rust_analyzer", {
            capabilities = capabilities,
            settings = {
                ["rust-analyzer"] = {
                    cargo = { allFeatures = true },
                    checkOnSave = true,
                    check = {
                        command = "clippy"
                    }
                },
            },
        })
        vim.lsp.enable("rust_analyzer")


        vim.lsp.config("ruff", {
            capabilities = capabilities,
            on_attach = function (client, _)
                client.server_capabilities.hoverProvider = false
            end,
            init_options = {
                settings = {
                    lint = { enable = true },
                    organizeImports = true,
                    showSyntaxErrors = true,
                    codeAction = {
                        disableRuleComment = { enable = false },
                        fixViolation = { enable = false },
                        lint = { enable = true },
                    },
                },
            },
        }
        )
        vim.lsp.enable("ruff")

        vim.lsp.config("basedpyright", {
            capabilities = capabilities,
            on_attach = function (client, _)
                client.server_capabilities.completionProvider        = false -- use pyrefly for fast response
                client.server_capabilities.definitionProvider        = false -- use pyrefly for fast response
                client.server_capabilities.documentHighlightProvider = false -- use pyrefly for fast response
                client.server_capabilities.renameProvider            = false -- use pyrefly as I think it is stable
                -- client.server_capabilities.semanticTokensProvider    = true -- use pyrefly it is more rich
            end,
            settings = { -- see https://docs.basedpyright.com/latest/configuration/language-server-settings/
                basedpyright = {
                    disableOrganizeImports = true,
                    analysis = {
                        typeCheckingMode = "off",
                        autoImportCompletions = true,
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly",
                        -- diagnosticSeverityOverrides = {
                        --     reportUnknownMemberType = "none",
                        --     reportUnknownParameterType = "none",
                        --     reportMissingParameterType = "none",
                        --     reportUnannotatedClassAttribute = "none",
                        --     reportAttributeAccessIssue = "none",
                        --     reportUnknownVariableType = "none",
                        --     reportUnknownArgumentType = "none",
                        --     reportUnknownVariableType = "none",
                        --     reportArgumentType = "none",
                        -- }
                    }
                },
            },
        })
        -- vim.lsp.enable("basedpyright")

        vim.lsp.config("pyrefly", {
            capabilities = capabilities,
            on_attach = function (client, _)
                -- client.server_capabilities.semanticTokensProvider    = false
                -- client.server_capabilities.codeActionProvider     = false
                -- client.server_capabilities.documentSymbolProvider = false
                -- client.server_capabilities.hoverProvider          = false
                -- client.server_capabilities.inlayHintProvider      = false
                -- client.server_capabilities.referenceProvider      = false
                -- client.server_capabilities.signatureHelpProvider  = false
            end,
            settings = {
            },
        })
        vim.lsp.enable("pyrefly")

    end
}
