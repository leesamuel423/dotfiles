return {
	"stevearc/oil.nvim",
	lazy = false,
	opts = {
		default_file_explorer = true,
		delete_to_trash = true,
		constrain_cursor = "name",
		float = {
			max_width = 60,
			max_height = 30,
		},
		view_options = {
			show_hidden = true,
		},
		keymaps = {
			["g?"] = { "actions.show_help", mode = "n" },
			["<CR>"] = "actions.select",
			["<C-c>"] = { "actions.close", mode = "n" },
			["-"] = { "actions.parent", mode = "n" },
			["<C-s>"] = { "actions.change_sort", mode = "n" },
			["<C-.>"] = { "actions.toggle_hidden", mode = "n" },
			["g\\"] = { "actions.toggle_trash", mode = "n" },
			["<C-v>"] = {},
			["<C-h>"] = {},
			["<C-t>"] = {},
			["<C-p>"] = {},
			["<C-l>"] = {},
			["_"] = {},
			["`"] = {},
			["~"] = {},
			["gx"] = {},
		},
	},
}
