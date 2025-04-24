local M = {
	"nvzone/showkeys",
}

function M.config()
	require("showkeys").setup({
		dev = true,
		maxkeys = 5,
		-- excluded_modes = { "i" },
		position = "top-right",
	})
end

return M
