local modes = {
	["n"] = "NORMAL",
	["no"] = "NORMAL",
	["v"] = "VISUAL",
	["V"] = "VISUAL LINE",
	["^V"] = "VISUAL BLOCK",
	["s"] = "SELECT",
	["S"] = "SELECT LINE",
	["^S"] = "SELECT BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["R"] = "REPLACE",
	["Rv"] = "VISUAL REPLACE",
	["c"] = "COMMAND",
	["cv"] = "VIM EX",
	["ce"] = "EX",
	["r"] = "PROMPT",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

---Returns the current buffer's directory path relative to the home or current directory, formatted for statusline truncation.
---@return string The formatted directory path with a trailing slash, or an empty string if the path is empty or the current directory.
local function filepath()
	local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
	if fpath == "" or fpath == "." then
		return ""
	end

	return string.format("%%<%s/", fpath)
end

---Abbreviates a string by extracting and joining the first two lowercase letters of each word, separated by dots.
---@param name string The string to abbreviate, typically a filename or branch name.
---@return string The abbreviated form, with words split on dashes, underscores, and camel case.
local function abbreviate(name)
	local s = name:gsub("[-_]", " ")
	s = s:gsub("(%l)(%u)", "%1 %2")

	local parts = {}
	for word in s:gmatch("%S+") do
		parts[#parts + 1] = word
	end
	local letters = {}
	for _, w in ipairs(parts) do
		letters[#letters + 1] = w:sub(1, 2):lower()
	end
	return table.concat(letters, ".")
end

---Returns the current buffer's filename, abbreviating it if longer than 15 characters.
---@return string The filename, abbreviated if necessary, or an empty string if no filename is present.
local function filename()
	local fname = vim.fn.expand("%:t")
	if fname == "" then
		return ""
	end
	if fname:len() > 15 then
		return abbreviate(fname) .. "." .. (vim.fn.expand("%:e"))
	end
	return fname
end

---Returns the current buffer's filetype enclosed in square brackets.
---@return string Filetype string in the format "[filetype]".
local function filetype()
	return string.format("[%s]", vim.bo.filetype)
end

---Returns the current cursor position and file progress for the statusline, except for "alpha" filetype.
---@return string Formatted string with percentage through file and line:column, or empty string for "alpha" filetype.
local function lineinfo()
	if vim.bo.filetype == "alpha" then
		return ""
	end
	return "[%P  %l:%c]"
end

---Shortens a Git branch name if it exceeds 15 characters, preserving the prefix before a slash if present and abbreviating the remainder.
---@param branch string The Git branch name to shorten.
---@return string The original or abbreviated branch name, depending on its length.
local function shorten_branch(branch)
	if branch:len() < 15 then
		return branch
	end

	local prefix, rest = branch:match("^([^/]+)/(.+)$")
	if prefix then
		return prefix .. "/" .. abbreviate(rest)
	end

	return abbreviate(branch)
end

---Returns a formatted Git status segment for the statusline, including branch name and counts of added, changed, and removed lines if present.
---@return string Git status information with branch and change counts, or an empty string if not in a Git repository.
local function vcs()
	local git_info = vim.b.gitsigns_status_dict
	if not git_info or git_info.head == "" then
		return ""
	end
	local head = shorten_branch(git_info.head)
	local added = git_info.added and (" +" .. git_info.added) or ""
	local changed = git_info.changed and (" ~" .. git_info.changed) or ""
	local removed = git_info.removed and (" -" .. git_info.removed) or ""
	if git_info.added == 0 then
		added = ""
	end
	if git_info.changed == 0 then
		changed = ""
	end
	if git_info.removed == 0 then
		removed = ""
	end
	return table.concat({
		"[",
		"git:",
		head,
		added,
		changed,
		removed,
		"]",
	})
end

Statusline = {}

Statusline.active = function()
	return table.concat({
		"[",
		filepath(),
		filename(),
		"] ",
		vcs(),
		"%=",
		filetype(),
		" ",
		lineinfo(),
	})
end

---Returns a minimal statusline displaying only the current buffer's filename.
---@return string The inactive statusline format.
function Statusline.inactive()
	return " %t"
end

vim.api.nvim_exec(
	[[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  augroup END
]],
	false
)
