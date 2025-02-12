local redis = require("redis").connect("127.0.0.1", 6379)
local M = {}
local system = vim.uv.os_uname().sysname
local sshtty = vim.env.SSH_TTY
local tex = require("nvimtex.conditions.luasnip")
local prev_state = nil
local return_state = nil
local bool_table = {
	["true"] = true,
	["false"] = false,
}
if sshtty then
	return
end

vim.g.imselect_enabled = 1

function M.modecond()
	return vim.api.nvim_get_mode().mode == "i" or vim.fn.getcmdtype() == "/" or vim.fn.getcmdtype() == "?"
end

function M.langcond()
	return true
end

function M.cursorcond()
	if vim.bo.filetype == "tex" or vim.bo.filetype == "latex" then
		return tex.in_text()
	else
		return true
	end
end

function M.refersh()
	if not vim.g.imselect_enabled then
		return
	end
	if redis:get("last_write") == "rime" then
		prev_state = bool_table[redis:get("ascii_mode")]
	end
	if M.modecond() and M.langcond() and M.cursorcond() then
		M.enableim()
	else
		M.disableim()
	end
end
local prev_cursor_state = M.cursorcond()
function M.cursor_refersh()
	if prev_cursor_state ~= M.cursorcond() then
		M.refersh()
		prev_cursor_state = M.cursorcond()
	end
end

if system == "Linux" then
	M.enableim = function()
		vim.cmd("silent !fcitx-remote -o")
	end
	M.disableim = function()
		vim.cmd("silent !fcitx-remote -c")
	end
elseif system == "Darwin" then
	M.enableim = function()
		-- vim.cmd(
		-- 	[[silent !hs -c 'hs.eventtap.keyStroke({"shift","ctrl","alt"},"9",nil,hs.application.applicationForBundleID("im.rime.inputmethod.Squirrel"))']]
		-- )
		if return_state ~= nil then
			redis:set("ascii_mode", return_state)
		else
			redis:set("ascii_mode", true)
		end
		redis:set("last_write", "neovim")
		return_state = nil
	end
	M.disableim = function()
		-- vim.cmd(
		-- 	[[silent !hs -c 'hs.eventtap.keyStroke({"shift","ctrl","alt"},"0",nil,hs.application.applicationForBundleID("im.rime.inputmethod.Squirrel"))']]
		-- )
		return_state = prev_state
		redis:set("ascii_mode", true)
		redis:set("last_write", "neovim")
	end
else
	error("Imselect only support linux and mac now.")
end

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	callback = M.refersh,
})

vim.api.nvim_create_autocmd({ "CursorMovedI" }, {
	callback = function()
		vim.schedule(function()
			M.cursor_refersh()
		end)
	end,
})
vim.api.nvim_create_autocmd({ "User" }, {
	pattern = { "LuasnipInsertNodeEnter", "LuasnipInsertNodeLeave" },
	callback = function()
		vim.schedule(function()
			M.cursor_refersh()
		end)
	end,
})

return M
