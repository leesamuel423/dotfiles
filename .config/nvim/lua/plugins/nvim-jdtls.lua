return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },
	lazy = true,
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	config = false, -- We'll configure it in ftplugin/java.lua
}