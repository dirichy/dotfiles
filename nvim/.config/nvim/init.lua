if vim.env.PROF then
	-- example for lazy.nvim
	-- change this to the correct path for your plugin manager
	local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
	vim.opt.rtp:append(snacks)
	require("snacks.profiler").startup({
		startup = {
			event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
			-- event = "UIEnter",
			-- event = "VeryLazy",
		},
	})
end
vim.loader.enable()
vim.g.tex_conceal = ""
require("options")
require("lazy_nvim")
require("keymaps")
require("autocmds")
require("chinese.im")
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.lilypond = {
	install_info = {
		url = "https://github.com/nwhetsell/tree-sitter-lilypond", -- local path or git repo
		files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
		-- optional entries:
		branch = "main", -- default branch in case of git repo if different from master
		generate_requires_npm = false, -- if stand-alone parser without npm dependencies
		requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
	},
	-- filetype = "zu", -- if filetype does not match the parser name
}
