hs.ipc = require("hs.ipc")
local util = require("utils")

hs.g = {}
require("wifi_mute")
require("pasteboard")
-- require("corner")
-- require("rusty")
require("vlc")
-- require("test")
require("cmdq")
-- require("window_manager")
require("scripts.caffeine")
require("loop")

hs.hotkey.bind({ "cmd" }, "space", function()
	hs.osascript.applescript('tell application "Alfred 5" to search')
end)

-- hs.hotkey.bind({ "cmd", "alt" }, "S", function()
-- 	hs.osascript.applescript('tell application "ClashX Pro" to toggleProxy')
-- 	hs.osascript.applescript('tell application "Bartender 5" to show "com.west2online.ClashXPro-Item-0"')
-- end)

-- hs.hotkey.bind({ "cmd", "alt" }, "t", function()
-- 	local result, aa = hs.dialog.textPrompt("请输入一些文本", "请输入你的名字:", "", "1", "2")
-- 	if result then
-- 		hs.alert.show("你输入的名字是: " .. result .. aa)
-- 	else
-- 		hs.alert.show("你输入的名字是: " .. result .. aa)
-- 	end
-- end)

-- local kitty_fix_time = 0
-- hs.g.kitty_fix = hs.application.watcher.new(function(name, type, application)
-- 	if name == "kitty" and type == hs.application.watcher.activated and os.time() > kitty_fix_time then
-- 		kitty_fix_time = os.time()
-- 		application:hide()
-- 		application:activate()
-- 	end
-- end)
-- hs.g.kitty_fix:start()
local afterboot = require("afterboot")
afterboot()
require("rime")
require("lazy")
-- require("karabiner")
-- hs.karabiner.setup()
-- hs.karabiner.press({ "right_command", "fn" }, "e", function()
-- 	hs.alert("success!")
-- end)
-- hs.karabiner.write()
