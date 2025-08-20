-- This file is automatically loaded when editing Java files
local status, jdtls = pcall(require, "jdtls")
if not status then
	vim.notify("nvim-jdtls not found. Please run :Lazy sync", vim.log.levels.ERROR)
	return
end

-- Function to detect Java version for the project
local function get_java_executable()
	-- JDTLS 1.49+ requires Java 21 minimum to run, but can compile for Java 17 projects
	local java_cmd = "/opt/homebrew/opt/openjdk@21/bin/java" -- Default to Java 21 (required by JDTLS)
	
	-- For JDTLS runtime (not project compilation), we can check if user wants Java 24
	-- But note that JDTLS itself requires minimum Java 21 to run
	local root_dir = vim.fs.dirname(vim.fs.find({ ".git", "gradlew", "mvnw", "pom.xml" }, { upward = true })[1])
	if root_dir then
		local java_version_file = root_dir .. "/.jdtls-version"
		if vim.fn.filereadable(java_version_file) == 1 then
			local version = vim.fn.readfile(java_version_file)[1]
			if version then
				if version:match("24") then
					java_cmd = "/opt/homebrew/opt/openjdk/bin/java"
				elseif version:match("21") then
					java_cmd = "/opt/homebrew/opt/openjdk@21/bin/java"
				end
			end
		end
	end
	
	return java_cmd
end

-- Determine OS
local function get_os()
	local os_name = vim.loop.os_uname().sysname
	if os_name == "Darwin" then
		return "mac"
	elseif os_name == "Linux" then
		return "linux"
	elseif os_name:match("Windows") then
		return "win"
	end
	return "linux"
end

-- Setup function
local function setup_jdtls()
	local jdtls_path = "/opt/homebrew/Cellar/jdtls/1.49.0/libexec"
	local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	local config_dir = jdtls_path .. "/config_" .. get_os()
	
	-- Workspace directory - unique per project
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name
	
	-- Create workspace directory if it doesn't exist
	vim.fn.mkdir(workspace_dir, "p")
	
	local java_cmd = get_java_executable()
	
	-- Extended client capabilities
	local extendedClientCapabilities = jdtls.extendedClientCapabilities
	extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
	
	-- Configure JDTLS
	local config = {
		cmd = {
			java_cmd,
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.level=WARN",
			"-Xmx2g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens", "java.base/java.util=ALL-UNNAMED",
			"--add-opens", "java.base/java.lang=ALL-UNNAMED",
			"-jar", launcher_jar,
			"-configuration", config_dir,
			"-data", workspace_dir,
		},
		
		root_dir = vim.fs.dirname(vim.fs.find({ 
			"gradlew", 
			"mvnw", 
			".git", 
			"pom.xml", 
			"build.gradle",
			"build.gradle.kts",
			"settings.gradle",
			"settings.gradle.kts"
		}, { upward = true })[1]),
		
		settings = {
			java = {
				signatureHelp = { enabled = true },
				contentProvider = { preferred = "fernflower" },
				completion = {
					favoriteStaticMembers = {
						"org.hamcrest.MatcherAssert.assertThat",
						"org.hamcrest.Matchers.*",
						"org.hamcrest.CoreMatchers.*",
						"org.junit.jupiter.api.Assertions.*",
						"java.util.Objects.requireNonNull",
						"java.util.Objects.requireNonNullElse",
						"org.mockito.Mockito.*",
					},
					filteredTypes = {
						"com.sun.*",
						"io.micrometer.shaded.*",
						"java.awt.*",
						"jdk.*",
						"sun.*",
					},
				},
				sources = {
					organizeImports = {
						starThreshold = 9999,
						staticStarThreshold = 9999,
					},
				},
				codeGeneration = {
					toString = {
						template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
					},
					useBlocks = true,
				},
				configuration = {
					runtimes = {
						{
							name = "JavaSE-17",
							path = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
							default = true, -- Default for projects
						},
						{
							name = "JavaSE-21",
							path = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
						},
						{
							name = "JavaSE-24",
							path = "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home",
						},
					},
				},
				eclipse = {
					downloadSources = true,
				},
				maven = {
					downloadSources = true,
				},
				implementationsCodeLens = {
					enabled = true,
				},
				referencesCodeLens = {
					enabled = true,
				},
				references = {
					includeDecompiledSources = true,
				},
				inlayHints = {
					parameterNames = {
						enabled = "all",
					},
				},
			},
		},
		
		init_options = {
			bundles = {},
			extendedClientCapabilities = extendedClientCapabilities,
		},
		
		capabilities = vim.lsp.protocol.make_client_capabilities(),
		
		on_attach = function(client, bufnr)
			-- Enable completion triggered by <c-x><c-o>
			vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
			
			-- Mappings
			local opts = { buffer = bufnr, noremap = true, silent = true }
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, opts)
			
			-- Java specific mappings
			vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
			vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
			vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
			vim.keymap.set("n", "<leader>jm", jdtls.extract_method, opts)
			
			vim.notify("JDTLS attached", vim.log.levels.INFO)
		end,
	}
	
	-- Start or attach the client
	jdtls.start_or_attach(config)
end

-- Call setup when this file is loaded
setup_jdtls()