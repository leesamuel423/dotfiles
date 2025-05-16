local M = {
	"echasnovski/mini.nvim",
	version = "*",
}

function M.config()
	local spec_treesitter = require("mini.ai").gen_spec.treesitter

	-- Load mini.nvim modules with their default configurations

	require("mini.ai").setup()
	require("mini.pairs").setup()
	require("mini.statusline").setup()
	require("mini.surround").setup()
	require("mini.align").setup()
end

return M
