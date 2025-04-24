return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				ensure_installed = {
					"c",
					"lua",
					"luadoc",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
					"sql",
					"python",
					"make",
					"javascript",
					"typescript",
					"json",
					"java",
					"go",
					"graphql",
					"css",
					"dockerfile",
					"bash",
					"html",
					"yaml",
				},
				sync_install = false,
				highlight = {
					enable = true,
					-- disable slow treesitter highlight for larger files
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							vim.notify(
								"File larger than 100KB treesitter disabled for performance",
								vim.log.levels.WARN,
								{ title = "Treesitter" }
							)
							return true
						end
					end,
				},
				indent = { enable = true },
			})
		end,
	},
}
