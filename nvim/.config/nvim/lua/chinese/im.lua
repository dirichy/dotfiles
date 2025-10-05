-- local redis = require("redis").connect("127.0.0.1", 6379)
local M = {}
local system = vim.uv.os_uname().sysname
local sshtty = vim.env.SSH_TTY
local tex = require("nvimtex.conditions.luasnip")
-- local return_state = nil
-- return_state = redis:get("ascii_mode")
vim.g.imselect_enabled = true

if sshtty then
	return
end
if system == "Linux" then
	M = require("chinese.linux")
elseif system == "Darwin" then
	M = require("chinese.mac")
else
	error("Imselect only support linux and mac now.")
end
local im_state = {
	perm_ascii = 0,
	temp_ascii = 1,
	none_ascii = 2,
}
local cur_state = M.im_active() and im_state.none_ascii or im_state.perm_ascii

function M.cond()
	if vim.bo.filetype == "tex" or vim.bo.filetype == "latex" then
		return tex.im_enable()
			and (vim.api.nvim_get_mode().mode == "i" or vim.fn.getcmdtype() == "/" or vim.fn.getcmdtype() == "?")
	else
		return (vim.api.nvim_get_mode().mode == "i" or vim.fn.getcmdtype() == "/" or vim.fn.getcmdtype() == "?")
	end
end

local prev_cond = M.cond()
local function cond_changed()
	local cur_cond = M.cond()
	if cur_cond == prev_cond then
		return
	end
	prev_cond = cur_cond
	return cur_cond
end

function M.refersh()
	if not vim.g.imselect_enabled then
		return
	end
	local flag = cond_changed()
	if flag == nil then
		return
	end
	local state = M.im_active()
	local state_without_operation = cur_state == im_state.none_ascii
	if state ~= state_without_operation then
		if state then
			cur_state = im_state.none_ascii
		else
			cur_state = im_state.perm_ascii
		end
	end
	if flag then
		if cur_state == im_state.temp_ascii then
			M.active_im()
			cur_state = im_state.none_ascii
		end
	else
		if cur_state == im_state.none_ascii then
			M.disable_im()
			cur_state = im_state.temp_ascii
		end
	end
end

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	callback = function()
		vim.schedule(function()
			-- M.cursor_refersh()
			M.refersh()
		end)
	end,
})

vim.api.nvim_create_autocmd({ "CursorMovedI" }, {
	callback = function()
		vim.schedule(function()
			M.refersh()
			-- M.refersh()
		end)
	end,
})

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = { "LuasnipInsertNodeEnter", "LuasnipInsertNodeLeave" },
	callback = function()
		vim.schedule(function()
			-- M.refersh()
			M.refersh()
		end)
	end,
})
return M
