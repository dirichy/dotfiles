local function vlcShiftTime(time)
	hs.osascript([=[tell application "VLC"
    set currentTime to current time
    set current time to currentTime + ]=] .. time .. [=[

end tell]=])
end
local shifttime = 5
hs.hotkey.bind({ "cmd", "alt" }, "P", function()
	hs.osascript.applescript('tell application "VLC" to play')
end)

hs.hotkey.bind({ "cmd", "alt" }, "Right", function()
	vlcShiftTime(shifttime)
end)

hs.hotkey.bind({ "cmd", "alt" }, "Left", function()
	vlcShiftTime(-shifttime)
end)

hs.hotkey.bind({ "cmd", "alt" }, ";", function()
	local confirm, time = hs.dialog.textPrompt("设置VLC跳跃的时间", "请输入秒数:", "5", "确定", "取消")
	if confirm == "确定" then
		shifttime = tonumber(time) or 5
	end
end)
