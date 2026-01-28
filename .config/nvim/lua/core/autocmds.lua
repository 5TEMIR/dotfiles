vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})


vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})


vim.api.nvim_create_autocmd("FileType", {
    pattern = {"qf", "help"},
    callback = function()
        vim.cmd("wincmd L")
        vim.cmd("vertical resize 80")
    end
})


vim.api.nvim_create_user_command("Tv", function()
    vim.cmd("vsplit")
    vim.cmd("vertical resize 73")
    vim.cmd("terminal")
    vim.cmd("startinsert")
end, {})
