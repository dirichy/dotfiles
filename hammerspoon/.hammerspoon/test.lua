if false then
	local leftUpTimer = hs.timer.doAfter(0.05, function()
		local point = hs.mouse.absolutePosition()
		hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, point):post()
	end)

	hs.g.scrollevent = hs.eventtap.new({ hs.eventtap.event.types.scrollWheel }, function(event)
		local point = hs.mouse.absolutePosition()
		local deltax = event:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis2)
		local deltay = event:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis1)
		if deltax == 0 and deltay == 0 then
			return false
		end
		if not leftUpTimer:running() then
			hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, point):post()
			leftUpTimer:start()
		else
			leftUpTimer:stop()
			leftUpTimer:start()
		end
		point.x = point.x + deltax
		point.y = point.y + deltay
		hs.mouse.absolutePosition(point)
		return true
	end)
	hs.g.scrollevent:start()
end

hs.g.gestureEvent = hs.eventtap.new({ hs.eventtap.event.types.gesture }, function(event)
	local touches = event:getTouches()
	print(#touches)
	-- for k, v in ipairs(touches) do
	-- 	for a, b in pairs(v) do
	-- 		print(a, b)
	-- 	end
	-- end
end)
hs.g.gestureEvent:start()
