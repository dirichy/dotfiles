local trig = {
	jj = "jj",
	tt = "tt",
}

local system=nil
local handle = io.popen("uname -s")  -- 获取操作系统名称
local os_name = handle:read("*a"):gsub("\n", "")
handle:close()

if os_name == "Darwin" then
  system="mac"
elseif os_name == "Linux" then
  system="linux"
else
  system="unknown"
end
local auto_put = function(key, env)
	local input = env.engine.context.input --.. string.char(key.keycode)
  if system=="mac" then
    input=input..string.char(key.keycode)
  end
	if trig[input] then
		env.engine:commit_text(trig[input])
		env.engine.context:clear()
		return 1
	end
	return 2
end
return auto_put
