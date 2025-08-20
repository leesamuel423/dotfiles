-- Basic servers that work out of the box
local servers = {
	"asm_lsp",
	"clangd",
	"cmake",
	"dockerls",
	"docker_compose_language_service",
	"gopls",
	"html",
	"jdtls",
	"jsonls",
	"lua_ls",
	"marksman",
	"pyright",
	"ruff",
	"rust_analyzer",
	"sqls",
	"tailwindcss",
	"yamlls",
}

-- Configure all servers with default settings
vim.lsp.config("*", {
	root_markers = { ".git", ".gitignore" },
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Enable the servers
vim.lsp.enable(servers)

-- Conditional TypeScript/Deno/Biome setup
-- Prioritize Biome if biome.json exists, then Deno, then ts_ls
if vim.fn.findfile("biome.json", ".;") ~= "" or vim.fn.findfile("biome.jsonc", ".;") ~= "" then
	vim.lsp.enable("biome")
elseif vim.fn.findfile("deno.json", ".;") ~= "" or vim.fn.findfile("deno.jsonc", ".;") ~= "" then
	vim.lsp.enable("denols")
else
	vim.lsp.enable("ts_ls")
end

-- Diagnostic configuration
vim.diagnostic.config({
	virtual_text = false, -- Disable inline virtual text
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		source = "always", -- Show source in diagnostic float window
		border = "rounded",
		focusable = true, -- Allow focusing the float window to copy text
	},
})



