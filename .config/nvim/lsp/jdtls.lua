---@type vim.lsp.Config
return {
	cmd = { "jdtls" },
	filetypes = { "java" },
	root_markers = {
		"gradlew",
		"mvnw",
		".git",
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
		".project",
	},
	single_file_support = true,
	init_options = {
		jvm_args = {},
		workspace = vim.fn.stdpath("cache") .. "/jdtls-workspace",
	},
}