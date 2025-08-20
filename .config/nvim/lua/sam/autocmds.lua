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

-- Set custom LSP hover window
autocmd({ "VimEnter", "VimResized" }, {
	group = lsp_group,
	desc = "Setup LSP hover window",
	callback = function()
		local width = math.floor(vim.o.columns * 0.8)
		local height = math.floor(vim.o.lines * 0.3)

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
			max_width = width,
			max_height = height,
		})
	end,
})

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

-- Diagnostic float autocmd removed for now

-- =============================================================================
-- General Autocommands
-- =============================================================================

-- Highlight on yank and restore cursor after select-all yank
autocmd("TextYankPost", {
	group = general,
	desc = "Highlight yanked text and restore cursor after select-all",
	callback = function()
		-- Always highlight yanked text
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
		
		-- Check if entire buffer was yanked (select-all)
		local start_line = vim.fn.line("'[")
		local end_line = vim.fn.line("']")
		local last_line = vim.fn.line("$")
		
		-- If yanked from first to last line and we have a saved position
		if start_line == 1 and end_line == last_line and vim.g.saved_cursor_before_selectall then
			vim.schedule(function()
				vim.fn.setpos(".", vim.g.saved_cursor_before_selectall)
				vim.g.saved_cursor_before_selectall = nil
			end)
		end
	end,
})

-- Clean up saved position when leaving visual mode (if not from Ctrl+Q)
autocmd("ModeChanged", {
	group = general,
	desc = "Clean up saved cursor position",
	pattern = "[vV]:n",
	callback = function()
		-- Small delay to allow TextYankPost to fire first if yanking
		vim.defer_fn(function()
			-- Only clear if it wasn't a select-all operation that yanked
			if vim.g.saved_cursor_before_selectall then
				local reg_content = vim.fn.getreg('"')
				local buffer_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
				-- If the yanked content isn't the whole buffer, clear the saved position
				if reg_content ~= buffer_content then
					vim.g.saved_cursor_before_selectall = nil
				end
			end
		end, 100)
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

-- Preserve working directory when Oil is default file explorer
autocmd("VimEnter", {
	group = general,
	pattern = "*",
	callback = function()
		if vim.env.PWD then
			vim.api.nvim_set_current_dir(vim.env.PWD)
		end
	end,
})

-- =============================================================================
-- Persistent Folds
-- =============================================================================

-- Save manually created folds automatically
local save_folds = augroup("Persistent Folds", { clear = true })

autocmd("BufWinLeave", {
	group = save_folds,
	pattern = "*",
	callback = function()
		-- Only if the buffer has a name
		if vim.fn.bufname("%") ~= "" then
			vim.cmd.mkview()
		end
	end,
})

autocmd("BufWinEnter", {
	group = save_folds,
	pattern = "*",
	callback = function()
		if vim.fn.bufname("%") ~= "" then
			vim.cmd.loadview({ mods = { emsg_silent = true } })
		end
	end,
})