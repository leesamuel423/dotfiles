return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	-- or                              , branch = '0.1.x',
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = {
					"node_modules",
					".git/",
					"%.DS_Store",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					cwd = vim.loop.cwd(), -- This ensures it uses shell's working directory
				},
				live_grep = {
					cwd = vim.loop.cwd(), -- This ensures it uses shell's working directory
				},
			},
		})
	end,
}
