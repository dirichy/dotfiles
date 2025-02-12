hs.rime = {}
local redis = require("redis").connect("127.0.0.1", 6379)
--- toggle ascii_mode for rime
---@param bool boolean toggle ascii_mode to bool
function hs.rime.ascii_mode(bool)
	if redis:get("last_write") == "hammerspoon" and redis:get("ascii_mode") == tostring(bool) then
		return
	end
	redis:set("ascii_mode", bool)
	redis:set("last_write", "hammerspoon")
end
function hs.rime.reload()
	return hs.execute('"/System/Volumes/Data/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel" --reload')
end
