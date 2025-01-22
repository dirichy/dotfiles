local hs = hs
local ring = require("ring")
-- 获取屏幕的分辨率
local screen = hs.screen.mainScreen()
local screenFrame = screen:frame()

-- 定义一个函数来将窗口最大化
-- local function maximizeWindow()
-- 	local window = hs.window.focusedWindow()
-- 	if window then
-- 		window:setFrame(screenFrame) -- 设置窗口大小为屏幕大小
-- 	end
-- end
--
-- -- 定义一个函数来将窗口居中并设置大小
-- local function centerWindow()
-- 	local window = hs.window.focusedWindow()
-- 	if window then
-- 		local width = screenFrame.w / 2
-- 		local height = screenFrame.h / 2
-- 		local x = screenFrame.x + (screenFrame.w - width) / 2
-- 		local y = screenFrame.y + (screenFrame.h - height) / 2
-- 		window:setFrame(hs.geometry.rect(x, y, width, height)) -- 设置窗口为居中并缩小
-- 	end
-- end

-- 定义一个函数来将窗口放置到屏幕左侧
local frames = {
	[1] = {
		[1] = screenFrame,
	},
	[2] = {
		[1] = hs.geometry.rect({ screenFrame.x, screenFrame.y, screenFrame.w / 2, screenFrame.h }),
		[2] = hs.geometry.rect({ screenFrame.x, screenFrame.y, screenFrame.w / 2, screenFrame.h / 2 }),
		[3] = hs.geometry.rect({ screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h / 2 }),
		[4] = hs.geometry.rect({ screenFrame.w / 2, screenFrame.y, screenFrame.w / 2, screenFrame.h / 2 }),
		[5] = hs.geometry.rect({ screenFrame.w / 2, screenFrame.y, screenFrame.w / 2, screenFrame.h }),
		[6] = hs.geometry.rect({ screenFrame.w / 2, screenFrame.h / 2, screenFrame.w / 2, screenFrame.h / 2 }),
		[7] = hs.geometry.rect({ screenFrame.x, screenFrame.h / 2, screenFrame.w, screenFrame.h / 2 }),
		[8] = hs.geometry.rect({ screenFrame.x, screenFrame.h / 2, screenFrame.w / 2, screenFrame.h / 2 }),
	},
	[3] = {
		[1] = hs.geometry.rect({ screenFrame.x, screenFrame.y, screenFrame.w / 3, screenFrame.h }),
		[2] = hs.geometry.rect({ screenFrame.x, screenFrame.y, screenFrame.w * 2 / 3, screenFrame.h }),
		[3] = hs.geometry.rect({ screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h / 3 }),
		[4] = hs.geometry.rect({ screenFrame.x, screenFrame.y, screenFrame.w, screenFrame.h * 2 / 3 }),
		[5] = hs.geometry.rect({ screenFrame.w * 2 / 3, screenFrame.y, screenFrame.w / 3, screenFrame.h }),
		[6] = hs.geometry.rect({ screenFrame.w / 3, screenFrame.y, screenFrame.w * 2 / 3, screenFrame.h }),
		[7] = hs.geometry.rect({ screenFrame.x, screenFrame.h * 2 / 3, screenFrame.w, screenFrame.h / 3 }),
		[8] = hs.geometry.rect({ screenFrame.x, screenFrame.h / 3, screenFrame.w, screenFrame.h * 2 / 3 }),
	},
}

-- local function leftHalf()
-- 	local window = hs.window.focusedWindow()
-- 	if window then
-- 		window:setFullScreen(false)
-- 		local width = screenFrame.w / 2
-- 		window:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y, width, screenFrame.h)) -- 设置窗口为屏幕左半部分
-- 	end
-- end
--
-- -- 定义一个函数来将窗口放置到屏幕右侧
-- local function rightHalf()
-- 	local window = hs.window.focusedWindow()
-- 	if window then
-- 		window:setFullScreen(false)
-- 		local width = screenFrame.w / 2
-- 		window:setFrame(hs.geometry.rect(screenFrame.x + width, screenFrame.y, width, screenFrame.h)) -- 设置窗口为屏幕右半部分
-- 	end
-- end
--
-- -- 定义一个函数来将窗口放置到屏幕上半部分
-- local function topHalf()
-- 	local window = hs.window.focusedWindow()
-- 	if window then
-- 		window:setFullScreen(false)
-- 		local height = screenFrame.h / 2
-- 		window:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w, height)) -- 设置窗口为屏幕上半部分
-- 	end
-- end
--
-- -- 定义一个函数来将窗口放置到屏幕下半部分
-- local function bottomHalf()
-- 	local window = hs.window.focusedWindow()
-- 	if window then
-- 		window:setFullScreen(false)
-- 		local height = screenFrame.h / 2
-- 		window:setFrame(hs.geometry.rect(screenFrame.x, screenFrame.y + height, screenFrame.w, height)) -- 设置窗口为屏幕下半部分
-- 	end
-- end
--
-- -- 定义一个函数来使窗口全屏
-- local function fullscreenWindow()
-- 	local window = hs.window.focusedWindow()
-- 	if window then
-- 		window:setFullScreen(true) -- 将窗口切换为全屏模式
-- 	end
-- end

