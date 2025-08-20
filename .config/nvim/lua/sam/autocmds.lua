-- Autocommands for Neovim configuration

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Create autocommand groups
local general = augroup("General", { clear = true })
local lsp_group = augroup("LSP", { clear = true })
local diagnostics = augroup("Diagnostics", { clear = true })

-- =============================================================================
-- LSP Autocommands
-- =============================================================================

-- LSP Keymaps and settings when LSP attaches
autocmd("LspAttach", {
	group = lsp_group,
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

		-- Rename and code action
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

-- =============================================================================
-- Diagnostic Autocommands
-- =============================================================================

-- Auto-close diagnostic float when leaving buffer
autocmd({ "BufLeave", "BufHidden", "BufUnload" }, {
	group = diagnostics,
	desc = "Close diagnostic float when leaving buffer",
	callback = function()
		local wins = vim.api.nvim_list_wins()
		for _, win in ipairs(wins) do
			local success, win_config = pcall(vim.api.nvim_win_get_config, win)
			if success and win_config.relative ~= "" then
				-- This is a floating window
				local buf = vim.api.nvim_win_get_buf(win)
				local ft = vim.api.nvim_buf_get_option(buf, "filetype")
				-- Check if it's a diagnostic float
				if ft == "" or ft == "diagnostic" or ft == "diagnostics" then
					pcall(vim.api.nvim_win_close, win, true)
				end
			end
		end
	end,
})

-- =============================================================================
-- General Autocommands
-- =============================================================================

-- Highlight on yank
autocmd("TextYankPost", {
	group = general,
	desc = "Highlight yanked text",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
	group = general,
	desc = "Remove trailing whitespace",
	pattern = "*",
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
	group = general,
	desc = "Auto-resize splits",
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Return to last edit position when opening files
autocmd("BufReadPost", {
	group = general,
	desc = "Return to last edit position",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Close certain filetypes with q
autocmd("FileType", {
	group = general,
	desc = "Close with q",
	pattern = {
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"startuptime",
		"checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Disable line numbers in terminal
autocmd("TermOpen", {
	group = general,
	desc = "Disable line numbers in terminal",
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})

-- Check if file changed outside of Neovim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = general,
	desc = "Check if file changed",
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})