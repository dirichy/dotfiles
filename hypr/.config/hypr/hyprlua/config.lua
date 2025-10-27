local uv = require("luv")

hypr.event.listen.workspacev2(hypr.debounce(function(data)
	local workspace = string.match(data, "^(%d+)")
	-- local timer = uv.new_timer()
	-- timer:start(1, 0, function()
	hypr.cmd.hyprctl("hyprpaper", "wallpaper", ",~/wallpaper/wallpaper" .. workspace .. ".JPG")
	-- timer:stop()
	-- timer:close()
	-- end)
end, 100))

hypr.touch = {}
hypr.touch.tap = function()
	local layers = require("util").get_data_from_hyprctl("layers")["DP-1"]["levels"]["2"]
	for index, value in ipairs(layers) do
		if value.namespace == "wofi" then
			-- hypr.dispatch.exec("ydotool click 0xC0;sleep 0.1;ydotool click 0xC0")
			-- print("Double click in wofi")
			-- return "Double click in wofi"
			print("do nothing in wofi")
			return "do nothing in wofi"
		end
	end
	local app = hypr.window.focusedWindow():application()
	if app == "kitty" then
		hypr.dispatch.exec("ydotool click 0xC0")
		print("tap in kitty")
		return "tap in kitty"
	end
	print("do nothing")
	return "do nothing"
end

hypr.touch.edge = {}
hypr.touch.edge.l = {}
hypr.touch.edge.l.r = function()
	local layers = require("util").get_data_from_hyprctl("layers")["DP-1"]["levels"]["2"]
	for index, value in ipairs(layers) do
		if value.namespace == "wofi" then
			hypr.dispatch.exec("ydotool key ydotool key 1:1 1:0")
			print("esc in wofi")
			return "esc in wofi"
			-- print("do nothing in wofi")
			-- return "do nothing in wofi"
		end
	end
	local app = hypr.window.focusedWindow():application()
	if app == "zen-browser" then
		hypr.dispatch.exec("ydotool key 29:1 24:1 24:0 29:0")
		print("<c-o> in zen")
		return "<c-o> in zen"
	end
	hypr.dispatch.exec("ydotool key ydotool key 1:1 1:0")
	print("esc ")
	return "esc "
end