hs.g.window_manager_canvas = nil
local function showframe(frame)
	if hs.g.window_manager_canvas then
		hs.g.window_manager_canvas[1] = {
			type = "rectangle",
			action = "strokeAndFill",
			strokeWidth = 5,
			radius = 20,
			strokeColor = { red = 1, alpha = 1 },
			fillColor = { red = 0.3, green = 0.3, blue = 0.3, alpha = 0.5 },
			frame = { x = frame.x + 3, y = frame.y + 3, w = frame.w - 6, h = frame.h - 6 },
		}
		hs.g.window_manager_canvas:show()
	end
end
local rings = {
	{
		radius = 20,
		width = 20,
		color = { red = 0.7, green = 0.5, blue = 0.5, alpha = 0.7 },
		previewcolor = { red = 1, green = 0, blue = 0, alpha = 1 },
		trigDistance = { 10, 30 },
		terms = {
			{
				startAngle = -120,
				endAngle = 0,
				arcRadii = false,
			},
			{
				startAngle = 0,
				endAngle = 120,
				arcRadii = false,
				preview = function()
					showframe(screenFrame)
					return true
				end,
				callback = function()
					local window = hs.window.focusedWindow()
					return window:setFullScreen(true)
				end,
			},
			{
				startAngle = 120,
				endAngle = 240,
				preview = function()
					local window = hs.window.focusedWindow()
					local frame = window:frame()
					showframe({
						x = (screenFrame.w - frame.w) / 2,
						y = (screenFrame.h - frame.h) / 2,
						w = frame.w,
						h = frame.h,
					})
					return true
				end,
				callback = function()
					local window = hs.window.focusedWindow()
					local frame = window:frame()
					window:setFullScreen(false)
					window:setFrame({
						x = (screenFrame.w - frame.w) / 2,
						y = (screenFrame.h - frame.h) / 2,
						w = frame.w,
						h = frame.h,
					})
					return true
				end,
				arcRadii = false,
			},
		},
	},
	{
		radius = 55,
		width = 50,
		color = { red = 0.5, green = 0.7, blue = 0.5, alpha = 0.7 },
		previewcolor = { green = 1, alpha = 1 },
		trigDistance = { 30, 80 },
		terms = {},
	},
	{
		radius = 90,
		width = 20,
		color = { red = 0.5, green = 0.5, blue = 0.7, alpha = 0.7 },
		previewcolor = { blue = 1, alpha = 1 },
		trigDistance = { 80, 10000 },
		terms = {},
	},
}
for i = 1, 8 do
	rings[2].terms[i] = {
		startAngle = (-3.5 + i) * 45,
		endAngle = (-2.5 + i) * 45,
		arcRadii = false,
	}
end
for i = 1, 8 do
	rings[3].terms[i] = {
		startAngle = (-4 + i) * 45,
		endAngle = (-3 + i) * 45,
		arcRadii = false,
	}
end

local keyboardShortcuts = {
	[2] = {
		[1] = { left = 1, down = 0, up = 0, right = 0 },
		[2] = { left = 1, up = 1, down = 0, right = 0 },
		[3] = { up = 1, left = 0, down = 0, right = 0 },
		[4] = { up = 1, right = 1, down = 0, left = 0 },
		[5] = { right = 1, up = 0, down = 0, left = 0 },
		[6] = { right = 1, down = 1, left = 0, up = 0 },
		[7] = { down = 1, left = 0, up = 0, right = 0 },
		[8] = { down = 1, left = 1, up = 0, right = 0 },
	},
	h = { 2, 1 },
	k = { 2, 3 },
	l = { 2, 5 },
	j = { 2, 7 },
	c = { 1, 3 },
	f = { 1, 2 },
	space = { 1, 1 },
	left = { 2, 1 },
	up = { 2, 3 },
	right = { 2, 5 },
	down = { 2, 7 },
}

