---@type vim.lsp.Config
return {
	cmd = { "deno", "lsp" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
	single_file_support = false,
	init_options = {
		enable = true,
		lint = true,
		unstable = true,
		suggest = {
			imports = {
				hosts = {
					["https://deno.land"] = true,
					["https://cdn.nest.land"] = true,
					["https://crux.land"] = true,
				},
			},
		},
	},
	settings = {
		deno = {
			enable = true,
			lint = true,
			unstable = true,
			suggest = {
				completeFunctionCalls = true,
				names = true,
				paths = true,
				autoImports = true,
				imports = {
					autoDiscover = true,
					hosts = {
						["https://deno.land"] = true,
					},
				},
			},
		},
	},
}