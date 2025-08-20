---@type vim.lsp.Config
return {
	cmd = { "asm-lsp" },
	filetypes = { "asm", "vmasm", "nasm", "gas", "s", "S" },
	root_markers = { ".git" },
	single_file_support = true,
}