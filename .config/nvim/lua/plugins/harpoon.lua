return {
	{
		"nvim-lua/plenary.nvim",
		lazy = false,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependecies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		config = function()
			local opts = { silent = true }
			local harpoon = require("harpoon")

			harpoon:setup()
			vim.keymap.set("n", "<leader>hh", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, opts)
			vim.keymap.set("n", "<leader>ha", function()
				harpoon:list():add()
			end, opts)
		end,
	},
}
