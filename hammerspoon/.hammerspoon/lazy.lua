hs.g.topit = hs.hotkey.bind({ "cmd", "alt" }, "p", function()
	hs.application.open("Topit")
	hs.g.topit:delete()
	hs.eventtap.keyStroke({ "cmd", "alt" }, "p")
end)
