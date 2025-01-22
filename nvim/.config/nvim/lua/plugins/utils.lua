return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		keys = {
			{
				"<leader>og",
				function()
					require("snacks").lazygit()
				end,
				desc = "Open LazyGit",
			},
			{
				"<leader>th",
				function()
					require("snacks").notifier.show_history()
				end,
				desc = "Notify History",
			},
			{
				"<leader>ps",
				function()
					Snacks.profiler.scratch()
				end,
				desc = "Profiler Scratch Bufer",
			},
		},
		config = function()
			local Snacks = require("snacks")
			Snacks.setup({
				dashboard = {
					width = 60,
					row = nil, -- dashboard position. nil for center
					col = nil, -- dashboard position. nil for center
					pane_gap = 4, -- empty columns between vertical panes
					autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
					-- These settings are used by some built-in sections
					preset = {
						-- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
						---@type fun(cmd:string, opts:table)|nil
						pick = nil,
						-- Used by the `keys` section to show keymaps.
						-- Set your custom keymaps here.
						-- When using a function, the `items` argument are the default keymaps.
						---@type snacks.dashboard.Item[]
						keys = {

							{
								icon = " ",
								key = "f",
								desc = "Find File",
								action = ":lua Snacks.dashboard.pick('files')",
							},
							{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
							{
								icon = " ",
								key = "g",
								desc = "Find Text",
								action = ":lua Snacks.dashboard.pick('live_grep')",
							},
							{
								icon = " ",
								key = "r",
								desc = "Recent Files",
								action = ":lua Snacks.dashboard.pick('oldfiles')",
							},
							{
								icon = " ",
								key = "c",
								desc = "Config",
								action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
							},
							{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
							{ action = ":Leet", desc = "Leet Code", icon = "󰪚", key = "e" },
							{
								icon = "󰒲 ",
								key = "l",
								desc = "Lazy",
								action = ":Lazy",
								enabled = package.loaded.lazy ~= nil,
							},
							{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
						},
						-- Used by the `header` section
						header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
					},
					-- item field formatters
					formats = {
						icon = function(item)
							if item.file and item.icon == "file" then
								local filename = item.file:gsub(".*/([^/]*)", "%1")
								local icon, hl = require("nvim-web-devicons").get_icon(filename)
								return { icon, width = 2, hl = hl }
							elseif item.icon == "directory" then
								return { " ", width = 2, hl = "Directory" }
							end
							return { item.icon, width = 2, hl = "icon" }
						end,
						footer = { "%s", align = "center" },
						header = { "%s", align = "center" },
						file = function(item, ctx)
							local fname = vim.fn.fnamemodify(item.file, ":~")
							fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
							if #fname > ctx.width then
								local dir = vim.fn.fnamemodify(fname, ":h")
								local file = vim.fn.fnamemodify(fname, ":t")
								if dir and file then
									file = file:sub(-(ctx.width - #dir - 2))
									fname = dir .. "/…" .. file
								end
							end
							local dir, file = fname:match("^(.*)/(.+)$")
							return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } }
								or { { fname, hl = "file" } }
						end,
					},
					sections = {
						{ section = "header" },
						{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
						{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
						{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
						{ section = "startup" },
					},
				},
				bigfile = {
					enabled = true,
					notify = true, -- show notification when big file detected
					size = 1.5 * 1024 * 1024, -- 1.5MB
					-- Enable or disable features when big file detected
					---@param ctx {buf: number, ft:string}
					setup = function(ctx)
						vim.g.latex_concealer_disabled = true
						vim.cmd([[NoMatchParen]])
						require("snacks").util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
						vim.b.minianimate_disable = true
						vim.schedule(function()
							vim.bo[ctx.buf].syntax = ctx.ft
						end)
					end,
				},
				notifier = { enabled = true },
				quickfile = { enabled = true, exclude = { "latex", "tex" } },
				statuscolumn = { enabled = true },
				words = { enabled = true },
				blame_line = {
					enabled = true,
					width = 0.6,
					height = 0.6,
					border = "rounded",
					title = " Git Blame ",
					title_pos = "center",
					ft = "git",
				},
				---@class snacks.indent.Config
				---@field enabled? boolean
				indent = {
					indent = {
						priority = 1,
						enabled = true, -- enable indent guides
						char = "│",
						only_scope = false, -- only show indent guides of the scope
						only_current = false, -- only show indent guides in the current window
						-- can be a list of hl groups to cycle through
						hl = {
							"SnacksIndent1",
							"SnacksIndent2",
							"SnacksIndent3",
							"SnacksIndent4",
							"SnacksIndent5",
							"SnacksIndent6",
							"SnacksIndent7",
							"SnacksIndent8",
						},
					},
					-- animate scopes. Enabled by default for Neovim >= 0.10
					-- Works on older versions but has to trigger redraws during animation.
					---@class snacks.indent.animate: snacks.animate.Config
					---@field enabled? boolean
					--- * out: animate outwards from the cursor
					--- * up: animate upwards from the cursor
					--- * down: animate downwards from the cursor
					--- * up_down: animate up or down based on the cursor position
					---@field style? "out"|"up_down"|"down"|"up"
					animate = {
						enabled = vim.fn.has("nvim-0.10") == 1,
						style = "out",
						easing = "linear",
						duration = {
							step = 20, -- ms per step
							total = 500, -- maximum duration
						},
					},
					scope = {
						enabled = true, -- enable highlighting the current scope
						priority = 200,
						char = "│",
						underline = false, -- underline the start of the scope
						only_current = false, -- only show scope in the current window
						hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
					},
					chunk = {
						-- when enabled, scopes will be rendered as chunks, except for the
						-- top-level scope which will be rendered as a scope.
						enabled = false,
						-- only show chunk scopes in the current window
						only_current = false,
						priority = 200,
						hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
						char = {
							corner_top = "┌",
							corner_bottom = "└",
							-- corner_top = "╭",
							-- corner_bottom = "╰",
							horizontal = "─",
							vertical = "│",
							arrow = ">",
						},
					},
					-- filter for buffers to enable indent guides
					filter = function(buf)
						return vim.g.snacks_indent ~= false
							and vim.b[buf].snacks_indent ~= false
							and vim.bo[buf].buftype == ""
					end,
				},
				input = {},
				styles = {
					input = {
						backdrop = false,
						position = "float",
						border = "rounded",
						title_pos = "center",
						height = 1,
						width = 60,
						relative = "editor",
						noautocmd = true,
						row = 2,
						-- relative = "cursor",
						-- row = -3,
						-- col = 0,
						wo = {
							winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
							cursorline = false,
						},
						bo = {
							filetype = "snacks_input",
							buftype = "prompt",
						},
						--- buffer local variables
						b = {
							completion = false, -- disable blink completions in input
						},
						keys = {
							n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
							i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
							i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = "i", expr = true },
							i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
							i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
							i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
							i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
							q = "cancel",
						},
					},
				},
				scroll = {
					animate = {
						duration = { step = 15, total = 250 },
						easing = "linear",
					},
					-- faster animation when repeating scroll after delay
					animate_repeat = {
						delay = 100, -- delay in ms before using the repeat animation
						duration = { step = 5, total = 50 },
						easing = "linear",
					},
					-- what buffers to animate
					filter = function(buf)
						return vim.g.snacks_scroll ~= false
							and vim.b[buf].snacks_scroll ~= false
							and vim.bo[buf].buftype ~= "terminal"
					end,
				},
			})
			Snacks.toggle.profiler():map("<leader>pp")
			-- Toggle the profiler highlights
			Snacks.toggle.profiler_highlights():map("<leader>ph")
		end,
	},
	-- 	{
	-- 		"nvimdev/dashboard-nvim",
	-- 		lazy = #vim.fn.argv() > 0, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
	-- 		cmd = "Dashboard",
	-- 		opts = function()
	-- 			local logo = [[
	-- ██╗      █████╗ ████████╗███████╗██╗  ██╗
	-- ██║     ██╔══██╗╚══██╔══╝██╔════╝╚██╗██╔╝
	-- ██║     ███████║   ██║   █████╗   ╚███╔╝
	-- ██║     ██╔══██║   ██║   ██╔══╝   ██╔██╗
	-- ███████╗██║  ██║   ██║   ███████╗██╔╝ ██╗
	-- ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
	-- ]]
	-- 			--         [[
	-- 			--    _         _       _____  U _____ u __  __  U _____ u ____              _____   U  ___ u   ____
	-- 			--   |"|    U  /"\  u  |_ " _| \| ___"|/ \ \/"/  \| ___"|/|  _"\    ___     |_ " _|   \/"_ \/U |  _"\ u
	-- 			-- U | | u   \/ _ \/     | |    |  _|"   /\  /\   |  _|" /| | | |  |_"_|      | |     | | | | \| |_) |/
	-- 			--  \| |/__  / ___ \    /| |\   | |___  U /  \ u  | |___ U| |_| |\  | |      /| |\.-,_| |_| |  |  _ <
	-- 			--   |_____|/_/   \_\  u |_|U   |_____|  /_/\_\   |_____| |____/ uU/| |\u   u |_|U \_)-\___/   |_| \_\
	-- 			--   //  \\  \\    >>  _// \\_  <<   >>,-,>> \\_  <<   >>  |||_.-,_|___|_,-._// \\_     \\     //   \\_
	-- 			--  (_")("_)(__)  (__)(__) (__)(__) (__)\_)  (__)(__) (__)(__)_)\_)-' '-(_/(__) (__)   (__)   (__)  (__)
	-- 			-- ]]
	--
	-- 			-- logo = string.rep("\n", 8) .. logo .. "\n\n"
	--
	-- 			-- vim.g.dashboard_preview_command = 'cat'
	-- 			-- vim.g.dashboard_preview_pipeline = 'lolcat'
	-- 			-- vim.g.dashboard_preview_file = path to logo file like
	-- 			-- ~/.config/nvim/neovim.cat
	-- 			-- vim.g.dashboard_preview_file_height = 12
	-- 			-- vim.g.dashboard_preview_file_width = 80
	-- 			local opts = {
	-- 				theme = "doom",
	-- 				disable_move = true,
	-- 				hide = {
	-- 					-- this is taken care of by lualine
	-- 					-- enabling this messes up the actual laststatus setting after loading a file
	-- 					statusline = false,
	-- 				},
	-- 				-- preview = {
	-- 				-- 	command = "lolcat",
	-- 				-- 	file_path = "~/.config/nvim/resources/dashboard.txt",
	-- 				-- 	file_height = 8,
	-- 				-- 	file_width = 51,
	-- 				-- },
	-- 				config = {
	-- 					disable_move = true,
	-- 					week_header = {
	-- 						enable = true,
	-- 					},
	-- 					-- header = vim.split(logo, "\n"),
	-- 					center = {
	-- 						{
	-- 							action = 'lua require("telescope.builtin").find_files()',
	-- 							desc = " Find File",
	-- 							icon = " ",
	-- 							key = "f",
	-- 						},
	-- 						{ action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
	-- 						{
	-- 							action = 'lua require("telescope.builtin").oldfiles()',
	-- 							desc = " Recent Files",
	-- 							icon = " ",
	-- 							key = "r",
	-- 						},
	-- 						{
	-- 							action = 'lua require("telescope.builtin").live_grep()',
	-- 							desc = " Live Grip",
	-- 							icon = " ",
	-- 							key = "g",
	-- 						},
	-- 						{
	-- 							action = 'lua require("telescope.builtin").find_files({cwd="~/.config/nvim"})',
	-- 							desc = " Config",
	-- 							icon = " ",
	-- 							key = "c",
	-- 						},
	-- 						{
	-- 							action = 'lua require("persistence").load()',
	-- 							desc = " Restore Session",
	-- 							icon = " ",
	-- 							key = "s",
	-- 						},
	-- 						{ action = "Leet", desc = " Leet Code", icon = "󰪚 ", key = "e" },
	-- 						-- { action = "LazyExtras", desc = " Lazy Extras", icon = " ", key = "x" },
	-- 						{ action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
	-- 						{ action = "qa", desc = " Quit", icon = " ", key = "q" },
	-- 					},
	-- 					footer = function()
	-- 						local stats = require("lazy").stats()
	-- 						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
	-- 						return {
	-- 							"⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
	-- 						}
	-- 					end,
	-- 				},
	-- 			}
	--
	-- 			for _, button in ipairs(opts.config.center) do
	-- 				button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
	-- 				button.key_format = "  %s"
	-- 			end
	--
	-- 			-- open dashboard after closing lazy
	-- 			if vim.o.filetype == "lazy" then
	-- 				vim.api.nvim_create_autocmd("WinClosed", {
	-- 					pattern = tostring(vim.api.nvim_get_current_win()),
	-- 					once = true,
	-- 					callback = function()
	-- 						vim.schedule(function()
	-- 							vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
	-- 						end)
	-- 					end,
	-- 				})
	-- 			end
	-- 			return opts
	-- 		end,
	-- 	},
	{
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		lazy = true,
		config = function()
			require("nvim-web-devicons").setup({
				override_by_extension = {
					["neo-tree"] = {
						icon = "󱏒",
						color = "#bd19e6",
						name = "Neo-tree",
					},
					["log"] = {
						icon = "",
						color = "#81e043",
						name = "log",
					},
					["sty"] = {
						icon = "",
						color = "#006400",
						name = "sty",
					},
					["m"] = {
						icon = "ℳ",
						color = "#ff8000",
						name = "Matlab",
					},
					["fig"] = {
						icon = "",
						color = "#ff8000",
						name = "MatlabFig",
					},
					["aux"] = {
						icon = "",
						color = "#006400",
						name = "aux",
					},
					["norg"] = {
						icon = "",
						color = "#b34fee",
						name = "norg",
					},
					["lazy"] = {
						icon = "󰒲",
						color = "#0d69f2",
						name = "Lazy",
					},
					["tex"] = {
						icon = "",
						color = "#2c8217",
						name = "TeX",
					},
				},
			})
			require("nvim-web-devicons").set_icon_by_filetype({ ["neo-tree"] = "neo-tree", lazy = "lazy" })
		end,
	},
	{
		"monaqa/dial.nvim",
		keys = {
			{ "<c-a>", "<Plug>(dial-increment)" },
			{ "<c-x>", "<Plug>(dial-decrement)" },
		},
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal_int,
					augend.integer.alias.hex,
					augend.integer.alias.octal,
					augend.integer.alias.binary,
					augend.date.alias["%Y/%m/%d"],
					augend.date.alias["%Y-%m-%d"],
					augend.date.alias["%m/%d"],
					augend.date.alias["%H:%M"],
					augend.date.alias["%Y年%-m月%-d日"],
					augend.constant.new({
						elements = { "and", "or" },
						word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
						cyclic = true, -- "or" is incremented into "and" .
					}),
					augend.constant.new({
						elements = { "Sun", "Mon", "Tue", "Wed", "Tur", "Fri", "Sat" },
						word = true,
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" },
						sord = true,
						cyclic = true,
					}),
					augend.constant.new({
						elements = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
						sord = true,
						cyclic = true,
					}),
					augend.constant.new({
						elements = {
							"星期一",
							"星期二",
							"星期三",
							"星期四",
							"星期五",
							"星期六",
							"星期日",
						},
						sord = true,
						cyclic = true,
					}),
					augend.constant.alias.bool,
					augend.constant.alias.alpha,
					augend.constant.alias.Alpha,
				},
			})
		end,
	},
	{
		"nvimtools/hydra.nvim",
		keys = { "z" },
		config = function()
			local Hydra = require("hydra")
			Hydra.setup({
				debug = false,
				exit = false,
				foreign_keys = nil,
				color = "red",
				timeout = false,
				invoke_on_body = false,
				hint = {
					show_name = true,
					position = { "bottom" },
					offset = 0,
					float_opts = {},
				},
				on_enter = nil,
				on_exit = nil,
				on_key = nil,
			})
			Hydra({
				name = "Move Screen",
				mode = "n",
				body = "z",
				hint = "z(l|h|L|H)",
				config = {},
				heads = {
					{ "l", "zl", { desc = "" } },
					{ "h", "zh", { desc = "" } },
					{ "L", "zL", { desc = "󰜴" } },
					{ "H", "zH", { desc = "󰜱" } },
					{ "j", "<c-e>", { desc = "" } },
					{ "k", "<c-y>", { desc = "" } },
					{ "J", "<c-d>", { desc = "󰜮" } },
					{ "K", "<c-u>", { desc = "󰜷" } },
				},
			})
		end,
	},
	{
		"gbprod/yanky.nvim",
		dependencies = {
			"kkharji/sqlite.lua",
		},
		keys = {
			{ "p", "<Plug>(YankyPutAfter)", desc = "Yanky Put After" },
			{ "P", "<Plug>(YankyPutBefore)", desc = "Yanky Put Before" },
			{ "y", "<Plug>(YankyYank)", desc = "Yanky Yank" },
			{
				"<leader>fy",
				function()
					require("telescope").extensions.yank_history.yank_history()
				end,
				desc = "Select Yanky History",
			},
		},
		opts = function()
			local utils = require("yanky.utils")
			local mapping = require("yanky.telescope.mapping")
			return {
				ring = {
					history_length = 1000,
					storage = "sqlite",
					storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db", -- Only for sqlite storage
					sync_with_numbered_registers = true,
					cancel_event = "update",
					ignore_registers = { "_" },
					update_register_on_cycle = false,
				},
				picker = {
					select = {
						action = nil, -- nil to use default put action
					},
					telescope = {
						mappings = {
							default = mapping.put("p"),
							i = {
								["<c-v>"] = mapping.put("p"),
								["<c-b>"] = mapping.put("P"),
								["<c-d>"] = mapping.delete(),
								["<c-c>"] = mapping.set_register(utils.get_default_register()),
							},
							n = {
								p = mapping.put("p"),
								P = mapping.put("P"),
								d = mapping.delete(),
								y = mapping.set_register(utils.get_default_register()),
							},
						},
					},
				},
				system_clipboard = {
					sync_with_ring = true,
					clipboard_register = nil,
				},
				highlight = {
					on_put = true,
					on_yank = true,
					timer = 200,
				},
				preserve_cursor_position = {
					enabled = true,
				},
				textobj = {
					enabled = true,
				},
			}
		end,
		config = function(_, opts)
			require("yanky").setup(opts)
			require("telescope").load_extension("yank_history")
		end,
	},
	{
		"rainbowhxch/accelerated-jk.nvim",
		keys = { "j", "k", "h", "l" },
		config = function()
			require("accelerated-jk").setup({
				mode = "time_driven",
				enable_deceleration = false,
				acceleration_motions = { "j", "k", "l", "h" },
				acceleration_limit = 300,
				acceleration_table = { 7, 10, 13, 15, 17, 18, 19, 20 },
				-- when 'enable_deceleration = true', 'deceleration_table = { {200, 3}, {300, 7}, {450, 11}, {600, 15}, {750, 21}, {900, 9999} }'
				deceleration_table = { { 1000, 9999 } },
			})
		end,
	},
	{
		"folke/persistence.nvim",
		lazy = false,
		-- event = "ExitPre",
		keys = {
			{
				"<leader>qs",
				function()
					--HACK:Nrotree will break nvim-lastplace
					if package.loaded["neo-tree"] then
						vim.cmd([[Neotree close]])
					end
					vim.cmd([[lua require("persistence").load() ]])
				end,
				desc = "Load Session",
			},
			{ "<leader>ql", [[<cmd>lua require("persistence").load({ last = true})<cr>]], desc = "Load Last Session" },
			{
				"<leader>qd",
				[[<cmd>lua require("persistence").stop()<cr><cmd>qa<cr>]],
				desc = "Quit and not save this session",
			},
			{ "<leader>qS", [[<cmd>lua require("persistence").select()<cr>]], desc = "Select Load Session" },
		},
		config = true,
	},
	-- {
	-- 	"windwp/nvim-autopairs",
	-- 	event = "InsertEnter",
	-- 	keys = {
	-- 		{
	-- 			"<leader>ua",
	-- 			function()
	-- 				require("nvim-autopairs").toggle()
	-- 			end,
	-- 			desc = "Toggle Autopairs",
	-- 		},
	-- 	},
	-- 	config = function()
	-- 		local npairs = require("nvim-autopairs")
	-- 		local Rule = require("nvim-autopairs.rule")
	-- 		npairs.setup({
	-- 			check_ts = true,
	-- 			ts_config = {
	-- 				tex = { "inline_formula", "math_environment", "displayed_equation" },
	-- 				latex = { "inline_formula", "math_environment", "displayed_equation" },
	-- 			},
	-- 		})
	-- 		npairs.add_rules({
	-- 			Rule("``", "''", { "tex", "latex" }),
	-- 		})
	-- 	end,
	-- },
	{
		"ethanholz/nvim-lastplace",
		event = { "BufRead" },
		config = true,
		init = function()
			if package.loaded["nvim-lastplace"] then
				return
			end
			local stats = vim.uv.fs_stat(vim.fn.argv(0))
			if stats and stats.type == "file" then
				require("nvim-lastplace").setup()
			end
		end,
	},
	{
		"folke/flash.nvim",
		lazy = true,
		event = "VeryLazy",
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
		config = function()
			require("flash").setup()
			-- local map = vim.keymap.set
			-- for _, key in ipairs(keys) do
			-- 	map(key.mode, key[1], key[2], { desc = key.desc })
			-- end
		end,
	},
	-- {
	--     "kamykn/spelunker.vim",
	--     event = "VeryLazy",
	--     config = function()
	--         vim.g.spelunker_check_type = 2
	--     end,
	-- },
	-- {
	--     "ellisonleao/glow.nvim",
	--     event = "VeryLazy",
	--     config = true,
	-- },
	{
		"folke/which-key.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({
				icons = {
					rules = {
						{ plugin = "lazygit.nvim", icon = "󰊢", color = "orange" },
						{ plugin = "ccc.nvim", icon = "", color = "yellow" },
						{ plugin = "yazi.nvim", icon = "󰇥", color = "blue" },
						{ plugin = "latex.nvim", cat = "filetype", name = "tex" },
						{ pattern = "mason", icon = "", color = "green" },
						{ pattern = "playground", icon = "󰙨", color = "red" },
					},
				},
				win = {
					no_overlap = false,
				},
			})
			wk.add({
				{ "<leader>n", group = "Noice" },
				{ "<leader>o", group = "Open window" },
				{ "<leader>b", group = "Buffer" },
				{ "<leader>t", group = "LaTeX", icon = { cat = "filetype", name = "tex" } },
				{ "<leader>f", group = "Find", icon = { icon = "", color = "blue" } },
				{ "<leader>q", group = "Session" },
				{ "g", group = "Goto" },
				{ "<leader>u", group = "Toggle" },
				{ "<leader>ot", "<cmd>terminal<cr>", desc = "Open Terminal" },
				{ "<leader>ol", "<cmd>Lazy<cr>", desc = "Open Lazy" },
				-- { "<leader>om", "<cmd>Mason<cr>", desc = "Open Mason(for LSP install)", icon = "" },
			})
			wk.add(require("mapper").which_key_spec)
		end,
	},
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		config = function()
			local ai = require("mini.ai")
			ai.setup({
				custom_textobjects = {},
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gc" },
			{ "gb" },
		},
		config = function()
			require("Comment").setup()
			local ft = require("Comment.ft")
			ft.tex = { "%%s", "\\iffalse\n%s\n\\fi" }
		end,
	},
	{
		"s1n7ax/nvim-window-picker",
		opts = {
			hint = "floating-big-letter",
			filter_rules = {
				include_current_win = true,
				bo = {
					filetype = { "fidget", "neo-tree" },
				},
			},
		},
		keys = {
			{
				"<leader>S",
				function()
					local window_number = require("window-picker").pick_window()
					if window_number then
						vim.api.nvim_set_current_win(window_number)
					end
				end,
				desc = "Pick Window",
			},
		},
	},
	{
		"aserowy/tmux.nvim",
		keys = {
			{ "<C-h>", [[<cmd>lua require("tmux").move_left()<cr>]], desc = "Move Left" },
			{ "<C-j>", [[<cmd>lua require("tmux").move_bottom()<cr>]] },
			{ "<C-k>", [[<cmd>lua require("tmux").move_top()<cr>]] },
			{ "<C-l>", [[<cmd>lua require("tmux").move_right()<cr>]] },
		},
		opts = {
			copy_sync = {
				-- enables copy sync. by default, all registers are synchronized.
				-- to control which registers are synced, see the `sync_*` options.
				enable = true,

				-- ignore specific tmux buffers e.g. buffer0 = true to ignore the
				-- first buffer or named_buffer_name = true to ignore a named tmux
				-- buffer with name named_buffer_name :)
				ignore_buffers = { empty = false },

				-- TMUX >= 3.2: all yanks (and deletes) will get redirected to system
				-- clipboard by tmux
				redirect_to_clipboard = false,

				-- offset controls where register sync starts
				-- e.g. offset 2 lets registers 0 and 1 untouched
				register_offset = 0,

				-- overwrites vim.g.clipboard to redirect * and + to the system
				-- clipboard using tmux. If you sync your system clipboard without tmux,
				-- disable this option!
				sync_clipboard = true,

				-- synchronizes registers *, +, unnamed, and 0 till 9 with tmux buffers.
				sync_registers = true,

				-- syncs deletes with tmux clipboard as well, it is adviced to
				-- do so. Nvim does not allow syncing registers 0 and 1 without
				-- overwriting the unnamed register. Thus, ddp would not be possible.
				sync_deletes = true,

				-- syncs the unnamed register with the first buffer entry from tmux.
				sync_unnamed = true,
			},
			navigation = {
				-- cycles to opposite pane while navigating into the border
				cycle_navigation = true,

				-- enables default keybindings (C-hjkl) for normal mode
				enable_default_keybindings = true,

				-- prevents unzoom tmux when navigating beyond vim border
				persist_zoom = false,
			},
			resize = {
				-- enables default keybindings (A-hjkl) for normal mode
				enable_default_keybindings = true,

				-- sets resize steps for x axis
				resize_step_x = 1,

				-- sets resize steps for y axis
				resize_step_y = 1,
			},
		},
		config = true,
	},
	{
		"kkharji/sqlite.lua",
		lazy = true,
		config = false,
	},
	-- {
	-- 	"LunarVim/bigfile.nvim",
	-- 	lazy = false,
	-- 	config = function()
	-- 		-- default config
	-- 		require("bigfile").setup({
	-- 			filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
	-- 			pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
	-- 			features = { -- features to disable
	-- 				"indent_blankline",
	-- 				"illuminate",
	-- 				"lsp",
	-- 				"treesitter",
	-- 				"syntax",
	-- 				"matchparen",
	-- 				"vimopts",
	-- 				"filetype",
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
