return {
	"christoomey/vim-tmux-navigator",
	vim.keymap.set("n", "C-h", ":TmuxNavigateLeft<CR>"),
	vim.keymap.set("n", "C-j", ":TmuxNavigateDown<CR>"),
	vim.keymap.set("n", "C-k", ":TmuxNavigateUp<CR>"),
	vim.keymap.set("n", "C-l", ":TmuxNavigateRight<CR>"),
	-- "alexghergh/nvim-tmux-navigation",
	-- keys = {
	-- 	{ "<C-h>", "<cmd>lua require('nvim-tmux-navigation').NvimTmuxNavigateLeft()<cr>", { silent = true } },
	-- 	{ "<C-l>", "<cmd>lua require('nvim-tmux-navigation').NvimTmuxNavigateRight()<cr>", { silent = true } },
	-- 	{ "<C-j>", "<cmd>lua require('nvim-tmux-navigation').NvimTmuxNavigateDown()<cr>", { silent = true } },
	-- 	{ "<C-k>", "<cmd>lua require('nvim-tmux-navigation').NvimTmuxNavigateUp()<cr>", { silent = true } },
	-- },
}
