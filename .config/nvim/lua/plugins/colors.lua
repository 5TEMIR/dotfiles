return {
    "folke/tokyonight.nvim",
    config = function()
        local Util = require("tokyonight.util")
        require("tokyonight").setup({
            transparent = false,
            on_colors = function(colors)
                colors.bg = "#16161e"
                colors.bg_float = Util.blend_bg(colors.bg, 1.5)
                colors.black = Util.blend_bg(colors.bg, 1.5)
                colors.bg_statusline = Util.blend_bg(colors.bg, 1.5)
            end,
            on_highlights = function(highlights, colors)

                -- More blue and cyan
                -- highlights["@keyword"]                              = { fg = colors.cyan, bold = true, italic = true }
                -- highlights["@keyword.function"]                     = { fg = colors.green1, bold = true }
                -- highlights["@keyword.import"]                       = { fg = colors.orange }
                -- highlights["Statement"]                             = { link = "@keyword" }
                -- highlights["@variable.builtin"]                     = { fg = colors.cyan }
                -- highlights["@variable.parameter"]                   = { fg = colors.cyan }
                -- highlights["@variable.parameter.builtin"]           = { fg = Util.blend_fg(colors.cyan, 0.8) }
                -- highlights["@module"]                               = { fg = Util.blend_bg(colors.yellow, 1.2) }
                -- highlights["@lsp.type.interface"]                   = { fg = Util.blend_bg(colors.blue1, 1.3) }

                -- Like default
                highlights["Function"]                              = { fg = Util.blend_bg(colors.cyan, 1.0) }
                highlights["Type"]                                  = { fg = Util.blend_bg(colors.cyan, 1.0) }
                highlights["Special"]                               = { fg = Util.blend_bg(colors.cyan, 1.0) }
                highlights["Keyword"]                              = { fg = colors.fg, bold = true, italic = true }
                highlights["@keyword"]                              = { fg = colors.fg, bold = true, italic = true }
                highlights["@keyword.function"]                     = { fg = colors.fg, bold = true, italic = true }
                highlights["@keyword.import"]                       = { fg = colors.fg, bold = true }
                highlights["@constructor"]                          = { fg = colors.fg, bold = true }
                highlights["Statement"]                             = { link = "@keyword" }
                highlights["@variable.builtin"]                     = { fg = colors.fg, bold = true }
                highlights["@variable.parameter"]                   = { fg = Util.blend_bg(colors.blue, 1.0) }
                highlights["@variable.parameter.builtin"]           = { fg = Util.blend_fg(colors.blue, 0.8) }
                highlights["@module"]                               = { fg = Util.blend_bg(colors.cyan, 1.0) }
                highlights["@type"]                                 = { fg = Util.blend_bg(colors.cyan, 1.0) }
                highlights["@type.builtin"]                         = { fg = Util.blend_bg(colors.cyan, 1.0) }
                highlights["@type.definition"]                      = { link = "Typedef" }
                highlights["@type.qualifier"]                       = { link = "@keyword" }
                highlights["@property"]                             = { fg = Util.blend_bg(colors.green1, 1.0) }
                highlights["@variable.member"]                      = { fg = Util.blend_bg(colors.green1, 1.0) }
                highlights["@lsp.type.interface"]                   = { fg = Util.blend_bg(colors.blue1, 1.0) }
                highlights["@string.documentation"]                 = { fg = colors.green }

                highlights["TabLine"]                               = { fg = colors.fg_gutter, bg = Util.blend_bg(colors.bg, 1.2) }
                highlights["TabLineSel"]                            = { fg = colors.fg, bg = colors.bg, bold = true }
                highlights["TabLineFill"]                           = { bg = colors.bg_statusline }
            end
        })

        vim.cmd.colorscheme "tokyonight-night"

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
