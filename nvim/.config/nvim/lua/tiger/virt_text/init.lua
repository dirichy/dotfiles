local M = {}
function M.fresh(buffer)
	vim.api.nvim_buf_clear_namespace(buffer, vim.api.nvim_create_namespace("tiger"), 1, -1)
	if vim.api.nvim_win_get_buf(0) ~= buffer then
		return
	end
	if vim.api.nvim_get_mode().mode ~= "i" then
		return
	end
	if not vim.g.tiger then
		return
	end
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = cursor[1]
	local col = cursor[2]
	local text = vim.api.nvim_buf_get_lines(buffer, line - 1, line, true)[1]
	local text_until_cursor = text:sub(1, col)
	local code = text_until_cursor:match("%l%l?%l?%l?$")
	print(code)
	if not code then
		return
	end
	if code == "" then
		return
	end
	local begin = col - #code
	local dict = require("tiger.dict")
	if dict[code] then
		vim.api.nvim_buf_set_extmark(buffer, vim.api.nvim_create_namespace("tiger"), line - 1, begin, {
			virt_text = { { dict[code][1], "ErrorMsg" } },
			end_col = col,
			end_row = line - 1,
			conceal = "",
			undo_restore = false,
			invalidate = true,
			virt_text_pos = "inline",
		})
	end
end
local seted = {}
function M.setupbuf(buffer)
	buffer = buffer.buf
	if seted[buffer] then
		return
	end
	seted[buffer] = true
	vim.api.nvim_set_option_value("conceallevel", 2, { scope = "local" })
	vim.api.nvim_set_option_value("concealcursor", "i", { scope = "local" })
	vim.api.nvim_create_autocmd({ "TextChangedI", "ModeChanged" }, {
		callback = function()
			M.fresh(buffer)
		end,
	})
end
function M.setup(opts)
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*.txt",
		callback = M.setupbuf,
	})
end
return M
