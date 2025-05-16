LAZY_PLUGIN_SPEC = {}

---Adds a plugin import specification to the global LAZY_PLUGIN_SPEC table.
---@param item string The module path of the plugin to import.
local function spec(item)
	table.insert(LAZY_PLUGIN_SPEC, { import = item })
end

spec("plugins.autopairs")
spec("plugins.cmp")
spec("plugins.conform")
spec("plugins.oil")
spec("plugins.telescope")
spec("plugins.treesitter")
spec("plugins.undotree")
spec("plugins.vim-fugitive")
spec("plugins.tsplayground")
spec("plugins.tsautotag")
spec("plugins.trouble")
spec("plugins.vim-tmux-navigator")
spec("plugins.peek")
spec("plugins.showkeys")
spec("plugins.mini")
spec("plugins.indentline")
spec("plugins.colors")
spec("plugins.todocomments")
