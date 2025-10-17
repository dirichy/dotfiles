local M = {}
local json = require("cjson")
local uv = require("luv")

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

local function cmd_with_result(command, args)
	for index, value in ipairs(args) do
		command = command .. " " .. value
	end
	local pipe, err = io.popen(command)
	assert(not err, err)
	local result
	if pipe then
		result = pipe:read("*a")
		pipe:close()
	end
	return result
end

local function async_cmd(command, args, callback)
	local handle
	handle = uv.spawn(command, { args = args, stdio = { nil, nil, nil } }, function(code, signal)
		uv.close(handle)
		callback(code, signal)
	end)
	return handle
end

M.cmd = setmetatable({}, {
	__index = function(t, k)
		rawset(t, k, function(...)
			return M.cmd(k, ...)
		end)
		return rawget(t, k)
	end,
	__call = function(t, command, ...)
		local args = { ... }
		local opts = {}
		if type(args[1]) == "table" then
			if type(args[1][1]) == "string" then
				args = args[1]
			else
				opts = args[1]
				args = {}
			end
		end
		if type(args[#args]) == "table" then
			opts = table.remove(args)
		end
		if opts.async then
			return async_cmd(command, args, opts.callback)
		else
			return cmd_with_result(command, args)
		end
	end,
})
return M
