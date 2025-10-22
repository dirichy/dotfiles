--# selene: allow(unused_variable)
---@diagnostic disable: unused-local
local util = require("util")
---@class hypr.window
local M = {}
M.__index = M
M.__concat = function(a, b)
	if type(a) == "table" then
		a = "address:" .. a.address
	end
	if type(b) == "table" then
		b = "address:" .. b.address
	end
	return a .. b
end
local function table2window(t)
	return setmetatable(t, M)
end
---@return hypr.window[]
function M.allWindows()
	local windows = util.get_data_from_hyprctl("clients")
	for index, value in ipairs(windows) do
		windows[index] = table2window(value)
	end
	return windows
end
---@return string
function M:application()
	return self.class
end
---@return hypr.window
function M:toggleFloat()
	return util.dispatch.togglefloating(self)
end
---@return boolean
function M:close()
	return util.dispatch.killwindow(self)
end
---@return hypr.workspace
function M:getWorkspace()
	return self.workspace
end
local function windowMeetHint(window, hint)
	if type(hint) == "table" then
		for key, value in pairs(hint) do
			if window[key] ~= value then
				return false
			end
		end
		return true
	else
		for key, value in pairs({ class = hint, title = hint }) do
			if string.match(window[key], value) then
				return true
			end
		end
		return false
	end
end
---@param hint string|table
---@return hypr.window?
function M.find(hint)
	local allwindow = M.allWindows()
	for index, value in ipairs(allwindow) do
		if windowMeetHint(value, hint) then
			return value
		end
	end
	return nil
end
---@return boolean
function M:focus()
	return util.dispatch.focuswindow(self)
end
---@return hypr.window
function M.focusedWindow()
	return setmetatable(util.get_data_from_hyprctl("activewindow"), M)
end
---@return hypr.geometry
function M:frame()
	return { self.at[1], self.at[2], self.size[1], self.size[2] }
end
function M:id()
	return M.address
end
function M:isFullScreen()
	return self.fullscreen == 1
end
function M:isFloating()
	return self.floating
end

---@return boolean
function M:moveToWorkspace(workspace)
	return util.dispatch.movetoworkspace(workspace.id .. "," .. self)
end

function M:gettitle()
	return self.title
end

function M.toggleFullScreen()
	return util.dispatch.fullscreen()
end
return M
