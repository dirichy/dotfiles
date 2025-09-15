local Job = require("plenary.job")

--- 构造默认 arara 参数
local function default_args(path)
	path = path or vim.fn.expand("%:p")
	-- 提取文件名（去除路径和.tex扩展名）
	local jobname = vim.fn.fnamemodify(path, ":t:r") --(path, "([^/]*)%.tex$")
	-- 获取文件所在目录
	local cwd = vim.fn.fnamemodify(path, ":h") --(path, "(.*)/[^/]*%.tex$")
	local args = { jobname .. ".c", "-o", jobname }
	local command = "clang"

	local on_exit = function(j, return_val)
		if return_val == 0 then
			Job:new({
				command = "./" .. jobname,
				cwd = cwd,
				args = {},
				on_exit = function(o, flag)
					if flag == 0 then
						local out = table.concat(o:result(), "\n")
						vim.notify(out, vim.log.levels.INFO)
					else
						local out = table.concat(o:result(), "\n")
						vim.notify(out, vim.log.levels.ERROR)
					end
				end,
			}):start()
		else
			local out = table.concat(j:result(), "\n")
			vim.notify(out, vim.log.levels.ERROR)
		end
	end

	return { command = command, cwd = cwd, args = args, on_exit = on_exit }
end

--- arara 命令主入口，仅返回此函数
local function clang(opts)
	local args = vim.tbl_deep_extend("force", default_args(), opts or {})
	Job:new(args):start()
end

vim.keymap.set("n", "<leader>tc", clang)
