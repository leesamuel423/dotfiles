return {
	cmd = { "deno", "lsp" },
	cmd_env = { NO_COLOR = true },
	root_markers = { "deno.json", "deno.jsonc" },
	workspace_required = true,
}
