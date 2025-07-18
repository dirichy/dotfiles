return {
	{ "mfussenegger/nvim-lint" },
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
		end,
	},
	{
		"neovim/nvim-lspconfig",
		keys = {
			{ "<leader>om", "<cmd>Mason<cr>", desc = "Open Mason(LSP install)" },
			{ "<leader>tc", "<cmd>LspStart ltex<cr>", desc = "Start Ltex to check document" },
			{
				"<leader>dd",
				function()
					vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
				end,
			},
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
		init = function() end,
		config = function()
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
				-- nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
				nmap("<leader>rn", "<cmd>Lspsaga rename ++project<cr>", "[R]e[n]ame")
				nmap("<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction")
				nmap("<leader>fd", require("telescope.builtin").diagnostics, "Find Diagnostics")
				nmap("<leader>fr", require("telescope.builtin").lsp_references, "Find References")
				-- nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
			end
			local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
				textDocument = {
					completion = {
						completionItem = {
							snippetSupport = true,
							commitCharactersSupport = false, -- todo:
							documentationFormat = { "markdown", "plaintext" },
							deprecatedSupport = true,
							preselectSupport = false, -- todo:
							tagSupport = { valueSet = { 1 } }, -- deprecated
							insertReplaceSupport = true, -- todo:
							resolveSupport = {
								properties = {
									"documentation",
									"detail",
									"additionalTextEdits",
									"command",
									"data",
									-- todo: support more properties? should test if it improves latency
								},
							},
							insertTextModeSupport = {
								-- todo: support adjustIndentation
								valueSet = { 1 }, -- asIs
							},
							labelDetailsSupport = true,
						},
						completionList = {
							itemDefaults = {
								"commitCharacters",
								"editRange",
								"insertTextFormat",
								"insertTextMode",
								"data",
							},
						},

						contextSupport = true,
						insertTextMode = 1, -- asIs
					},
				},
			})
			-- local function my_root_dir(buffer, callback)
			-- 	local fname = vim.api.nvim_buf_get_name(buffer)
			-- 	local dir
			-- 	local dotfile_roots = {
			-- 		"~/dotfiles/hammerspoon/.hammerspoon",
			-- 		"~/dotfiles/karabiner/.config/karabiner",
			-- 		"~/dotfiles/lsd/.config/lsd",
			-- 		"~/dotfiles/nvim/.config/nvim",
			-- 		"~/dotfiles/zathura/.config/zathura",
			-- 		"~/dotfiles/zsh/.config/zsh",
			-- 	}
			-- 	local parent = vim.fn.fnamemodify(fname, ":h")
			-- 	if vim.startswith(parent, vim.fn.expand("~/dotfiles/")) then
			-- 		for _, root_dir in ipairs(dotfile_roots) do
			-- 			if vim.startswith(parent, vim.fn.expand(root_dir)) then
			-- 				dir = dir or root_dir
			-- 			end
			-- 		end
			-- 		dir = dir or vim.fn.getcwd()
			-- 	end
			-- 	dir = dir or vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
			-- 	callback(dir)
			-- end
			vim.lsp.config("*", { on_attach = on_attach, capabilities = capabilities })
			-- for _, server in ipairs({ "lua_ls", "texlab", "bashls" }) do
			-- 	vim.lsp.config(server, {
			-- 		on_attach = on_attach,
			-- 		capabilities = capabilities,
			-- 		root_dir = my_root_dir,
			-- 	})
			-- 	vim.lsp.enable(server)
			-- end
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
				taplo = {},
				clangd = {},
			}
			if vim.uv.os_uname().release:match("android") then
				servers.texlab = nil
				servers.clangd = nil
				servers.lua_ls = nil
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
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				autostart = true,
			})
			-- require("mason-lspconfig").setup_handlers({
			-- 	-- The first entry (without a key) will be the default handler
			-- 	-- and will be called for each installed server that doesn't have
			-- 	-- a dedicated handler.
			-- 	function(server_name) -- default handler (optional)
			-- 		require("lspconfig")[server_name].setup({
			-- 			on_attach = on_attach,
			-- 			capabilities = capabilities,
			-- 			root_dir = root_dir,
			-- 		})
			-- 	end,
			-- 	-- Next, you can provide a dedicated handler for specific servers.
			-- 	-- For example, a handler override for the `rust_analyzer`:
			-- 	-- ["latex"] = function()
			-- 	--   require("lspconfig").latex.setup({
			-- 	--     settings={
			-- 	--       texlab={
			-- 	--       diagnostics={
			-- 	--           ignoredPatterns={
			-- 	--             ".*"
			-- 	--           },
			-- 	--           allowedPatterns={"1"}
			-- 	--         }
			-- 	--       }
			-- 	--     }
			-- 	--   })
			-- 	-- end,
			-- 	["ltex"] = function()
			-- 		require("lspconfig")["ltex"].setup({
			-- 			filetypes = { "tex", "latex", "md", "markdown" },
			-- 			root_dir = root_dir,
			-- 			autostart = false,
			-- 			on_attach = function(_, bufer)
			-- 				on_attach(_, bufer)
			-- 				require("ltex_extra").setup({
			-- 					-- capabilities = capabilities,
			-- 					-- on_attach = on_attach,
			-- 					use_spellfile = false,
			-- 					filetypes = { "latex", "tex", "bib", "markdown", "gitcommit", "text" },
			-- 					settings = {
			-- 						ltex = {
			-- 							enabled = { "latex", "tex", "bib", "markdown" },
			-- 							diagnosticSeverity = "information",
			-- 							completionEnabled = true,
			-- 							checkFrequency = "edit",
			-- 							sentenceCacheSize = 2000,
			-- 							additionalRules = {
			-- 								enablePickyRules = true,
			-- 								motherTongue = "zh-CN",
			-- 							},
			-- 							["ltex-ls"] = {
			-- 								logLevel = "severe",
			-- 							},
			-- 							-- dictionary = (function()
			-- 							-- 	-- For dictionary, search for files in the runtime to have
			-- 							-- 	-- and include them as externals the format for them is
			-- 							-- 	-- dict/{LANG}.txt
			-- 							-- 	--
			-- 							-- 	-- Also add dict/default.txt to all of them
			-- 							-- 	local files = {}
			-- 							-- 	for _, file in ipairs(vim.api.nvim_get_runtime_file("dict/*", true)) do
			-- 							-- 		local lang = vim.fn.fnamemodify(file, ":t:r")
			-- 							-- 		local fullpath = vim.fs.normalize(file, ":p")
			-- 							-- 		files[lang] = { ":" .. fullpath }
			-- 							-- 	end
			-- 							--
			-- 							-- 	if files.default then
			-- 							-- 		for lang, _ in pairs(files) do
			-- 							-- 			if lang ~= "default" then
			-- 							-- 				vim.list_extend(files[lang], files.default)
			-- 							-- 			end
			-- 							-- 		end
			-- 							-- 		files.default = nil
			-- 							-- 	end
			-- 							-- 	return files
			-- 							-- end)(),
			-- 						},
			-- 					},
			-- 				})
			-- 			end,
			-- 			capabilities = capabilities,
			-- 			settings = {
			-- 				ltex = {
			-- 					enabled = { "latex", "tex", "bib", "markdown" },
			-- 					diagnosticSeverity = "information",
			-- 					completionEnabled = true,
			-- 					checkFrequency = "edit",
			-- 					sentenceCacheSize = 2000,
			-- 					additionalRules = {
			-- 						enablePickyRules = true,
			-- 						motherTongue = "zh-CN",
			-- 					},
			-- 					["ltex-ls"] = {
			-- 						logLevel = "severe",
			-- 					},
			-- 					-- dictionary = (function()
			-- 					-- 	-- For dictionary, search for files in the runtime to have
			-- 					-- 	-- and include them as externals the format for them is
			-- 					-- 	-- dict/{LANG}.txt
			-- 					-- 	--
			-- 					-- 	-- Also add dict/default.txt to all of them
			-- 					-- 	local files = {}
			-- 					-- 	for _, file in ipairs(vim.api.nvim_get_runtime_file("dict/*", true)) do
			-- 					-- 		local lang = vim.fn.fnamemodify(file, ":t:r")
			-- 					-- 		local fullpath = vim.fs.normalize(file, ":p")
			-- 					-- 		files[lang] = { ":" .. fullpath }
			-- 					-- 	end
			-- 					--
			-- 					-- 	if files.default then
			-- 					-- 		for lang, _ in pairs(files) do
			-- 					-- 			if lang ~= "default" then
			-- 					-- 				vim.list_extend(files[lang], files.default)
			-- 					-- 			end
			-- 					-- 		end
			-- 					-- 		files.default = nil
			-- 					-- 	end
			-- 					-- 	return files
			-- 					-- end)(),
			-- 				},
			-- 			},
			-- 		})
			-- 	end,
			-- 	["rust_analyzer"] = function()
			-- 		require("rust-tools").setup({ on_attach = on_attach, capabilities = capabilities })
			-- 	end,
			-- })
		end,
	},
	{
		"folke/lazydev.nvim",
		dependencies = {
			{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
		},
		ft = "lua",
		priority = 1000,
		opts = {
			library = {
				"~/.luarocks/lib/lua/5.1/",
				"/opt/homebrew/lib/lua/5.4/",
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
