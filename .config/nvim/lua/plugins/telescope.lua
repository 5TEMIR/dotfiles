return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local builtin = require("telescope.builtin")
        local actions = require("telescope.actions")

        vim.keymap.set("n", "<leader>sf", builtin.find_files)
        vim.keymap.set("n", "<leader>sg", builtin.live_grep)
        vim.keymap.set("n", "<leader>sh", builtin.help_tags)
        vim.keymap.set("n", "<leader>b", builtin.buffers)

        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-[>"] = actions.close,
                    },
                },
                sorting_strategy = "ascending",
                layout_config = {
                    prompt_position = "top",
                }
            },
            pickers = {
                find_files = {
                    select_current = true,
                    find_command = {
                        "rg",
                        "--files", 
                        "--sort",
                        "path",
                    } 
                },
                buffers = {
                    select_current = true,
                }
            },
        })
    end,
}
