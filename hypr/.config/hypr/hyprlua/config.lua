hypr.event.listen.workspacev2(function(data)
	local workspace = string.match(data, "^(%d+)")
	hypr.cmd.hyprctl("hyprpaper", "wallpaper", ",~/wallpaper/wallpaper" .. workspace .. ".JPG")
end)
