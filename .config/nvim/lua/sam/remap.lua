-- ========================================================================
-- Utility functions and settings
-- ========================================================================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

-- ========================================================================
-- Basic editor mappings
-- ========================================================================

-- Clear search highlights
map("n", "<leader>nh", ":nohl<CR>", { desc = "clear search highlights" })

-- Select all text
map("n", "<C-q>", "gg<S-v>G", opts)

-- Quickly source the current file
map("n", "<leader><leader>", function()
	vim.cmd("so")
end)
map("n", "<space><space>x", "<cmd>source %<CR>", { desc = "source current file" })
map("n", "<space>x", ":.lua <CR>", { desc = "execute current line as lua" })
map("v", "<space>x", ":.lua <CR>", { desc = "execute selected text as lua" })

-- Open file explorer (either netrw with Ex or Oil.nvim)
map("n", "<leader>pv", vim.cmd.Oil, opts, { desc = "open file explorer" })

-- Join lines but keep cursor position
map("n", "J", "mzJ`z", { desc = "join lines and keep cursor position" })

-- Improved navigation
map("n", "<C-d>", "<C-d>zz", { desc = "half-page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "half-page up and center" })
map("n", "n", "nzzzv", { desc = "next search result, centered and unfold" })
map("n", "N", "Nzzzv", { desc = "prev search result, centered and unfold" })

-- Format paragraph and keep cursor position
map("n", "=ap", "ma=ap'a", { desc = "format paragraph and keep cursor position" })

-- Escape from insert mode
map("i", "<C-c>", "<Esc>", opts, { desc = "escape from insert mode" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Tab management
map("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "open new tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "close current tab" })
map("n", "L", "<cmd>tabn<CR>", { desc = "go to next tab" })
map("n", "H", "<cmd>tabp<CR>", { desc = "go to prev tab" })

-- ========================================================================
-- Text Manipulation
-- ========================================================================

-- Move selected text up/down and reindent
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selection up" })

-- Maintain selection after indenting
map("v", ">", ">gv", opts, { desc = "indent right and keep selection" })
map("v", "<", "<gv", opts, { desc = "indent left and keep selection" })

-- Move cursor in insert mode
map("i", "<C-h>", "<Left>", opts, { desc = "cursor left in insert mode" })
map("i", "<C-l>", "<Right>", opts, { desc = "cursor right in insert mode" })

-- ========================================================================
-- Quick Actions & Plugins
-- ========================================================================

-- Quick quit
map("n", "<leader>q", "<cmd>q<CR>", { desc = "quit" })

-- Formatter
-- vim.keymap.set("n", "<leader>f", function()
--     require("conform").format({ bufnr = 0 })
-- end)

-- ========================================================================
-- LSP & Diagnostics
-- ========================================================================

-- Commented out LSP mappings
-- map("n", "grn", vim.lsp.buf.rename, { desc = "rename symbol" })
-- map("n", "gra", vim.lsp.buf.code_action, { desc = "code action" })
-- map("n", "grr", vim.lsp.buf.references, { desc = "find references" })
