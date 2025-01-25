local M = {}
M.dict = require("tiger.dict")
M.reverse = require("tiger.reverse")
M.punct = require("tiger.punct").punct
M.quickpunct = require("tiger.punct").quickpunct
function M.setup(opts)
	require("tiger.luasnip").setup()
	require("tiger.virt_text").setup()
	vim.keymap.set({ "i", "n" }, "<c-x>", function()
		vim.g.tiger = not vim.g.tiger
	end)
end
return M
