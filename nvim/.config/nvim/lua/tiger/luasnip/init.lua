local M = {}
function M.setup(opts)
	local ls = require("luasnip")
	local s = ls.snippet
	local sn = ls.snippet_node
	local t = ls.text_node
	local i = ls.insert_node
	local f = ls.function_node
	local c = ls.choice_node
	local d = ls.dynamic_node
	local extras = require("luasnip.extras")
	local l = extras.lambda
	local fmt = require("luasnip.extras.fmt").fmt
	local fmta = require("luasnip.extras.fmt").fmta
	local rep = require("luasnip.extras").rep
	local line_begin = require("luasnip.extras.expand_conditions").line_begin
	local tiger = require("tiger")
	local luasnip = require("luasnip")
	for k, v in pairs(tiger.quickpunct) do
		if string.match(k, "%l") then
			table.insert(tiger.dict[k], 2, v)
		end
	end
	luasnip.add_snippets("all", {
		s({
			trig = "%f[%l](%l%l?%l?%l?)([^%l])",
			wordTrig = false,
			regTrig = true,
			priority = 500,
			snippetType = "autosnippet",
		}, {
			f(function(_, snip)
				local code = snip.captures[1]
				local next = snip.captures[2]
				if next == " " then
					next = ""
				end
				if next == ";" then
					return tiger.dict[code] and tiger.dict[code][2] and tiger.dict[code][2] or code
				end
				if next == "'" then
					return tiger.dict[code] and tiger.dict[code][3] and tiger.dict[code][3] or code
				end
				next = tiger.punct[next] or next
				return tiger.dict[snip.captures[1]] and tiger.dict[snip.captures[1]][1] .. next or next
			end),
		}, {
			condition = function()
				return vim.g.tiger
			end,
		}),
		s({
			trig = "%f[%l](%l%l%l%l)(%l)",
			wordTrig = false,
			regTrig = true,
			priority = 500,
			snippetType = "autosnippet",
		}, {
			f(function(_, snip)
				local code = snip.captures[1]
				local next = snip.captures[2]
				return tiger.dict[code] and tiger.dict[code][1] .. next or next
			end),
		}, {
			condition = function()
				return vim.g.tiger
			end,
		}),
		s({
			trig = ";([%l; ])",
			wordTrig = false,
			regTrig = true,
			priority = 500,
			snippetType = "autosnippet",
		}, {
			f(function(_, snip)
				local code = snip.captures[1]
				return tiger.quickpunct[code] or code .. ";"
			end),
		}, {
			condition = function()
				return vim.g.tiger
			end,
		}),
		s({
			trig = "([,.:?/'\"!$^_<>%[%]])",
			wordTrig = false,
			regTrig = true,
			priority = 500,
			snippetType = "autosnippet",
		}, {
			f(function(_, snip)
				local code = snip.captures[1]
				return tiger.punct[code]
			end),
		}, {
			condition = function()
				return vim.g.tiger
			end,
		}),
	})
end
return M