local keyboardCache = { left = 0, down = 0, up = 0, right = 0 }
local function checkCombine()
	for k, v in ipairs(keyboardShortcuts[2]) do
		local flag = true
		for _, key in ipairs({ "left", "down", "up", "right" }) do
			if keyboardCache[key] ~= v[key] then
				flag = false
				break
			end
		end
		if flag then
			return { 2, k }
		end
	end
	return nil
end
local function handleKeyboard(event)
	local isAltDown = event:getFlags().alt
	local keyCode = event:getKeyCode()
	local type = event:getType()
	if isAltDown then
		if type == hs.eventtap.event.types.keyDown then
			local choosed = keyboardShortcuts[hs.keycodes.map[event:getKeyCode()]]
			if choosed then
				if keyboardCache[hs.keycodes.map[event:getKeyCode()]] then
					keyboardCache[hs.keycodes.map[event:getKeyCode()]] = 1
					local combine = checkCombine()
					if combine then
						choosed = combine
					end
				end
				ring:forceChoose(choosed[1], choosed[2])
				return true
			end
		end
		if type == hs.eventtap.event.types.keyUp then
			local choosed = keyboardShortcuts[hs.keycodes.map[event:getKeyCode()]]
			if choosed then
				keyboardCache[hs.keycodes.map[event:getKeyCode()]] = 0
				return true
			end
		end
	end
	if type == hs.eventtap.event.types.flagsChanged and (event:getKeyCode() == 58 or event:getKeyCode() == 61) then
		if isAltDown then --58 is keycode of left option
			hs.g.window_manager_canvas = hs.canvas.new(screenFrame)
			hs.g.window_manager_canvas:show()
			hs.g.window_manager_canvas:level(100)
			ring:start({
				rings = rings,

				preview = function(i, j)
					if not i then
						hs.g.window_manager_canvas:hide()
						return true
					elseif frames[i] and frames[i][j] then
						showframe(frames[i][j])
						return true
					end
					return false
				end,
				callback = function(i, j)
					if frames[i] and frames[i][j] then
						local window = hs.window.focusedWindow()
						if window then
							window:setFullScreen(false)
							window:setFrame(frames[i][j]) -- 设置窗口为屏幕下半部分
							return true
						end
					end
					return false
				end,
			})
		else
			if hs.g.window_manager_canvas then
				hs.g.window_manager_canvas:delete()
				hs.g.window_manager_canvas = nil
				keyboardCache = { left = 0, right = 0, up = 0, down = 0 }
			end
			ring:stop()
		end
		return false
	else
		if hs.g.window_manager_canvas then
			hs.g.window_manager_canvas:delete()
			hs.g.window_manager_canvas = nil
			keyboardCache = { left = 0, right = 0, up = 0, down = 0 }
		end
		ring:stop()
		return false
	end
	return false
end
hs.g.window_manager = hs.eventtap.new(
	{ hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp },
	handleKeyboard
)
hs.g.window_manager:start()
-- hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "w", function()
-- 	canvas = hs.canvas.new(screenFrame)
-- 	canvas:show()
-- 	ring:start(rings)
-- end, function()
-- 	canvas:delete()
-- 	canvas = nil
-- 	ring:stop()
-- end)
-- 设置快捷键来触发这些功能
-- hs.hotkey.bind({ "alt" }, "space", fullscreenWindow) -- Cmd + Alt + M 最大化窗口
-- hs.hotkey.bind({ "alt" }, "Up", topHalf) -- Cmd + Alt + M 最大化窗口
-- hs.hotkey.bind({ "alt" }, "Down", bottomHalf) -- Cmd + Alt + M 最大化窗口
-- hs.hotkey.bind({ "alt" }, "Left", leftHalf) -- Cmd + Alt + L 居左
-- hs.hotkey.bind({ "alt" }, "Right", rightHalf) -- Cmd + Alt + R 居右
