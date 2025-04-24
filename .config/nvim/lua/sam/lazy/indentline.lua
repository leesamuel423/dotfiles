local M = {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
}

function M.config()
    local hooks = require "ibl.hooks"

    -- Create highlight groups
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IBLWhitespace", { fg = "#3c3836" })
        vim.api.nvim_set_hl(0, "IBLIndent", { fg = "#3c3836" })
    end)

    require("ibl").setup {
        indent = {
            highlight = "IBLIndent",
        },
        whitespace = {
            highlight = "IBLWhitespace",
            remove_blankline_trail = true,
        },
        scope = { enabled = false },
        exclude = {
            filetypes = {
                "help",
                "startify",
                "lazy",
                "neogitstatus",
                "NvimTree",
                "Trouble",
                "text",
            },
            buftypes = { "terminal", "nofile" },
        },
    }
end

return M


