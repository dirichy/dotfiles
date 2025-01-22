return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		dependencies = {},
		config = function()
			require("tokyonight").setup({
				on_highlights = function(highlight, color)
					highlight["@neorg.headings.5.prefix.norg"] = {
						fg = "#2c8217",
					}
					highlight["@neorg.headings.5.prefix"] = {
						fg = "#2c8217",
					}
					highlight["@neorg.headings.5.title.norg"] = {
						fg = "#2c8217",
					}
					highlight["@neorg.headings.5.title"] = {
						fg = "#2c8217",
					}
					highlight["@script"] = {
						fg = "#bb8ade",
					}
					highlight["@relationship"] = {
						fg = "#abcdef",
					}
					highlight["@others"] = {
						fg = "#123456",
					}
					highlight["@mathfont"] = {
						fg = "#f59090",
					}
					highlight["MathGreek"] = {
						fg = "#44ff44",
					}
					highlight.Function = {
						fg = "#e49ef2",
					}
					highlight["@markup.math"] = "MathZone"
					highlight.MathZone = {
						fg = "#c1de73",
					}
					highlight["@operator"] = "Operator"
					highlight["@hugeoperator"] = "Operator"
					highlight.Operator = {
						fg = "#68e8d7",
					}
					highlight["@punctuation.bracket"] = {
						--fg = "#d8b37c"
						fg = "#73dec1",
					}
					highlight["@label"] = {
						--fg ="#1281cb"
						fg = "#7385f9",
					}
					highlight["@none"] = {
						fg = "#a9b1d6",
					}
					highlight["@breaket"] = {
						fg = "#aa88bb",
					}
					highlight["@blueColor"] = {
						fg = "#397fbf",
						--purple #a14fe0
						--pink #e04fd4
					}
					highlight["@purpleColor"] = {
						fg = "#a14fe0",
					}
					highlight["@redColor"] = {
						fg = "#e04fd4",
					}
					highlight["@greenColor"] = {
						fg = "#4fe0b5",
					}
				end,
			})
			vim.cmd([[colorscheme tokyonight-storm]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"folke/tokyonight.nvim",
			"nvim-tree/nvim-web-devicons",
			"linrongbin16/lsp-progress.nvim",
		},
		opts = function()
			vim.o.laststatus = vim.g.lualine_laststatue
			return {
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {
						function()
							return require("lsp-progress").progress()
						end,
					},
					lualine_x = { "encoding", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			}
		end,
		config = function(_, opts)
			require("lsp-progress").setup({})
			require("lualine").setup(opts)
			vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				group = "lualine_augroup",
				pattern = "LspProgressStatusUpdated",
				callback = require("lualine").refresh,
			})
		end,
	},
	{
		"utilyre/barbecue.nvim",
		event = "VeryLazy",
		dependencies = {
			"folke/tokyonight.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			theme = "tokyonight",
		},
	},
	{
		"SmiteshP/nvim-navic",
		event = "VeryLazy",
		dependencies = {
			"folke/tokyonight.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = true,
	},
	{
		"uga-rosa/ccc.nvim",
		keys = {
			{ "<leader>oc", "<cmd>CccPick<cr>", desc = "Open Color Picker" },
		},
		config = function()
			require("ccc").setup({
				highlighter = {
					auto_enable = true,
					lsp = true,
				},
			})
		end,
	},
	{
		"norcalli/nvim-terminal.lua",
		ft = "terminal",
		config = function()
			require("terminal").setup({})
		end,
	},
}
