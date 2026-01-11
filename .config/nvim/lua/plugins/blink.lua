return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    config = function() 
        require("blink.cmp").setup({
            keymap = { 
                preset = "default",
                ["<C-space>"] = false, 
                ["<C-l>"] = { "show", "hide"},
                ["<C-e>"] = { "cancel", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            },

            completion = { 
                list = {
                    selection = { 
                        preselect = false, 
                        auto_insert = true 
                    },
                },
                documentation = { 
                    auto_show = true,
                    auto_show_delay_ms = 0,
                },
                menu = {
                    auto_show = true,
                    scrollbar = false,
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind",                       gap = 1 },
                            { "source_name",                gap = 1 },
                        },
                    },
                },
            },

            cmdline = {
                keymap = { 
                    preset = "inherit", 
                },
                completion = {
                    menu = {
                        auto_show = function(ctx)
                            return vim.fn.getcmdtype() == ":"
                        end,
                    },
                    list = {
                        selection = { 
                            preselect = false, 
                            auto_insert = true 
                        },
                    },
                },
            },

            appearance = { nerd_font_variant = "mono" },
            signature = { enabled = true },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        })
    end
}
