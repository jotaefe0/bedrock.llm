local M = {}

local url = os.getenv("AWS_BEDROCK_URL")

local function get_visual_selection()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
	if #lines == 0 then
		return ""
	end

	lines[1] = string.sub(lines[1], start_pos[3])
	if #lines > 1 then
		lines[#lines] = string.sub(lines[#lines], 1, end_pos[3] - (#lines > 1 and 1 or 0))
	else
		lines[1] = string.sub(lines[1], 1, end_pos[3] - start_pos[3] + 1)
	end
	return table.concat(lines, "\n")
end

local function create_or_open_file(filename)
	local bufnr = vim.fn.bufnr(filename)
	local winnr = vim.fn.bufwinnr(bufnr)

	if winnr > 0 then
		vim.cmd(winnr .. "wincmd w")
	else
		if bufnr == -1 then
			vim.cmd("vsplit " .. filename)
			vim.cmd("write")
		else
			vim.cmd("vsplit " .. filename)
		end
	end
	return vim.api.nvim_get_current_buf()
end

function M.stream_response()
	local prompt = get_visual_selection()
	if prompt == "" then
		print("No text selected")
		return
	end

	local payload = vim.json.encode({
		api_key = os.getenv("AWS_BEDROCK_API_KEY"),
		temperature = 0,
		model = "anthropic.claude-3-5-sonnet-20240620-v1:0",
		system = "You are an expert LUA and NVIM coder",
		max_tokens = 4096,
		prompt = prompt,
	})

	local filename = "llm.md"
	local buf = create_or_open_file(filename)

	local line_count = vim.api.nvim_buf_line_count(buf)

	require("plenary.job")
		:new({
			command = "curl",
			args = {
				"-X",
				"POST",
				url,
				"-H",
				"Content-Type: application/json",
				"-d",
				payload,
				"--no-buffer",
			},
			on_stdout = function(_, line)
				vim.schedule(function()
					line_count = line_count + 1
					vim.api.nvim_buf_set_lines(buf, line_count - 1, line_count, false, { line })
					vim.fn.writefile({ line }, filename, "a")
					if vim.api.nvim_get_current_buf() == buf then
						vim.api.nvim_win_set_cursor(0, { line_count, 0 })
					end
				end)
			end,
			on_exit = function(_, return_val) end,
		})
		:start()
end

return M
