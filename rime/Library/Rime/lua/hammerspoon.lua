local handle = io.popen("uname -s")  -- 获取操作系统名称
local os_name = handle:read("*a"):gsub("\n", "")
handle:close()

if os_name == "Darwin" then
    print("This is macOS")
elseif os_name == "Linux" then
  return function ()
  end
else
    print("Unknown OS: " .. os_name)
end
local redis = require("redis")
local client = redis.connect("127.0.0.1", 6379)
client:set("ascii_mode", true)
-- local cmds = {
-- 	ascii_mode_true = function(env)
-- 		env.engine.context:set_option("ascii_mode", true)
-- 	end,
-- 	ascii_mode_false = function(env)
-- 		env.engine.context:set_option("ascii_mode", false)
-- 	end,
-- }
local bool_table = {
	["true"] = true,
	["false"] = false,
}

local function hammerspoon(key, env)
	local ctx = env.engine.context
	local ascii_mode = client:get("ascii_mode")
	local result = nil
	ascii_mode = bool_table[ascii_mode]
	-- if key.keycode == 65482 then
	-- 	ascii_mode = not ascii_mode
	--
	-- 	if ctx:is_composing() then
	-- 		ctx:commit()
	-- 	end
	-- 	result = 0
	-- end
	if ascii_mode ~= ctx:get_option("ascii_mode") then
		ctx:set_option("ascii_mode", ascii_mode)
		if ctx:is_composing() then
			ctx:commit()
		end
		-- io.popen("/usr/local/bin/hs -c 'hs.rime.update()'")
	end
	client:set("last_write", "rime")
	client:set("ascii_mode", ascii_mode)
	return result
	-- if ctx:get_option("hammerspoon") then
	-- 	return
	-- end
	-- local pipe = io.popen([=[/usr/local/bin/hs -c "hs.rime.execute()"]=])
	-- if not pipe then
	-- 	return
	-- end
	-- local cmd = pipe:read("*l")
	-- while cmd and cmd ~= "" do
	-- 	if cmds[cmd] then
	-- 		cmds[cmd](env)
	-- 	end
	-- 	cmd = pipe:read("*l")
	-- end
	-- pipe:close()
end
return hammerspoon
