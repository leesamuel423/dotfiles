return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	version = "v0.*",
	build = "cargo build --release",

	---@module "blink-cmp"
	---@type blink.cmp.Config
	opts = {
		fuzzy = { implementation = "prefer_rust_with_warning" },
		signature = {
			enabled = true,
		},
		keymap = {
			preset = "default",
			["<C-space>"] = {},
			["<C-p>"] = {},
			["<Tab>"] = {},
			["<S-Tab>"] = {},

			-- ["<C-e>"] = { "hide" },
			["<C-d>"] = { "show", "show_documentation", "hide_documentation" },

			["<C-y>"] = { "select_and_accept" },

			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },

			["<C-j>"] = { "scroll_documentation_down", "fallback" },
			["<C-k>"] = { "scroll_documentation_up", "fallback" },
		},

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "normal",
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
		},

		cmdline = {
			sources = {},
		},
		sources = {
			default = { "lsp" },
		},
	},
}
