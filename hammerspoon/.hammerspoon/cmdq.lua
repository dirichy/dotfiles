local util = require("utils")
local function quitApp()
	local app = hs.application.frontmostApplication()
	app:kill()
end
local cmdQDelay = 1

util.bindHold(
	{ "cmd" },
	"q",
	quitApp,
	{ delay = cmdQDelay, alert = {
		start = "hold ⌘Q to quit",
		abort = "quit aborted",
		done = "quited",
	} }
)
hs.hotkey.bind({ "cmd", "alt" }, "q", quitApp)
