local util = require("util")
local json = hypr.json
local uv = hypr.uv
local M = {}
M.get_dbus_item = function()
	local dbus_item = util.cmd
		.gdbus(
			"call",
			"--session",
			"--dest",
			"org.kde.StatusNotifierWatcher",
			"--object-path",
			"/StatusNotifierWatcher",
			"--method",
			"org.freedesktop.DBus.Properties.Get",
			"org.kde.StatusNotifierWatcher",
			"RegisteredStatusNotifierItems"
		)
		:match("%[.*%]")
		:gsub("'", '"')
	dbus_item = json.decode(dbus_item)
	return dbus_item
end
M.start = function()
	local dbus_item_before = M.get_dbus_item()
	local len = #dbus_item_before
	for index, value in ipairs(dbus_item_before) do
		dbus_item_before[value] = true
	end
	local handle = uv.new_timer()
	hypr.cmd(
		"env",
		"GDK_SCALE=2",
		os.getenv("HOME") .. "/.local/bin/_tencentqq",
		"--enable-features=UseOzonePlatform",
		"--ozone-platform=x11",
		"--enable-wayland-ime",
		{
			async = true,
			callback = function()
				M.dbus_item = false
			end,
		}
	)
	handle:start(1000, 1000, function()
		local dbus_item_after = M.get_dbus_item()
		if #dbus_item_after == len then
			return
		end
		for index, value in ipairs(dbus_item_after) do
			if not dbus_item_before[value] then
				handle:stop()
				handle:close()
				M.dbus_item = value:match("^[^/]*")
			end
		end
	end)
end

M.active = function()
	if M.dbus_item then
		hypr.cmd(
			"dbus-send",
			"--session",
			"--dest=" .. M.dbus_item,
			"--type=method_call",
			"--print-reply",
			"/StatusNotifierItem",
			"org.kde.StatusNotifierItem.Activate",
			"int32:0",
			"int32:0"
		)
	else
		M.start()
	end
end
return M
