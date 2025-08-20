local M = {
	"folke/which-key.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}

function M.config()
	local wk = require("which-key")

	wk.setup({
		preset = "modern",
		delay = 300,
		filter = function(mapping)
			return mapping.desc and mapping.desc ~= ""
		end,
		spec = {
			-- Normal mode mappings
			{ "<leader><leader>", desc = "Source file" },
			
			-- Find group (Telescope)
			{ "<leader>f", group = "find" },
			{ "<leader>fb", desc = "Buffers" },
			{ "<leader>ff", desc = "Find files" },
			{ "<leader>fg", desc = "Live grep" },
			{ "<leader>fh", desc = "Help tags" },
			
			-- Harpoon group
			{ "<leader>h", group = "harpoon" },
			{ "<leader>hh", desc = "Toggle harpoon menu" },
			{ "<leader>ha", desc = "Add file to harpoon" },
			
			-- Clear group
			{ "<leader>n", group = "clear" },
			{ "<leader>nh", desc = "Clear search highlights" },
			
			-- Project/files group
			{ "<leader>p", group = "project/files" },
			{ "<leader>pt", desc = "Open file explorer to root" },
			{ "<leader>pv", desc = "Open file explorer" },
			
			-- Quick actions
			{ "<leader>q", desc = "Quit" },
			{ "<leader>u", desc = "Toggle undotree" },
			
			-- Tabs group
			{ "<leader>t", group = "tabs" },
			{ "<leader>tt", desc = "New tab" },
			{ "<leader>tx", desc = "Close tab" },
			
			-- Git group (Fugitive)
			{ "<space>g", group = "git" },
			{ "<space>gs", desc = "Git status" },
			{ "<space>gd", desc = "Git diff (split)" },
			{ "<space>gp", desc = "Git push" },
			{ "<space>gl", desc = "Git log" },
			{ "<space>gb", desc = "Git blame" },
			{ "<space>gP", desc = "Git pull" },
			
			-- Space mappings
			{ "<space><space>x", desc = "Source current file" },
			{ "<space>x", desc = "Execute lua" },
			
			-- LSP group
			{ "gr", group = "lsp" },
			{ "gra", desc = "Code action" },
			{ "grn", desc = "Rename symbol" },
			{ "grr", desc = "Find references" },
			
			-- Navigation
			{ "H", desc = "Previous tab" },
			{ "L", desc = "Next tab" },
			{ "J", desc = "Join lines (keep cursor)" },
			{ "n", desc = "Next search (centered)" },
			{ "N", desc = "Previous search (centered)" },
			{ "<C-d>", desc = "Half page down (centered)" },
			{ "<C-u>", desc = "Half page up (centered)" },
			{ "<C-q>", desc = "Select all" },
			{ "=ap", desc = "Format paragraph" },
			
			-- Visual mode mappings
			{
				mode = { "v" },
				{ "<", desc = "Indent left" },
				{ "<space>x", desc = "Execute selected lua" },
				{ ">", desc = "Indent right" },
				{ "J", desc = "Move selection down" },
				{ "K", desc = "Move selection up" },
			},
		},
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
		},
		win = {
			border = "rounded",
			padding = { 2, 2, 2, 2 },
		},
		layout = {
			height = { min = 4, max = 25 },
			width = { min = 20, max = 50 },
			spacing = 3,
			align = "left",
		},
		show_help = true,
		show_keys = true,
		disable = {
			buftypes = {},
			filetypes = { "TelescopePrompt" },
		},
	})
end

return M