local hs = hs
local M = {}
local modsTable = { cmd = 1, alt = 2, ctrl = 4, shift = 8 }
local function mods2number(mods)
	local result = 0
	for _, mod in ipairs(mods) do
		result = result + modsTable[mod]
	end
	return result
end

M.map = {}
function M.bind(mods, key, func)
	local opts = M.map.key[mods2number(mods)]
	opts.delay = opts.delay or 1
	opts.alert = opts.alert or {}
	local storedTime = nil
	local timer = nil

	local function start()
		storedTime = hs.timer.secondsSinceEpoch()
		timer = hs.timer.doAfter(opts.delay, function()
			func()
			if opts.alert.done then
				hs.alert(opts.alert.done)
			end
		end)
		if opts.alert.start then
			hs.alert(opts.alert.start)
		end
	end
	local function stop()
		if hs.timer.secondsSinceEpoch() < storedTime + opts.delay then
			storedTime = nil
			if timer then
				timer:stop()
			end
			timer = nil
			if opts.alert.abort then
				hs.alert(opts.alert.abort)
			end
		end
	end
	hs.hotkey.bind(mods, key, start, stop)
end
function M.hold(mods, key, func, opts) end
