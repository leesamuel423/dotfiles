---@type vim.lsp.Config
return {
	cmd = { "biome", "lsp-proxy" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"json",
		"jsonc",
		"typescript",
		"typescript.tsx",
		"typescriptreact",
		"astro",
		"svelte",
		"vue",
		"css",
	},
	root_markers = { "biome.json", "biome.jsonc", ".git" },
	single_file_support = false,
}