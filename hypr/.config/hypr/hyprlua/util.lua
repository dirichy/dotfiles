local M = {}
local json = require("cjson")

--- get data from "hyprctl command -j" and convert it into lua table
---@param command string
---@return table
function M.get_data_from_hyprctl(command)
	command = "hyprctl " .. command .. " -j"
	local pipe = io.popen(command)
	local result
	if pipe then
		result = json.decode(pipe:read("*a"))
		pipe:close()
	end
	return result
end

--- return a function to get data from hyprctl
---@param command string
---@return fun():table
function M.function_to_get_data_from_hyprctl(command)
	return function()
		return M.get_data_from_hyprctl(command)
	end
end

local function hyprctl_dispatch(command, ...)
	local args = { ... }
	command = "hyprctl dispatch " .. command
	for index, value in ipairs(args) do
		command = command .. " " .. value
	end
	local pipe = io.popen(command)
	local result
	if pipe then
		result = pipe:read("*a")
		pipe:close()
	end
	return result
end

M.dispatch = setmetatable({}, {
	__index = function(t, k)
		rawset(t, k, function(...)
			hyprctl_dispatch(k, ...)
		end)
		return rawget(t, k)
	end,
	__call = function(t, command, ...)
		hyprctl_dispatch(command, ...)
	end,
})
return M
