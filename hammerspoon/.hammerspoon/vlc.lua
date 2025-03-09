local vlc_map = {
	normal_speed = { key_code = "equal_sign" },
	faster = { key_code = "equal_sign", modifiers = { "command", "shift" } },
	slower = { key_code = "hyphen", modifiers = { "command" } },
	faster_more = { key_code = "0", modifiers = { "command", "shift" } },
	slower_more = { key_code = "9", modifiers = { "command", "shift" } },
	begin = { key_code = "j", modifiers = { "shift" } },
	fullscreen = { key_code = "f", modifiers = { "command" } },
	pause = { key_code = "spacebar" },
	prev = { key_code = "n", modifiers = { "shift" } },
	next = { key_code = "n" },
	backward = { key_code = "h" },
	forward = { key_code = "l" },
	backward_more = { key_code = "h", modifiers = { "shift" } },
	forward_more = { key_code = "l", modifiers = { "shift" } },
	show_time = { key_code = "t" },
	stop = { key_code = "period", modifiers = { "command" } },
	up = { key_code = "up_arrow" },
	down = { key_code = "down_arrow" },
	left = { key_code = "left_arrow" },
	right = { key_code = "right_arrow" },
	audio_delay = { key_code = "open_bracket" },
	audio_advance = { key_code = "close_bracket" },
	volume_up = { key_code = "up_arrow", modifiers = { "command" } },
	volume_down = { key_code = "down_arrow", modifiers = { "command" } },
}
local keymap = {
	[10] = vlc_map.faster,
	[12] = vlc_map.fullscreen,
	[13] = vlc_map.slower,
	[1] = vlc_map.pause,
	[5] = vlc_map.audio_delay,
	[6] = vlc_map.audio_advance,
	[4] = vlc_map.backward,
	[2] = vlc_map.forward,
	[3] = vlc_map.stop,
}
local mod1_keymap = {
	[10] = vlc_map.faster_more,
	[13] = vlc_map.slower_more,
	[4] = vlc_map.backward_more,
	[2] = vlc_map.forward_more,
	[5] = vlc_map.volume_down,
	[6] = vlc_map.volume_up,
	[1] = vlc_map.show_time,
}

local mod2_keymap = {
	[10] = vlc_map.normal_speed,
	[13] = vlc_map.normal_speed,
	[4] = vlc_map.begin,
	[2] = vlc_map.forward_more,
}
local mod12_keymap = {
	[10] = vlc_map.normal_speed,
	[13] = vlc_map.normal_speed,
	[2] = vlc_map.prev,
	[4] = vlc_map.next,
}
local virtul_mod = {
	[15] = { name = "joncon_mod_1", alone = { pointing_button = "button1" } },
	[16] = { name = "joncon_mod_2", alone = { pointing_button = "button2" } },
}
local dpadmap = {
	right = { mouse_key = { y = -1536 } },
	left = { mouse_key = { y = 1536 } },
	up = { mouse_key = { x = -1536 } },
	down = { mouse_key = { x = 1536 } },
}
local JSON = require("JSON")
local loop = {
	title = "vlc",
	rules = {
		{
			description = "Keybind for using joncon to control vlc, see github.com/dirichy/dotfiles",
			manipulators = {},
		},
	},
}

for key, value in pairs(mod12_keymap) do
	local mani = {
		from = { pointing_button = "button" .. tostring(key) },
		to = value,
		conditions = {
			{ type = "variable_if", name = "joncon_mod_1", value = 1 },
			{ type = "variable_if", name = "joncon_mod_2", value = 1 },
			{ type = "device_if", identifiers = { { vendor_id = 1406 } } },
		},
		type = "basic",
	}
	table.insert(loop.rules[1].manipulators, mani)
end
for key, value in pairs(mod1_keymap) do
	local mani = {
		from = { pointing_button = "button" .. tostring(key) },
		to = value,
		conditions = {
			{ type = "variable_if", name = "joncon_mod_1", value = 1 },
			{ type = "variable_if", name = "joncon_mod_2", value = 0 },
			{ type = "device_if", identifiers = { { vendor_id = 1406 } } },
		},
		type = "basic",
	}
	table.insert(loop.rules[1].manipulators, mani)
end

for key, value in pairs(mod2_keymap) do
	local mani = {
		from = { pointing_button = "button" .. tostring(key) },
		to = value,
		conditions = {
			{ type = "variable_if", name = "joncon_mod_1", value = 0 },
			{ type = "variable_if", name = "joncon_mod_2", value = 1 },
			{ type = "device_if", identifiers = { { vendor_id = 1406 } } },
		},
		type = "basic",
	}
	table.insert(loop.rules[1].manipulators, mani)
end

-- for key, value in pairs(mod2_dpadmap) do
-- 	local mani = {
-- 		from = { generic_desktop = "dpad_" .. key },
-- 		to = value,
-- 		conditions = {
-- 			{ type = "variable_if", name = "joncon_mod_1", value = 0 },
-- 			{ type = "variable_if", name = "joncon_mod_2", value = 1 },
-- 			{ type = "device_if", identifiers = { { vendor_id = 1406 } } },
-- 		},
-- 		type = "basic",
-- 	}
-- 	table.insert(loop.rules[1].manipulators, mani)
-- end
--
-- for key, value in pairs(mod1_dpadmap) do
-- 	local mani = {
-- 		from = { generic_desktop = "dpad_" .. key },
-- 		to = value,
-- 		conditions = {
-- 			{ type = "variable_if", name = "joncon_mod_1", value = 1 },
-- 			{ type = "variable_if", name = "joncon_mod_2", value = 0 },
-- 			{ type = "device_if", identifiers = { { vendor_id = 1406 } } },
-- 		},
-- 		type = "basic",
-- 	}
-- 	table.insert(loop.rules[1].manipulators, mani)
-- end
for key, value in pairs(virtul_mod) do
	local to_if_alone
	if type(value.alone) == "string" then
		to_if_alone = { key_code = value.alone }
	else
		to_if_alone = value.alone
	end
	local mani = {
		from = { pointing_button = "button" .. tostring(key) },
		to = { set_variable = { name = value.name, value = 1 } },
		to_after_key_up = { set_variable = { name = value.name, value = 0 } },
		to_if_alone = to_if_alone,
		conditions = { { type = "device_if", identifiers = { { vendor_id = 1406 } } } },
		type = "basic",
	}
	table.insert(loop.rules[1].manipulators, mani)
end
for key, value in pairs(keymap) do
	local mani = {
		from = { pointing_button = "button" .. tostring(key) },
		to = value,
		conditions = { { type = "device_if", identifiers = { { vendor_id = 1406 } } } },
		type = "basic",
	}
	table.insert(loop.rules[1].manipulators, mani)
end
for key, value in pairs(dpadmap) do
	local mani = {
		from = { generic_desktop = "dpad_" .. key },
		to = value,
		conditions = { { type = "device_if", identifiers = { { vendor_id = 1406 } } } },
		type = "basic",
	}
	table.insert(loop.rules[1].manipulators, mani)
end
local file = io.open(os.getenv("HOME") .. "/.config/karabiner/assets/complex_modifications/vlc.json", "w")
file:write(JSON:encode(loop))
file:close()
print(JSON:encode(loop))
