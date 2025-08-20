-- DISABLED: Using nvim-jdtls plugin instead (see ftplugin/java.lua)
-- This configuration is kept for reference but not used
---@type vim.lsp.Config
return nil

--[[
return {
	cmd = {
		"/opt/homebrew/opt/openjdk@17/bin/java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.level=WARN",
		"-Xmx2g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens", "java.base/java.util=ALL-UNNAMED",
		"--add-opens", "java.base/java.lang=ALL-UNNAMED",
		"-jar", "/opt/homebrew/Cellar/jdtls/1.49.0/libexec/plugins/org.eclipse.equinox.launcher_1.7.0.v20250519-0528.jar",
		"-configuration", "/opt/homebrew/Cellar/jdtls/1.49.0/libexec/config_mac",
		"-data", vim.fn.stdpath("cache") .. "/jdtls-workspace",
	},
	filetypes = { "java" },
	root_markers = {
		"gradlew",
		"mvnw",
		".git",
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
		"settings.gradle",
		"settings.gradle.kts",
		".project",
		".classpath",
	},
	single_file_support = true,
	init_options = {
		jvm_args = {},
		workspace = vim.fn.stdpath("cache") .. "/jdtls-workspace",
		extendedClientCapabilities = {
			progressReportProvider = true,
			classFileContentsSupport = true,
			generateToStringPromptSupport = true,
			hashCodeEqualsPromptSupport = true,
			advancedExtractRefactoringSupport = true,
			advancedOrganizeImportsSupport = true,
			generateConstructorsPromptSupport = true,
			generateDelegateMethodsPromptSupport = true,
			moveRefactoringSupport = true,
			overrideMethodsPromptSupport = true,
			inferSelectionSupport = { "extractMethod", "extractVariable", "extractConstant" },
			resolveAdditionalTextEditsSupport = true,
		},
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
					importOrder = {
						"java",
						"javax",
						"com",
						"org",
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
							path = "/opt/homebrew/opt/openjdk@17",
							default = true,
						},
						{
							name = "JavaSE-21",
							path = "/opt/homebrew/opt/openjdk@21",
						},
						{
							name = "JavaSE-24",
							path = "/opt/homebrew/opt/openjdk",
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
				format = {
					enabled = true,
					settings = {
						url = vim.fn.stdpath("config") .. "/lsp/eclipse-java-google-style.xml",
						profile = "GoogleStyle",
					},
				},
			},
		},
		bundles = {},
	},
	capabilities = {
		workspace = {
			configuration = true,
		},
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = true,
				},
			},
		},
	},
	handlers = {
		["language/status"] = function() end,
		["$/progress"] = function() end,
	},
}
--]]