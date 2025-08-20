---@type vim.lsp.Config
return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
	root_markers = { ".git" },
	single_file_support = true,
	settings = {
		yaml = {
			hover = true,
			completion = true,
			validate = true,
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
					"docker-compose*.yml",
					"docker-compose*.yaml",
					"compose*.yml",
					"compose*.yaml",
				},
			},
			format = {
				enable = true,
			},
		},
	},
}