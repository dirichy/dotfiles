return {
	{
		"neovim/nvim-lspconfig",
		keys = {
			{ "<leader>om", "<cmd>Mason<cr>", desc = "Open Mason(LSP install)" },
		},
		cmd = { "Mason", "Neoconf" },
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig",
			"folke/neoconf.nvim",
			"barreiroleo/ltex_extra.nvim",
			{
				"j-hui/fidget.nvim",
				tag = "v1.4.5",
			},
			"nvimdev/lspsaga.nvim",
		},
		-- config = function()
		-- 	require("mason").setup()
		-- 	require("mason-lspconfig").setup()
		-- 	-- if vim.g.ssh then
		-- 	--   require("chinese.rime").setup_rime()
		-- 	-- end
		-- end,
		config = function()
			local servers = {
				ltex = {},
				texlab = {},
				lua_ls = {},
				pyright = {},
				jsonls = {},
				marksman = {},
				volar = {},
				dockerls = {},
				docker_compose_language_service = {},
				bashls = {},
				-- ocamllsp = {},
				taplo = {},
				ruff_lsp = {},
				clangd = {},
			}
			local on_attach = function(_, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				local nmap = function(keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end

					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				nmap("K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
				nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				-- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
				nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
				nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
				nmap("<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, "[W]orkspace [L]ist Folders")
				nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
				nmap("<leader>rn", "<cmd>Lspsaga rename ++project<cr>", "[R]e[n]ame")
				nmap("<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction")
				nmap("<leader>fd", require("telescope.builtin").diagnostics, "Find Diagnostics")
				nmap("<leader>fr", require("telescope.builtin").lsp_references, "Find References")
				-- nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
			end
			require("neoconf").setup()
			require("fidget").setup({
				progress = {
					ignore = { "ltex" },
				},
			})
			require("lspsaga").setup({
				ui = {
					border = "rounded",
				},
				-- Using barbecue for this instead.
				symbol_in_winbar = {
					enable = false,
				},
				lightbulb = {
					sign = false,
				},
				outline = {
					win_width = 50,
					keys = {
						toggle_or_jump = "<cr>",
					},
				},
			})
			require("mason").setup()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			require("mason-lspconfig").setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({ on_attach = on_attach, capabilities = capabilities })
				end,
				-- Next, you can provide a dedicated handler for specific servers.
				-- For example, a handler override for the `rust_analyzer`:
				-- ["latex"] = function()
				--   require("lspconfig").latex.setup({
				--     settings={
				--       texlab={
				--       diagnostics={
				--           ignoredPatterns={
				--             ".*"
				--           },
				--           allowedPatterns={"1"}
				--         }
				--       }
				--     }
				--   })
				-- end,
				["ltex"] = function()
					require("lspconfig")["ltex"].setup({
						on_attach = function(_, bufer)
							on_attach(_, bufer)
							require("ltex_extra").setup({
								-- capabilities = capabilities,
								-- on_attach = on_attach,
								use_spellfile = false,
								filetypes = { "latex", "tex", "bib", "markdown", "gitcommit", "text" },
								settings = {
									ltex = {
										enabled = { "latex", "tex", "bib", "markdown" },
										diagnosticSeverity = "information",
										completionEnabled = true,
										checkFrequency = "edit",
										sentenceCacheSize = 2000,
										additionalRules = {
											enablePickyRules = true,
											motherTongue = "zh-CN",
										},
										["ltex-ls"] = {
											logLevel = "severe",
										},
										-- dictionary = (function()
										-- 	-- For dictionary, search for files in the runtime to have
										-- 	-- and include them as externals the format for them is
										-- 	-- dict/{LANG}.txt
										-- 	--
										-- 	-- Also add dict/default.txt to all of them
										-- 	local files = {}
										-- 	for _, file in ipairs(vim.api.nvim_get_runtime_file("dict/*", true)) do
										-- 		local lang = vim.fn.fnamemodify(file, ":t:r")
										-- 		local fullpath = vim.fs.normalize(file, ":p")
										-- 		files[lang] = { ":" .. fullpath }
										-- 	end
										--
										-- 	if files.default then
										-- 		for lang, _ in pairs(files) do
										-- 			if lang ~= "default" then
										-- 				vim.list_extend(files[lang], files.default)
										-- 			end
										-- 		end
										-- 		files.default = nil
										-- 	end
										-- 	return files
										-- end)(),
									},
								},
							})
						end,
						capabilities = capabilities,
						settings = {
							ltex = {
								enabled = { "latex", "tex", "bib", "markdown" },
								diagnosticSeverity = "information",
								completionEnabled = true,
								checkFrequency = "edit",
								sentenceCacheSize = 2000,
								additionalRules = {
									enablePickyRules = true,
									motherTongue = "zh-CN",
								},
								["ltex-ls"] = {
									logLevel = "severe",
								},
								-- dictionary = (function()
								-- 	-- For dictionary, search for files in the runtime to have
								-- 	-- and include them as externals the format for them is
								-- 	-- dict/{LANG}.txt
								-- 	--
								-- 	-- Also add dict/default.txt to all of them
								-- 	local files = {}
								-- 	for _, file in ipairs(vim.api.nvim_get_runtime_file("dict/*", true)) do
								-- 		local lang = vim.fn.fnamemodify(file, ":t:r")
								-- 		local fullpath = vim.fs.normalize(file, ":p")
								-- 		files[lang] = { ":" .. fullpath }
								-- 	end
								--
								-- 	if files.default then
								-- 		for lang, _ in pairs(files) do
								-- 			if lang ~= "default" then
								-- 				vim.list_extend(files[lang], files.default)
								-- 			end
								-- 		end
								-- 		files.default = nil
								-- 	end
								-- 	return files
								-- end)(),
							},
						},
					})
				end,
				["rust_analyzer"] = function()
					require("rust-tools").setup({ on_attach = on_attach, capabilities = capabilities })
				end,
			})
		end,
	},
	{
		"folke/lazydev.nvim",
		dependencies = {
			{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
		},
		ft = "lua",
		opts = {
			library = {
				{ path = "~/Documents/.lib/LuaTeX_Lua-API/library/", words = { "tex" } },
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				{ path = "~/.hammerspoon/Spoons/EmmyLua.spoon/annotations/", words = { "hs" } },
			},
			enabled = function(root_dir)
				return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
			end,
		},
	},
}
