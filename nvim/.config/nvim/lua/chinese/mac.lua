local redis = require("redis").connect("127.0.0.1", 6379)
local M = {}
local bool_table = {
	["true"] = true,
	["false"] = false,
}

M.active_im = function()
	redis:set("ascii_mode", false)
	redis:set("last_write", "neovim")
end
M.disable_im = function()
	redis:set("ascii_mode", true)
	redis:set("last_write", "neovim")
end
M.im_active = function()
	return not bool_table[redis:get("ascii_mode")]
end
return M
