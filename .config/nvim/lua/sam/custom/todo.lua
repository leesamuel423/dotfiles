-- todo.lua - Neovim plugin for managing TODOs in a sidebar

local M = {}

-- Configuration
local config = {
	sidebar_width = 40, -- Width of the sidebar in characters
	todo_file = os.getenv("HOME") .. "/.config/nvim/todo.txt", -- File to store TODOs
	todo_marker = "TODO", -- Marker to identify TODO lines in the file
	completed_marker = "DONE", -- Marker to indicate completed TODOs
}

-- Colors for the sidebar (These will be used in highlights)
local colors = {
	uncompleted = "Normal",
	completed = "Comment",
	high_priority = "ErrorMsg",
	medium_priority = "WarningMsg",
	low_priority = "Comment",
}

-- Helper function to read TODOs from file
local function read_todos()
	local todos = {}
	local file = io.open(config.todo_file, "r")
	if file then
		for line in file:lines() do
			local todo = {
				completed = false,
				priority = "medium",
			}
			
			-- Extract task content
			local status, rest = line:match("^(%[.%]) (.+)")
			if status and rest then
				todo.status = status
				
				if status == "[x]" then
					todo.completed = true
				end
				
				-- Check for priority markers
				local priority, task = rest:match("^%[(%a+)%] (.+)")
				if priority and task then
					todo.priority = priority:lower()
					todo.task = task
				else
					todo.task = rest
				end
				
				table.insert(todos, todo)
			end
		end
		file:close()
	end
	return todos
end

-- Helper function to write TODOs to file
local function write_todos(todos)
	local file = io.open(config.todo_file, "w")
	if file then
		for _, todo in ipairs(todos) do
			local status = todo.completed and "[x]" or "[ ]"
			local priority = (todo.priority and todo.priority ~= "medium") 
				and " [" .. todo.priority .. "]" or ""
			
			local line = status .. priority .. " " .. todo.task .. "\n"
			file:write(line)
		end
		file:close()
	end
end

-- Function to toggle a TODO's completion status
local function toggle_completion(index)
	local todos = read_todos()
	if todos[index] then
		todos[index].completed = not todos[index].completed
		write_todos(todos)
		return true
	end
	return false
end

-- Function to change priority
local function cycle_priority(index)
	local priorities = {"low", "medium", "high"}
	local todos = read_todos()
	if todos[index] then
		local current_priority = todos[index].priority or "medium"
		local current_index = 1
		
		for i, p in ipairs(priorities) do
			if p == current_priority then
				current_index = i
				break
			end
		end
		
		local next_index = (current_index % #priorities) + 1
		todos[index].priority = priorities[next_index]
		write_todos(todos)
		return true
	end
	return false
end

-- Function to add a new TODO
local function add_todo(task, priority)
	local todos = read_todos()
	local new_todo = {
		task = task,
		completed = false,
		priority = priority or "medium",
	}
	table.insert(todos, new_todo)
	write_todos(todos)
end

-- Variables to track sidebar state
local sidebar_bufnr = nil
local sidebar_winnr = nil

-- Function to create the sidebar buffer if it doesn't exist
local function ensure_sidebar_buffer()
	if sidebar_bufnr and vim.api.nvim_buf_is_valid(sidebar_bufnr) then
		return sidebar_bufnr
	end
	
	sidebar_bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(sidebar_bufnr, 'buftype', 'nofile')
	vim.api.nvim_buf_set_option(sidebar_bufnr, 'bufhidden', 'hide')
	vim.api.nvim_buf_set_option(sidebar_bufnr, 'swapfile', false)
	vim.api.nvim_buf_set_option(sidebar_bufnr, 'filetype', 'todo')
	
	return sidebar_bufnr
end

-- Function to set up sidebar buffer mappings
local function setup_sidebar_mappings(bufnr)
	-- Toggle completion status with Enter
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<CR>', 
		':lua require("sam.custom.todo").toggle_task()<CR>', 
		{noremap = true, silent = true})
	
	-- Change priority with 'p' (local mapping)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'p', 
		':lua require("sam.custom.todo").change_priority()<CR>', 
		{noremap = true, silent = true, desc = "Change priority"})
	
	-- Clear completed tasks with 'C'
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'C', 
		':lua require("sam.custom.todo").clear_completed()<CR>', 
		{noremap = true, silent = true, desc = "Clear completed tasks"})
	
	-- Clear all tasks with 'D' (with confirmation)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'D', 
		':lua require("sam.custom.todo").clear_all()<CR>', 
		{noremap = true, silent = true, desc = "Clear all tasks"})
	
	-- Close with q
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', 
		':lua require("sam.custom.todo").close_sidebar()<CR>', 
		{noremap = true, silent = true})
