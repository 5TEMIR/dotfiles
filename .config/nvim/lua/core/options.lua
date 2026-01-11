-- vim.cmd("let g:netrw_banner = 0")

vim.g.have_nerd_font = true

vim.opt.guicursor = ""
vim.opt.termguicolors = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.opt.clipboard:append("unnamedplus")
vim.opt.mouse = "a"
vim.opt.showmode = false

vim.opt.winborder = "rounded"
vim.opt.splitright = true

if vim.o.langmap == "" then
    vim.opt.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        .. ",фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
        .. ",ё`,Ё~,х[,Х{,ъ],Ъ},ж\\;,Ж:,э',Э\",Б<,Ю>"
end
