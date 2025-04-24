return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            -- Conform will run multiple formatters sequentially
            deno = { "deno_fmt" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            sql = { "sqlfmt" },
            html = { "html_beautify" },
            go = { "gofmt", "goimports" },
            java = { "google-java-format" },
            python = { "isort", "black" },
            c = { "clang-format" },
        },
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_format = "fallback",
        },
    },
}

