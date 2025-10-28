local uv = require("luv")
local shift = hypr.keybind.modifier.SHIFT
local ctrl = hypr.keybind.modifier.CTRL
local alt = hypr.keybind.modifier.ALT
local super = hypr.keybind.modifier.SUPER

hypr.event.listen.workspacev2(hypr.debounce(function(data)
	local workspace = string.match(data, "^(%d+)")
	-- local timer = uv.new_timer()
	-- timer:start(1, 0, function()
	hypr.cmd.hyprctl("hyprpaper", "wallpaper", ",~/wallpaper/wallpaper" .. workspace .. ".JPG")
	-- timer:stop()
	-- timer:close()
	-- end)
end, 100))

-- hypr.touch = {}
-- hypr.touch.tap = function()
-- 	local layers = require("util").get_data_from_hyprctl("layers")["DP-1"]["levels"]["2"]
-- 	for index, value in ipairs(layers) do
-- 		if value.namespace == "wofi" then
-- 			-- hypr.dispatch.exec("ydotool click 0xC0;sleep 0.1;ydotool click 0xC0")
-- 			-- print("Double click in wofi")
-- 			-- return "Double click in wofi"
-- 			print("do nothing in wofi")
-- 			return "do nothing in wofi"
-- 		end
-- 	end
-- 	local app = hypr.window.focusedWindow():application()
-- 	if app == "kitty" then
-- 		hypr.dispatch.exec("ydotool click 0xC0")
-- 		print("tap in kitty")
-- 		return "tap in kitty"
-- 	end
-- 	print("do nothing")
-- 	return "do nothing"
-- end
--
-- hypr.touch.edge = {}
-- hypr.touch.edge.l = {}
-- hypr.touch.edge.l.r = function()
-- 	local layers = require("util").get_data_from_hyprctl("layers")["DP-1"]["levels"]["2"]
-- 	for index, value in ipairs(layers) do
-- 		if value.namespace == "wofi" then
-- 			hypr.dispatch.exec("ydotool key ydotool key 1:1 1:0")
-- 			print("esc in wofi")
-- 			return "esc in wofi"
-- 			-- print("do nothing in wofi")
-- 			-- return "do nothing in wofi"
-- 		end
-- 	end
-- 	local app = hypr.window.focusedWindow():application()
-- 	if app == "zen-browser" then
-- 		hypr.dispatch.exec("ydotool key 29:1 24:1 24:0 29:0")
-- 		print("<c-o> in zen")
-- 		return "<c-o> in zen"
-- 	end
-- 	hypr.dispatch.exec("ydotool key ydotool key 1:1 1:0")
-- 	print("esc ")
-- 	return "esc "
-- end

for index, key in ipairs({ "c", "v", "a", "x" }) do
	hypr.keybind.bind(key, alt, { key, shift + ctrl }, "kitty")
	hypr.keybind.bind(key, alt, { key, ctrl })
end

for index, key in ipairs({ "h", "j", "k", "l" }) do
	local direction = { h = "l", j = "d", k = "u", l = "r" }
	for _, mod in ipairs({ super, ctrl }) do
		hypr.keybind.bind(key, mod, function()
			hypr.dispatch.movefocus(direction[key])
		end)
		hypr.keybind.bind(key, mod, function()
			hypr.keybind.sendkey(key, ctrl)
		end, function()
			local win = hypr.window.focusedWindow()
			if win:application() == "kitty" and string.match(win:gettitle(), "^.* %- Nvim$") then
				return true
			end
			return false
		end)
	end
end
