---@type vim.lsp.Config
return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"ruff.toml",
		".ruff.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		".git",
	},
	single_file_support = true,
	init_options = {
		settings = {
			lineLength = 88,
			preview = false,
		},
	},
}