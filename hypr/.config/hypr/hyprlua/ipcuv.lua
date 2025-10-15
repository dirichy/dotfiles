local uv = require("luv")
local socket = require("luv").tcp

-- 配置
local TCP_PORT = 5555
local xdg = os.getenv("XDG_RUNTIME_DIR")
local sig = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")
local HYPR_SOCKET = xdg .. "/hypr/" .. sig .. "/.socket2.sock"

-- =========================
-- TCP Server
-- =========================
local tcp_server = uv.new_tcp()
tcp_server:bind("0.0.0.0", TCP_PORT)
tcp_server:listen(128, function(err)
	assert(not err, err)
	local client = uv.new_tcp()
	tcp_server:accept(client)

	local chunks = {}
	client:read_start(function(err, data)
		if err then
			print("TCP read error:", err)
			client:close()
			return
		end
		if data then
			table.insert(chunks, data)
		else
			-- EOF
			local code = table.concat(chunks)
			if #code > 0 then
				local fn, err = load(code, "tcp", "t", _G)
				local res
				if not fn then
					res = "Compile error: " .. err
				else
					local ok, r = pcall(fn)
					if ok then
						res = tostring(r)
					else
						res = "Runtime error: " .. tostring(r)
					end
				end
				client:write(res .. "\n")
			end
			client:close()
		end
	end)
end)
print("TCP server listening on port", TCP_PORT)

-- =========================
-- Hyprland Event Listener
-- =========================
local hypr_client = uv.new_pipe(false)
hypr_client:connect(HYPR_SOCKET, function(err)
	if err then
		print("Failed to connect Hyprland socket:", err)
		return
	end
	print("Connected to Hyprland event socket")
end)

-- 持续读取 Hyprland 事件
local buf = ""
hypr_client:read_start(function(err, data)
	if err then
		print("Hyprland read error:", err)
		return
	end
	if data then
		buf = buf .. data
		for line in buf:gmatch("([^\n]+)\n?") do
			local event, payload = line:match("([^>]+)>>(.+)")
			if event and payload then
				print("[Hyprland Event] ", event, payload)
			end
		end
		-- 保留未处理残余
		buf = buf:match("([^\n]*$)") or ""
	end
end)

-- =========================
-- 启动事件循环
-- =========================
uv.run()
