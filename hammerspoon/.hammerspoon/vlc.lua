local keymap = {
	[10] = { { "command", "shift" }, "equal_sign" },
	[12] = { { "command" }, "f" },
	[13] = { { "command" }, "hyphen" },
	[15] = "open_bracket",
	[16] = "close_bracket",
	[1] = "spacebar",
	[5] = { { "shift" }, "n" },
	[6] = "n",
	[4] = "h",
	[2] = "l",
	[3] = { { "command" }, "period" },
}
local dpadmap = {
	right = "up_arrow",
	left = "down_arrow",
	up = "left_arrow",
	down = "right_arrow",
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

for key, value in pairs(keymap) do
	local to
	if type(value) == "string" then
		to = { key_code = value }
	else
		to = { key_code = value[2], modifiers = value[1] }
	end
	local mani = {
		from = { pointing_button = "button" .. tostring(key) },
		to = to,
		conditions = { { type = "device_if", identifiers = { { vendor_id = 1406 } } } },
		type = "basic",
	}
	table.insert(loop.rules[1].manipulators, mani)
end
for key, value in pairs(dpadmap) do
	local to
	if type(value) == "string" then
		to = { key_code = value }
	else
		to = { key_code = value[2], modifiers = value[1] }
	end
	local mani = {
		from = { generic_desktop = "dpad_" .. key },
		to = to,
		conditions = { { type = "device_if", identifiers = { { vendor_id = 1406 } } } },
		type = "basic",
	}
	table.insert(loop.rules[1].manipulators, mani)
end
local file = io.open(os.getenv("HOME") .. "/.config/karabiner/assets/complex_modifications/vlc.json", "w")
file:write(JSON:encode(loop))
file:close()
print(JSON:encode(loop))
