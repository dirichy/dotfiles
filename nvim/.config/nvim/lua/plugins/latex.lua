return {
	{
		vim.fn.isdirectory("/Users/dirichy/nvimtex.nvim/") == 0 and "dirichy/nvimtex.nvim",
		dir = vim.fn.isdirectory("/Users/dirichy/nvimtex.nvim/") == 1 and "/Users/dirichy/nvimtex.nvim",
		ft = { "tex", "latex" },
		keys = {
			{
				"<leader>tv",
				function()
					require("nvimtex.view.zathura")()
				end,
				desc = "Compile LaTeX File",
			},
			{
				"<leader>tb",
				function()
					vim.cmd.write()
					require("nvimtex.compile.arara")()
				end,
				desc = "Compile LaTeX File",
			},
		},
		config = function()
			require("nvimtex").setup()
		end,
	},
	-- {
	-- 	vim.fn.isdirectory("/Users/dirichy/latex.nvim/") == 0 and "dirichy/latex.nvim",
	-- 	dir = vim.fn.isdirectory("/Users/dirichy/latex.nvim/") == 1 and "/Users/dirichy/latex.nvim",
	-- 	ft = { "tex" },
	-- 	config = function()
	-- 		require("latex_snip").setup()
	-- 	end,
	-- },
	{
		vim.fn.isdirectory("/Users/dirichy/latex_concealer.nvim/") == 0 and "dirichy/latex_concealer.nvim",
		dir = vim.fn.isdirectory("/Users/dirichy/latex_concealer.nvim/") == 1 and "/Users/dirichy/latex_concealer.nvim",
		ft = "tex",
		-- keys = {
		-- 	{
		-- 		"<leader>tc",
		-- 		function()
		-- 			require("latex_concealer").setup_buf(vim.api.nvim_win_get_buf(0))
		-- 		end,
		-- 	},
		-- },
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