end

-- Function to format each TODO for display
local function format_todo(todo, index)
	local status = todo.completed and "[x]" or "[ ]"
	local priority_marker = ""
	
	if todo.priority == "high" then
		priority_marker = "[HIGH] "
	elseif todo.priority == "low" then
		priority_marker = "[LOW] "
	end
	
	return string.format("%d. %s %s%s", 
		index, 
		status, 
		priority_marker, 
		todo.task)
end

-- Function to draw the TODO sidebar
local function draw_sidebar()
	local bufnr = ensure_sidebar_buffer()
	local todos = read_todos()
	local lines = {}
	
	-- Header with instructions
	table.insert(lines, "=== TODO LIST ===")
	table.insert(lines, "")
	
	-- Active todos
	local active_count = 0
	for i, todo in ipairs(todos) do
		if not todo.completed then
			active_count = active_count + 1
			table.insert(lines, format_todo(todo, i))
		end
	end
	
	if active_count == 0 then
		table.insert(lines, "No active todos!")
	end
	
	table.insert(lines, "")
	table.insert(lines, "=== COMPLETED ===")
	table.insert(lines, "")
	
	-- Completed todos
	local completed_count = 0
	for i, todo in ipairs(todos) do
		if todo.completed then
			completed_count = completed_count + 1
			table.insert(lines, format_todo(todo, i))
		end
	end
	
	if completed_count == 0 then
		table.insert(lines, "No completed todos!")
	end
	
	-- Shortcuts table at the bottom
	table.insert(lines, "")
	table.insert(lines, "=== SHORTCUTS ===")
	table.insert(lines, "")
	
	-- Local shortcuts
	table.insert(lines, "In sidebar:")
	table.insert(lines, "  <Enter> - Toggle completion")
	table.insert(lines, "  p       - Change priority")
	table.insert(lines, "  C       - Clear completed tasks")
	table.insert(lines, "  D       - Delete all tasks")
	table.insert(lines, "  q       - Close sidebar")
	table.insert(lines, "")
	
	-- Global shortcuts
	table.insert(lines, "Global:")
	table.insert(lines, "  <leader>td  - Display TODO sidebar")
	table.insert(lines, "  <leader>ta  - Add a new TODO")
	
	-- Set the buffer content
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	
	-- Set up highlights (future enhancement)
	
	return bufnr
end

-- Function to display or refresh the sidebar
local function display_todo_sidebar()
	local bufnr = draw_sidebar()
	
	-- Check if sidebar window exists and is valid
	local valid_win = false
	if sidebar_winnr then
		valid_win = vim.api.nvim_win_is_valid(sidebar_winnr)
	end
	
	if not valid_win then
		-- Create a new window
		vim.cmd("vsplit")
		sidebar_winnr = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(sidebar_winnr, bufnr)
		vim.api.nvim_win_set_width(sidebar_winnr, config.sidebar_width)
		vim.api.nvim_win_set_option(sidebar_winnr, 'number', false)
		vim.api.nvim_win_set_option(sidebar_winnr, 'relativenumber', false)
		vim.api.nvim_win_set_option(sidebar_winnr, 'cursorline', true)
		vim.api.nvim_win_set_option(sidebar_winnr, 'wrap', false)
		vim.cmd("wincmd H") -- Move to the left
	else
		-- Update existing window
		vim.api.nvim_win_set_buf(sidebar_winnr, bufnr)
	end
	
	setup_sidebar_mappings(bufnr)
