local M = {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
}

function M.config()
    require("oil").setup {
        float = {
            max_height = 20,
            max_width = 60,
        },
        keymaps = {
            ["<C-h>"] = false, -- Disable <C> + h
            ["<C-l>"] = false, -- Disable <C> + h
        }
    }
    vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
end

return M

