local shortcuts = {
	c = "Google Chrome.app",
	d = "Eudic.app",
	e = "Karabiner-EventViewer.app",
	k = "kitty.app",
	m = "MenubarX.app",
	q = "QQ.app",
	s = "Steam.app",
	t = "Telegram.app",
	w = "WeChat.app",
}
local JSON = require("JSON")
local applaucher =
	{ title = "applaucher", rules = { {
		description = "Use esc+key to open app",
		manipulators = {},
	} } }
for key, value in pairs(shortcuts) do
	local mani = {
		from = { key_code = key },
		to = { shell_command = 'open -a "' .. value .. '"' },
		conditions = { { type = "variable_if", name = "esc_down", value = 1 } },
		type = "basic",
	}
	applaucher.rules[1].manipulators[#applaucher.rules[1].manipulators + 1] = mani
end
local file = io.open(os.getenv("HOME") .. "/.config/karabiner/assets/complex_modifications/applaucher.json", "w")
file:write(JSON:encode(applaucher))
file:close()