end

-- Function to close the sidebar
local function close_sidebar()
	if sidebar_winnr and vim.api.nvim_win_is_valid(sidebar_winnr) then
		vim.api.nvim_win_close(sidebar_winnr, true)
		sidebar_winnr = nil
	end
end

-- Function to toggle the task under cursor
local function toggle_task()
	if sidebar_bufnr and vim.api.nvim_get_current_buf() == sidebar_bufnr then
		local cursor = vim.api.nvim_win_get_cursor(0)
		local line = vim.api.nvim_buf_get_lines(sidebar_bufnr, cursor[1]-1, cursor[1], false)[1]
		local index = line:match("^(%d+)%.")
		
		if index then
			if toggle_completion(tonumber(index)) then
				draw_sidebar()
			end
		end
	end
end

-- Function to change priority of the task under cursor
local function change_priority()
	if sidebar_bufnr and vim.api.nvim_get_current_buf() == sidebar_bufnr then
		local cursor = vim.api.nvim_win_get_cursor(0)
		local line = vim.api.nvim_buf_get_lines(sidebar_bufnr, cursor[1]-1, cursor[1], false)[1]
		local index = line:match("^(%d+)%.")
		
		if index then
			if cycle_priority(tonumber(index)) then
				draw_sidebar()
			end
		end
	end
end

-- Function to create a new todo
local function create_todo()
	local ok, task
	ok, task = pcall(function()
		return vim.fn.input("New Todo: ")
	end)
	
	if ok and task and task ~= "" then
		add_todo(task)
		display_todo_sidebar()
	end
end

-- Initialize the plugin
local function init()
	-- Create the TODO file if it doesn't exist
	local file = io.open(config.todo_file, "r")
	if not file then
		local todo_dir = vim.fn.fnamemodify(config.todo_file, ":h")
		vim.fn.mkdir(todo_dir, "p")
		file = io.open(config.todo_file, "w")
		if file then
			file:close()
		end
	else
		file:close()
	end

	-- Global keymaps
	vim.keymap.set("n", "<leader>td", display_todo_sidebar, { desc = "Display TODO sidebar" })
	vim.keymap.set("n", "<leader>ta", create_todo, { desc = "Add a new TODO" })
end

-- Function to clear completed tasks
local function clear_completed_tasks()
	local todos = read_todos()
	local new_todos = {}
	
	for _, todo in ipairs(todos) do
		if not todo.completed then
			table.insert(new_todos, todo)
		end
	end
	
	write_todos(new_todos)
	draw_sidebar()
	vim.notify("Cleared all completed tasks", vim.log.levels.INFO)
end

-- Function to clear all tasks
local function clear_all_tasks()
	local choice = vim.fn.confirm("Clear ALL tasks?", "&Yes\n&No", 2)
	if choice == 1 then
		local file = io.open(config.todo_file, "w")
		if file then
			file:close()
		end
		draw_sidebar()
		vim.notify("Cleared all tasks", vim.log.levels.INFO)
	end
end

-- Public functions
function M.load()
	init()
end

function M.toggle_task()
	toggle_task()
end

function M.change_priority()
	change_priority()
end

function M.clear_completed()
	clear_completed_tasks()
end

function M.clear_all()
	clear_all_tasks()
end

function M.close_sidebar()
	close_sidebar()
end

function M.refresh()
	if sidebar_winnr and vim.api.nvim_win_is_valid(sidebar_winnr) then
		draw_sidebar()
	end
end

return M