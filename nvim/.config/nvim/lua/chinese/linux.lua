local M = {}
M.active_im = function()
	vim.cmd("silent !fcitx5-remote -o")
end
M.disable_im = function()
	vim.cmd("silent !fcitx5-remote -c")
end
---@return boolean
---TODO: finish this function
function M.im_active()
	local output = vim.fn.system("fcitx5-remote")
	output = string.gsub(output, "%s", "")
	return output == "2"
end
return M
