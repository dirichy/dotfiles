local M = setmetatable({
	["a"] = { "来" },
	["aa"] = { "书" },
	["aaa"] = { "卍" },
	["aaaa"] = { "卍", "卐" },
}, {
	__index = function(t, k)
		t[k] = { "我" }
		return t[k]
	end,
})
return M
