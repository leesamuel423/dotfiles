return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
			formatters = {
				my_rustfmt = {
					command = "cargo +nightly fmt",
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				deno = { "deno_fmt" },
				go = { "gofmt" },
				python = { "black" },
				sql = { "sql_formatter" },
				java = { "google-java-format" },
				sh = { "beautysh" },
				json = { "jq" },
				rust = { "rustfmt" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
