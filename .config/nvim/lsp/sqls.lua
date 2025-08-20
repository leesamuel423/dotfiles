---@type vim.lsp.Config
return {
	cmd = { "sqls" },
	filetypes = { "sql", "mysql" },
	root_markers = { ".git" },
	single_file_support = true,
	settings = {
		sqls = {
			connections = {},
		},
	},
}