-- TODO: aaa
return {
	{
		vim.fn.isdirectory(vim.env.HOME .. "/nvimtex.nvim/") == 0 and "dirichy/nvimtex.nvim",
		dir = vim.fn.isdirectory(vim.env.HOME .. "/nvimtex.nvim/") == 1 and vim.env.HOME .. "/nvimtex.nvim",
		ft = { "tex", "latex" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"m00qek/baleia.nvim",
		},
		keys = {
			{
				"<leader>tv",
				function()
					require("nvimtex.view").sioyek()
				end,
				desc = "View Pdf",
			},
			{
				"<leader>tb",
				function()
					vim.cmd.wall()
					require("nvimtex.compile").arara()
				end,
				desc = "Compile LaTeX File",
			},
			{
				"<leader>tl",
				function()
					require("nvimtex.compile").showlog()
				end,
				desc = "Show log file",
			},
		},
		config = function()
			require("nvimtex").setup()
			require("luasnip.loaders.from_lua").load({})
		end,
	},
	{
		enabled = true,
		vim.fn.isdirectory("/Users/dirichy/latex_concealer.nvim/") == 0 and "dirichy/latex_concealer.nvim",
		dir = vim.fn.isdirectory("/Users/dirichy/latex_concealer.nvim/") == 1 and "/Users/dirichy/latex_concealer.nvim",
		ft = { "tex", "latex" },
		keys = {
			{
				"<leader>tc",
				function()
					require("latex_concealer").toggle()
				end,
				desc = "Toggle LaTeX concealer",
			},
			{
				"<leader>ul",
				function()
					require("latex_concealer").toggle()
				end,
				desc = "Toggle LaTeX concealer",
			},
		},
		opts = {},
		config = true,
	},
	-- {
	-- 	"lervag/vimtex",
	-- 	lazy = false,
	-- },
	-- {
	--   "bamonroe/rnoweb-nvim",
	--   lazy=false,
	--   enabled=false,
	--   dependencies={
	--     "nvim-lua/plenary.nvim"
	--   },
	--   config=true,
	-- }
}
