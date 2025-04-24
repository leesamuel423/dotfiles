-- ========================================================================
-- Appearance
-- ========================================================================
vim.opt.guicursor = "" -- Block cursor in all modes
vim.opt.nu = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.termguicolors = true -- 24-bit RGB colors
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.colorcolumn = "80" -- Visual guide at column 80
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor

-- ========================================================================
-- Indentation and Formatting
-- ========================================================================
vim.opt.tabstop = 2 -- Tab width
vim.opt.shiftwidth = 2 -- Autoindent uses 4 spaces
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.softtabstop = 2 -- Tab feels like 4 spaces when editing
vim.opt.smartindent = true -- Smart autoindenting
vim.opt.autoindent = true -- Copy indent from current line when starting a new line
vim.opt.breakindent = true -- Wrapped lines will be visually indented
vim.opt.wrap = false -- No line wrapping

-- ========================================================================
-- Search
-- ========================================================================
vim.opt.hlsearch = true -- Don't highlight all search matches
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override 'ignorecase' if search pattern contains uppercase char

-- ========================================================================
-- File Handling
-- ========================================================================
vim.opt.swapfile = false -- No swap files
vim.opt.backup = false -- No backup files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Undo directory location
vim.opt.undofile = true -- Persistent undo history
vim.opt.wildignore:append({ "*/node_modules/*" }) -- Ignore node_modules in file and directory matching
vim.opt.path:append({ "**" }) -- Search down into subfolders for file finding
vim.opt.isfname:append("@-@") -- Include @ in filenames

-- ========================================================================
-- Editing
-- ========================================================================
vim.opt.clipboard:append("unnamedplus") -- Use the system clipboard
vim.opt.backspace = "indent,eol,start" -- Allow backspacing over autoindent, line breaks, and start of insert
vim.opt.updatetime = 50 -- Faster update time (50 ms)

-- ========================================================================
-- Window Splitting
-- ========================================================================
vim.opt.splitright = true -- Put new windows right of the current one
vim.opt.splitbelow = true -- Put new windows below the current one
vim.opt.splitkeep = "cursor" -- Keep cursor in the same position when splitting

-- ========================================================================
-- Misc
-- ========================================================================
vim.opt.list = false -- Don't show hidden characters (tabs, EOL, etc.)

