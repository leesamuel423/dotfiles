local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text
local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
    group = highlight_group,
})


-- Set custom LSP hover window
autocmd({ "VimEnter", "VimResized" }, {
    desc = "Setup LSP hover window",
    callback = function()
        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor(vim.o.lines * 0.3)

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, {
                border = "rounded",
                max_width = width,
                max_height = height,
            }
        )
    end
})

-- Save manually created folds automatically
local save_folds = augroup("Persistent Folds", { clear = true })

autocmd("BufWinLeave", {
    pattern = "*",
    callback = function()
        -- Only if the buffer has a name
        if vim.fn.bufname("%") ~= "" then
            vim.cmd.mkview()
        end
    end,
    group = save_folds
})

autocmd("BufWinEnter", {
    pattern = "*",
    callback = function()
        if vim.fn.bufname("%") ~= "" then
            vim.cmd.loadview({ mods = { emsg_silent = true } })
        end
    end,
    group = save_folds
})

