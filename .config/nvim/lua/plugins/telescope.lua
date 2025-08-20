return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Telescope",
	keys = {
		{ "<leader>ff", function()
			-- Close all floating windows that might be diagnostics
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" then
					local buf = vim.api.nvim_win_get_buf(win)
					local bufname = vim.api.nvim_buf_get_name(buf)
					local ft = vim.api.nvim_buf_get_option(buf, "filetype")
					-- Close if it looks like a diagnostic float
					if bufname == "" and (ft == "" or ft == "markdown") then
						pcall(vim.api.nvim_win_close, win, true)
					end
				end
			end
			vim.cmd("Telescope find_files")
		end, desc = "Find files" },
		{ "<leader>fg", function()
			-- Close all floating windows that might be diagnostics
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" then
					local buf = vim.api.nvim_win_get_buf(win)
					local bufname = vim.api.nvim_buf_get_name(buf)
					local ft = vim.api.nvim_buf_get_option(buf, "filetype")
					-- Close if it looks like a diagnostic float
					if bufname == "" and (ft == "" or ft == "markdown") then
						pcall(vim.api.nvim_win_close, win, true)
					end
				end
			end
			vim.cmd("Telescope live_grep")
		end, desc = "Live grep" },
		{ "<leader>fb", function()
			-- Close all floating windows that might be diagnostics
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" then
					local buf = vim.api.nvim_win_get_buf(win)
					local bufname = vim.api.nvim_buf_get_name(buf)
					local ft = vim.api.nvim_buf_get_option(buf, "filetype")
					-- Close if it looks like a diagnostic float
					if bufname == "" and (ft == "" or ft == "markdown") then
						pcall(vim.api.nvim_win_close, win, true)
					end
				end
			end
			vim.cmd("Telescope buffers")
		end, desc = "Buffers" },
		{ "<leader>fh", function()
			-- Close all floating windows that might be diagnostics
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" then
					local buf = vim.api.nvim_win_get_buf(win)
					local bufname = vim.api.nvim_buf_get_name(buf)
					local ft = vim.api.nvim_buf_get_option(buf, "filetype")
					-- Close if it looks like a diagnostic float
					if bufname == "" and (ft == "" or ft == "markdown") then
						pcall(vim.api.nvim_win_close, win, true)
					end
				end
			end
			vim.cmd("Telescope help_tags")
		end, desc = "Help tags" },
	},
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
				},
			},
		})
	end,
}
