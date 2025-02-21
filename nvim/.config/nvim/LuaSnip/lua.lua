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

local keywords = {
	["and"] = true,
	["break"] = true,
	["do"] = true,
	["else"] = true,
	["elseif"] = true,
	["end"] = true,
	["false"] = true,
	["for"] = true,
	["function"] = true,
	["if"] = true,
	["in"] = true,
	["local"] = true,
	["nil"] = true,
	["not"] = true,
	["or"] = true,
	["repeat"] = true,
	["return"] = true,
	["then"] = true,
	["true"] = true,
	["until"] = true,
	["while"] = true,
}
local function keyword_as_key_condition(_, _, captures)
	if not keywords[captures[1]] then
		return false
	end
	local cursor = vim.api.nvim_win_get_cursor(0)
	cursor[1] = cursor[1] - 1
	cursor[2] = cursor[2] - 2
	if cursor[2] < 0 then
		cursor[2] = 0
	end
	local node = vim.treesitter.get_node({ pos = cursor })
	if not node then
		return false
	end
	local parent = node:parent()
	if not parent then
		return false
	end
	if parent:type() == "dot_index_expression" and node:equal(parent:field("field")[1]) then
		return true
	end
	local grand_parent = parent:parent()
	if not grand_parent then
		return
	end
	if
		grand_parent:type() == "table_constructor"
		and parent:type() == "field"
		and node:equal(parent:field("value")[1])
	then
		return true
	end
	return false
end
return {
	s(
		{ trig = "([a-z]*)=", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta('["<>"]=<>', {
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(0),
		}),
		{
			condition = keyword_as_key_condition,
		}
	),
	s(
		{ trig = "%.([a-z]*)", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta('["<>"]<>', {
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(0),
		}),
		{
			condition = keyword_as_key_condition,
		}
	),
	s(
		"localreq",
		fmt('local {} = require("{}")', {
			l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
			i(1, "module"),
		})
	),
	s(
		"lzayreq",
		fmt('local {} = util.lazyreq("{}")', {
			l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
			i(1, "module"),
		})
	),
	ls.parser.parse_snippet("lm", "local M = {}\n\n$1 \n\nreturn M"),
	s(
		{ trig = "csnip", snippetType = "autosnippet" },
		fmta(
			[[
      s(
        { trig = "<>", snippetType = "autosnippet" },
        c(1, { sn(nil, { t("\\<>{"), i(1), t("}") }), sn(nil, { t("\\<>*{"), i(1), t("{") }) }),
        { condition = tex.<> }
      ),
      ]],
			{ i(1), rep(1), rep(1), c(2, { t("in_text"), t("in_math") }) }
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "optsnip", snippetType = "autosnippet" },
		fmta(
			[[
      s(
        { trig = "<>", snippetType = "autosnippet" },
        c(1, { sn(nil, { t("\\<>{"), i(1), t("}") }), sn(nil, { t("\\<>["), i(1), t("]{"), i(2), t("}") }) }),
        { condition = tex.<> }
      ),
      ]],
			{ i(1), rep(1), rep(1), c(2, { t("in_quantikz"), t("in_math") }) }
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "starsnip", snippetType = "autosnippet" },
		fmta(
			[[
      s(
        { trig = "<>", snippetType = "autosnippet" },
        c(1, { sn(nil, { t("\\<>{"), i(1), t("}") }), sn(nil, { t("\\<>*{"), i(1), t("}") }) }),
        { condition = tex.<> }
      ),
      ]],
			{ i(1), rep(1), rep(1), c(2, { t("in_quantikz"), t("in_math") }) }
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "fmtasnip", snippetType = "autosnippet" },
		fmta(
			[[
      s({ trig = "<>", snippetType = "autosnippet" },
        fmta("\\<>{<<>>}", {
        <>
        }),
       { condition = tex.<> }),
      ]],
			{ i(1), rep(1), i(2, "i(1),"), c(3, { t("in_math"), t("in_quantikz") }) }
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "tsnip", snippetType = "autosnippet" },
		fmta(
			[[
      s({ trig = "<>", snippetType = "autosnippet" }, {
        t("\\<>"),
      }, { condition = tex.<> }),
      ]],
			{ i(1), rep(1), c(2, { t("in_math"), t("in_quantikz") }) }
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "envsnip", snippetType = "autosnippet" },
		fmta(
			[[
s({ trig = "<>", snippetType = "autosnippet" },
  fmta("\\begin{<>}<>\n  \n\\end{<>}", {
  }),
 { condition = line_begin}),
    ]],
			{ i(1), i(2), i(3), rep(2) }
		),
		{ condition = line_begin }
	),
}
