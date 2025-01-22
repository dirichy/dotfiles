local ls = require("luasnip")
local get_magic_comment = require("latex_snip.util").get_magic_comment
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local tex = require("latex_snip.conditions.luasnip")
local rep = require("luasnip.extras").rep
-- local pinyin = require("latex_snip.flypy")
local knowntypes = {
	pro = { en = "Problem", zh = "问题" },
	fig = { en = "Figure", zh = "图" },
	lem = { en = "Lemma", zh = "引理" },
	equ = { en = "Equation", zh = "公式" },
	unknown = { en = "", zh = "" },
}

return {
	s({ trig = "if" }, {
		t("\\text{\\ if\\ }"),
	}, { condition = tex.in_math }),
	s({ trig = "otherwise", snippetType = "autosnippet" }, {
		t("\\text{\\ otherwise\\ }"),
	}, { condition = tex.in_math }),
	s({ trig = "then" }, {
		t("\\text{\\ then\\ }"),
	}, { condition = tex.in_math }),
	s({ trig = "since" }, {
		t("\\text{\\ since\\ }"),
	}, { condition = tex.in_math }),

	s({ trig = "label", snippetType = "autosnippet" }, {
		t("\\label{"),
		i(1),
		t("}"),
	}, { condition = tex.in_text, show_condition = tex.in_text }),
	s(
		{ trig = "ref", snippetType = "autosnippet" },
		fmta("<><><>}", {
			f(function(args, _)
				local label = args[1][1]
				local type = string.match(label, "^[^:]*")
				type = knowntypes[type] and knowntypes[type] or knowntypes["unknown"]
				type = type[get_magic_comment("language")] and type[get_magic_comment("language")] .. " " or ""
				return type
			end, { 1 }),
			f(function(args, _)
				local label = args[1][1]
				local type = string.match(label, "^[^:]*")
				type = type == "equ" and "\\eqref{" or "\\ref{"
				return type
			end, { 1 }),
			i(1),
		}),
		{ condition = tex.in_text }
	),
	s(
		{ trig = "\\%)(%a)", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
		fmta("\\) <>", {
			f(function(_, snip)
				return snip.captures[1]
			end),
		})
	),
	s(
		{ trig = "\\](%a)", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
		fmta("\\] <>", {
			f(function(_, snip)
				return snip.captures[1]
			end),
		})
	),
	-- s(
	--   { trig = "idx", snippetType = "autosnippet" },
	--   fmta("\\index{<>@<>}<>", {
	--     f(function(args, _)
	--       return pinyin(args[1][1])
	--     end, { 1 }),
	--     i(1),
	--     rep(1),
	--   }),
	--   { condition = tex.in_text }
	-- ),
	-- s(
	--   { trig = "bfidx", snippetType = "autosnippet" },
	--   fmta("\\index{<>@<>|textbf}\\textbf{<>}", {
	--     f(function(args, _)
	--       return pinyin(args[1][1])
	--     end, { 1 }),
	--     i(1),
	--     rep(1),
	--   }),
	--   { condition = tex.in_text }
	-- ),
	-- s({ trig = "psp", snippetType = "autosnippet" }, {
	--   t("\\(p\\)-subgroup"),
	-- }, { condition = tex.in_text }),
	-- s({ trig = "pgp", snippetType = "autosnippet" }, {
	--   t("\\(p\\)-subgroup"),
	-- }, { condition = tex.in_text }),
	-- s({ trig = "spsp", snippetType = "autosnippet" }, {
	--   t("Sylow \\(p\\)-subgroup"),
	-- }, { condition = tex.in_text }),
}
