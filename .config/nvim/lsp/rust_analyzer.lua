---@type vim.lsp.Config
return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json" },
	single_file_support = true,
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
				buildScripts = {
					enable = true,
				},
			},
			checkOnSave = {
				enable = true,
				command = "clippy",
			},
			procMacro = {
				enable = true,
			},
			diagnostics = {
				enable = true,
				experimental = {
					enable = true,
				},
			},
			inlayHints = {
				bindingModeHints = {
					enable = false,
				},
				chainingHints = {
					enable = true,
				},
				closingBraceHints = {
					enable = true,
					minLines = 25,
				},
				closureReturnTypeHints = {
					enable = "never",
				},
				lifetimeElisionHints = {
					enable = "never",
					useParameterNames = false,
				},
				maxLength = 25,
				parameterHints = {
					enable = true,
				},
				reborrowHints = {
					enable = "never",
				},
				renderColons = true,
				typeHints = {
					enable = true,
					hideClosureInitialization = false,
					hideNamedConstructor = false,
				},
			},
		},
	},
}