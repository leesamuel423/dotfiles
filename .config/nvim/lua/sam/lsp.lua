-- LSP Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { noremap = true, silent = true, buffer = event.buf }
		local keymap = vim.keymap.set

		-- Navigation
		keymap("n", "gd", vim.lsp.buf.definition, opts)
		keymap("n", "gD", vim.lsp.buf.declaration, opts)
		keymap("n", "gi", vim.lsp.buf.implementation, opts)
		keymap("n", "go", vim.lsp.buf.type_definition, opts)
		keymap("n", "gr", vim.lsp.buf.references, opts)
		keymap("n", "gs", vim.lsp.buf.signature_help, opts)
		keymap("n", "K", vim.lsp.buf.hover, opts)

		-- Rename and code action (keeping your existing mappings)
		keymap("n", "grn", vim.lsp.buf.rename, opts)
		keymap({ "n", "v" }, "gra", vim.lsp.buf.code_action, opts)
		keymap("n", "grr", vim.lsp.buf.references, opts)
		
		-- Formatting
		keymap("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)

		-- Diagnostics
		keymap("n", "[d", vim.diagnostic.goto_prev, opts)
		keymap("n", "]d", vim.diagnostic.goto_next, opts)
		keymap("n", "<leader>e", function()
			vim.diagnostic.open_float(nil, { focus = true })
		end, opts)
		keymap("n", "<leader>dc", function()
			local diag = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
			if #diag > 0 then
				local messages = {}
				for _, d in ipairs(diag) do
					-- Include source if available
					local msg = d.message
					if d.source then
						msg = string.format("[%s] %s", d.source, msg)
					end
					table.insert(messages, msg)
				end
				local text = table.concat(messages, "\n\n")
				vim.fn.setreg("+", text)
				vim.notify(string.format("Copied %d diagnostic(s) to clipboard", #diag))
			else
				vim.notify("No diagnostics on this line")
			end
		end, opts)
	end,
})

-- Basic servers that work out of the box
local servers = {
	"gopls",
}

-- Configure all servers with default settings
vim.lsp.config("*", {
	root_markers = { ".git", ".gitignore" },
})

-- Special configuration for lua_ls
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
})


-- Enable the servers
vim.lsp.enable(servers)
vim.lsp.enable("lua_ls")

-- Conditional TypeScript/Deno setup
-- Prioritize Deno if deno.json/deno.jsonc exists, otherwise use ts_ls
if vim.fn.findfile("deno.json", ".;") ~= "" or vim.fn.findfile("deno.jsonc", ".;") ~= "" then
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


