local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local LAZY_PLUGIN_SPEC = {}

---Adds a plugin import specification to the global LAZY_PLUGIN_SPEC table.
---@param item string The module path of the plugin to import.
local function spec(item)
	table.insert(LAZY_PLUGIN_SPEC, { import = item })
end

spec("plugins.oil")
spec("plugins.undotree")
spec("plugins.indentline")
spec("plugins.harpoon")
spec("plugins.whichkey")
spec("plugins.telescope")
spec("plugins.nvim-jdtls")
spec("plugins.blink-cmp")

require("lazy").setup({
	spec = LAZY_PLUGIN_SPEC,
	defaults = {
		lazy = true,
		version = false,
	},
	install = {
		colorscheme = { "rose-pine", "gruvbox", "kanagawa", "default" },
	},
	checker = { enabled = true, notify = false },
	change_detection = { notify = false },
})
