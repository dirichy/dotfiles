local shortcuts = {
	a = "Karabiner-Elements.app",
	c = "Google Chrome.app",
	d = "Eudic.app",
	e = "Karabiner-EventViewer.app",
	g = "Gnucash.app",
	k = "kitty.app",
	m = "MenubarX.app",
	n = "noteful.app",
	q = "QQ.app",
	s = "Steam.app",
	t = "Telegram.app",
	w = "WeChat.app",
	v = "VLC.app",
	spacebar = "Alfred 5.app",
}
local JSON = require("JSON")
local applaucher = {
	title = "applaucher",
	rules = {
		{
			description = "Use thumb_on_touch+key or two finger on touch + key to open app",
			manipulators = {},
		},
	},
}
for key, value in pairs(shortcuts) do
	local mani = {
		from = { key_code = key },
		to = { shell_command = 'open -a "' .. value .. '"' },
		conditions = { { type = "variable_if", name = "multitouch_extension_palm_count_total", value = 1 } },
		type = "basic",
	}
	local mani2 = {
		from = { key_code = key },
		to = { shell_command = 'open -a "' .. value .. '"' },
		conditions = { { type = "variable_if", name = "multitouch_extension_finger_count_total", value = 2 } },
		type = "basic",
	}
	applaucher.rules[1].manipulators[#applaucher.rules[1].manipulators + 1] = mani
	applaucher.rules[1].manipulators[#applaucher.rules[1].manipulators + 1] = mani2
end
local file = io.open(os.getenv("HOME") .. "/.config/karabiner/assets/complex_modifications/applaucher.json", "w")
file:write(JSON:encode(applaucher))
file:close()
