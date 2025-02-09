local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.expand_conditions").line_begin
local fmta = require("luasnip.extras.fmt").fmta

-- [
-- personal imports
-- ]
local tex = require("latex_snip.conditions.luasnip")
local text_line_begin_leader = "%."
local envs = {
	pf = { name = "proof", condition = 2 },
	so = { name = "solution", condition = 2 },
	ex = { name = "exercise", condition = 2, label = "exe" },
	cr = { name = "center", condition = 2 },
	pr = { name = "problem", condition = 2, label = "pro" },
	le = { name = "lemma", condition = 2, label = "lem" },
	en = { name = "enumerate", condition = 2, prefix = "\\item " },
	ep = { name = "example", confition = 2, label = "exa" },
	it = { name = "itemize", condition = 2, prefix = "\\item " },
	eq = { name = "equation", condition = 2, label = "equ" },
	de = { name = "definition", condition = 2, label = "def" },
	co = { name = "corollary", condition = 2, label = "cor" },
	th = { name = "theorem", condition = 2, label = "the" },
	fr = { name = "frame", condition = 2 },
	fg = { name = "figure", condition = 2, prefix = "\\centering" },
	ct = { name = "center", condition = 2 },
}
local make_label = function(_, snip)
	local env = envs[snip.captures[1]]
	local label = env.label
	if label then
		return sn(nil, {
			f(function(args, _)
				if args[1][1] ~= "" then
					return "\\label{" .. label .. ":"
				else
					return " "
				end
			end, { 1 }),
			i(1),
			f(function(args, _)
				if args[1][1] ~= "" then
					return "}"
				else
					return ""
				end
			end, { 1 }),
		})
	else
		return sn(nil, { t("") })
	end
end
M = {
	s(
		{ trig = text_line_begin_leader .. "(%a%a)", regTrig = true, snippetType = "autosnippet", priority = 100 },
		fmta(
			[[
\begin{<>}<>
  <><>
\end{<>}
<>
      ]],
			{
				f(function(_, snip)
					return envs[snip.captures[1]].name
				end),
				d(1, make_label),
				f(function(_, snip)
					return envs[snip.captures[1]].prefix or ""
				end),
				i(2),
				f(function(_, snip)
					return envs[snip.captures[1]].name
				end),
				i(0),
			}
		),
		{ condition = tex.in_text * line_begin }
	),
	s({ trig = "。", snippetType = "autosnippet", priority = 2000 }, {
		t("."),
	}, { condition = tex.in_text * line_begin }),
	s(
		{ trig = text_line_begin_leader .. "eg", regTrig = true, snippetType = "autosnippet", priority = 1000 },
		fmta(
			[[
\begin{<>}
  <>
\end{<>}
<>
      ]],
			{
				i(1),
				i(2),
				rep(1),
				i(0),
			}
		),
		{ condition = tex.in_text * line_begin }
	),
	s({ trig = "  item", snippetType = "autosnippet" }, {
		t("\\item"),
	}, { condition = tex.in_item * line_begin }),
	s({ trig = "item", snippetType = "autosnippet", priority = 100 }, {
		t("\\item"),
	}, { condition = tex.in_item * line_begin }),
	s(
		{ trig = ";j", snippetType = "autosnippet" },
		fmta(
			[[
      \(<>\)<>
      ]],
			{
				i(1),
				i(0),
			}
		),
		{ condition = tex.in_text }
	),
	s(
		{ trig = ";t", snippetType = "autosnippet" },
		fmta(
			[[
      \[
        <>
      \]
      ]],
			{
				i(1),
			}
		),
		{ condition = tex.in_text }
	),
}
return M
