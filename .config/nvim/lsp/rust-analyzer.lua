---@type vim.lsp.Config
return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml" },
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
				allTargets = true,
				extraArgs = { "--", "-W", "clippy::all" },
			},
			cargo = {
				allFeatures = true,
				buildScripts = {
					enable = true,
				},
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
					enable = true,
				},
				chainingHints = {
					enable = true,
				},
				closingBraceHints = {
					enable = true,
					minLines = 25,
				},
				closureReturnTypeHints = {
					enable = "always",
				},
				lifetimeElisionHints = {
					enable = "always",
					useParameterNames = true,
				},
				maxLength = 25,
				parameterHints = {
					enable = true,
				},
				reborrowHints = {
					enable = "always",
				},
				renderColons = true,
				typeHints = {
					enable = true,
					hideClosureInitialization = false,
					hideNamedConstructor = false,
				},
			},
			completion = {
				callable = {
					snippets = "fill_arguments",
				},
				postfix = {
					enable = true,
				},
				privateEditable = {
					enable = true,
				},
			},
			assist = {
				importGranularity = "module",
				importPrefix = "self",
			},
		},
	},
}
