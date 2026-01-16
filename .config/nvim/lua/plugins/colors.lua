return {
    "folke/tokyonight.nvim",
    config = function()
        require("tokyonight").setup({
            transparent = false,
        })

        vim.cmd.colorscheme "tokyonight-night"

        vim.defer_fn(function()
            local Util = require("tokyonight.util")
            local colors = require("tokyonight.colors").setup({style = "night"})

            local highlights = {
                ["@keyword"]                    = { fg = colors.cyan, bold = true },
                ["@keyword.function"]           = { fg = colors.green1, bold = true },
                ["Statement"]                   = { link = "@keyword" },
                ["@variable.builtin"]           = { fg = colors.cyan },
                ["@variable.parameter"]         = { fg = colors.cyan },
                ["@variable.parameter.builtin"] = { fg = Util.blend_fg(colors.cyan, 0.8) },
                ["@keyword.import"]             = { fg = colors.red },
                ["@module"]                     = { fg = colors.blue6 },
                -- ["@module"]                     = { fg = Util.blend_fg(colors.green1, 0.8) },
                ["@lsp.type.interface"]         = { fg = Util.blend_bg(colors.blue1, 1.3) },
                -- ["@type"]                       = { link = "Type" },
                -- ["@type.builtin"]               = { fg = Util.blend_bg(colors.blue1, 0.8) },
                -- ["@type.definition"]            = { link = "Typedef" },
                -- ["@type.qualifier"]             = { link = "@keyword" },
                -- ["@type"]                       = { fg = colors.fg, bold = true },
                -- ["@type.builtin"]               = { fg = Util.blend_bg(colors.fg, 0.8), bold = true },
                -- ["@type.definition"]            = { link = "Typedef" },
                -- ["@type.qualifier"]             = { link = "@keyword" },
                -- ["@property"]                   = { fg = colors.green1 },
                -- ["@variable.member"]            = { fg = colors.green1 },
            }

            for group, hl in pairs(highlights) do
                vim.api.nvim_set_hl(0, group, hl)
            end
        end, 100)


        local inactive_tab_bg = "#181823"
        local inactive_tab_fg = "#3b4261"
        local active_tab_bg = "#1a1b26"
        local active_tab_fg = "#a9b1d6"
        local tabline_fill_bg = "#16161e"

        vim.api.nvim_set_hl(0, "TabLine", {
            bg = inactive_tab_bg,
            fg = inactive_tab_fg,
            bold = false,
            italic = false
        })

        vim.api.nvim_set_hl(0, "TabLineSel", {
            bg = active_tab_bg,
            fg = active_tab_fg,
            bold = true
        })

        vim.api.nvim_set_hl(0, "TabLineFill", {
            bg = tabline_fill_bg
        })

        function TabLine()
            local s = ''

            for index = 1, vim.fn.tabpagenr('$') do
                local winnr = vim.fn.tabpagewinnr(index)
                local buflist = vim.fn.tabpagebuflist(index)
                local bufnr = buflist[winnr]
                local bufname = vim.fn.bufname(bufnr)

                local filename = vim.fn.fnamemodify(bufname, ':t')

                if filename == '' then
                    filename = '[No Name]'
                end

                if index == vim.fn.tabpagenr() then
                    s = s .. '%#TabLineSel#'
                else
                    s = s .. '%#TabLine#'
                end

                s = s .. ' ' .. index .. ': ' .. filename .. ' '
            end

            s = s .. '%#TabLineFill#%T'
            return s
        end

        vim.o.tabline = '%!v:lua.TabLine()'
    end
}
