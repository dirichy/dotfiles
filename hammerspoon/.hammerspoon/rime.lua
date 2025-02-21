hs.rime = {}
local redis = require("redis").connect("127.0.0.1", 6379)
--- toggle ascii_mode for rime
---@param bool boolean toggle ascii_mode to bool
local bool_table = {
	["true"] = true,
	["false"] = false,
}
function hs.rime.ascii_mode(bool)
	hs.rime.temp_restore = nil
	local prev_state = bool_table[redis:get("ascii_mode")]
	if bool == nil then
		bool = not prev_state
	end
	if redis:get("last_write") == "hammerspoon" and prev_state == bool then
		print(prev_state)
		print(bool)
		return
	end
	redis:set("ascii_mode", bool)
	redis:set("last_write", "hammerspoon")
	hs.rime.update()
end

hs.rime.temp_restore = nil
function hs.rime.temp_ascii(start_or_stop)
	if start_or_stop then
		print("temp_ascii_start")
		hs.rime.temp_restore = bool_table[redis:get("ascii_mode")]
		local bool = true
		if redis:get("last_write") == "hammerspoon" and hs.rime.temp_restore == bool then
			return
		end
		redis:set("ascii_mode", bool)
		redis:set("last_write", "hammerspoon")
	else
		print("temp_ascii_stop")
		if hs.rime.temp_restore == nil then
			print("temp_restore_is_nil")
			return
		end
		local bool = hs.rime.temp_restore
		hs.rime.temp_restore = nil
		if redis:get("last_write") == "hammerspoon" and hs.rime.temp_restore == bool then
			print("nothing_to_do!")
			return
		end
		print("set_ascii_to_" .. tostring(bool))
		redis:set("ascii_mode", bool)
		redis:set("last_write", "hammerspoon")
	end
end

function hs.rime.reload()
	return hs.execute('"/System/Volumes/Data/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel" --reload')
end

-- **************************************************
-- 输入法指示器
-- **************************************************

-- --------------------------------------------------
-- 指示器高度
local HEIHGT = 1.5
-- 指示器透明度
local ALPHA = 1
-- 多个颜色之间线性渐变
local ALLOW_LINEAR_GRADIENT = false
-- 指示器颜色
local IME_TO_COLORS = {
	-- 系统自带简中输入法
	["true"] = {
		{ hex = "#0ea5e9" },
	},
	["false"] = {
		{ hex = "#dc2626" },
	},
	-- ["im.rime.inputmethod.Squirrel.Hans"] = {
	-- 	{ hex = "#dc2626" },
	-- 	-- { hex = "#eab308" },
	-- 	-- { hex = "#0ea5e9" },
	-- },
}
-- --------------------------------------------------

local canvases = {}
local lastSourceID = nil

-- 绘制指示器
local function draw(colors)
	local screens = hs.screen.allScreens()

	for i, screen in ipairs(screens) do
		local frame = screen:fullFrame()

		local canvas = hs.canvas.new({ x = frame.x, y = frame.y, w = frame.w, h = HEIHGT })
		canvas:level(hs.canvas.windowLevels.overlay)
		canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
		canvas:alpha(ALPHA)

		if ALLOW_LINEAR_GRADIENT and #colors > 1 then
			local rect = {
				type = "rectangle",
				action = "fill",
				fillGradient = "linear",
				fillGradientColors = colors,
				frame = { x = 0, y = 0, w = frame.w, h = HEIHGT },
			}
			canvas[1] = rect
		else
			local cellW = frame.w / #colors

			for j, color in ipairs(colors) do
				local startX = (j - 1) * cellW
				local startY = 0
				local rect = {
					type = "rectangle",
					action = "fill",
					fillColor = color,
					frame = { x = startX, y = startY, w = cellW, h = HEIHGT },
				}
				canvas[j] = rect
			end
		end

		canvas:show()
		canvases[i] = canvas
	end
end

-- 清除 canvas 上的内容
local function clear()
	for _, canvas in ipairs(canvases) do
		canvas:delete()
	end
	canvases = {}
end

-- 更新 canvas 显示
local function update(sourceID)
	clear()

	local colors = IME_TO_COLORS[sourceID or "true"]

	if colors then
		draw(colors)
	end
end

local function handleInputSourceChanged()
	local currentSourceID = redis:get("ascii_mode")

	if lastSourceID ~= currentSourceID then
		update(currentSourceID)
		lastSourceID = currentSourceID
	end
end

hs.rime.update = handleInputSourceChanged
-- 每秒同步一次，避免由于错过事件监听导致状态不同步
-- hs.rime.ascii_indector = hs.timer.new(0.1, handleInputSourceChanged)
-- hs.rime.ascii_indector:start()
-- -- 屏幕变化时候重新渲染
-- imi_screenWatcher = hs.screen.watcher.new(update)
--
-- imi_dn:start()
-- imi_indicatorSyncTimer:start()
-- imi_screenWatcher:start()

-- 初始执行一次
update()
-- local app_options = {
-- 	["net.kovidgoyal.kitty"] = true,
-- 	["com.runningwithcrayons.Alfred"] = true,
-- 	["org.hammerspoon.Hammerspoon"] = true,
-- }
-- hs.rime.application_watcher = hs.application.watcher.new(function(appname, eventtype, app)
-- 	if eventtype == hs.application.watcher.activated then
-- 		print(app:bundleID() .. "_activate")
-- 		if app_options[app:bundleID()] then
-- 			hs.rime.temp_ascii(true)
-- 		end
-- 	end
-- 	if eventtype == hs.application.watcher.deactivated then
-- 		print(app:bundleID() .. "_deacti")
-- 		if app_options[app:bundleID()] then
-- 			local current_app = hs.application.frontmostApplication()
-- 			if not app_options[current_app:bundleID()] then
-- 				hs.rime.temp_ascii(false)
-- 			end
-- 		end
-- 	end
-- end)
-- hs.rime.application_watcher:start()
-- app_options:
--   :
--     ascii_mode: true
--   :
--     ascii_mode: true
--   org.hammerspoon.Hammerspoon:
--     ascii_mode: true
--
