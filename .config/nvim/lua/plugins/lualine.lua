return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("lualine").setup({
            theme = "tokyonight",

            options = {
                disabled_filetypes = {
                    statusline = { "neo-tree", "neo-tree-popup" },
                },
            },

            sections = {
                lualine_c = {{"filename", path = 1}},
                lualine_x = {"encoding", "filetype"},
                lualine_y = {},
            },
        })
    end
}
