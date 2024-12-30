-- Terminal buffer and window IDs stored in module scope
local M = {
  term_buf = nil,
  term_win = nil,
  job_id = nil,
}

-- Create or toggle terminal visibility
function M.toggle_terminal()
  if M.term_win and vim.api.nvim_win_is_valid(M.term_win) then
    -- Terminal window exists, hide it
    vim.api.nvim_win_hide(M.term_win)
    M.term_win = nil
  elseif M.term_buf and vim.api.nvim_buf_is_valid(M.term_buf) then
    -- Buffer exists but window doesn't, create new window
    local win_height = math.floor(vim.o.lines * 0.3)
    M.term_win = vim.api.nvim_open_win(M.term_buf, true, {
      relative = "editor",
      style = "minimal",
      row = vim.o.lines - win_height - 2,
      col = 0,
      width = vim.o.columns,
      height = win_height,
    })
  end
end

-- Handle stdout output
local function handle_stdout(_, data)
  if data then
    -- Filter for lines containing error patterns
    local qf_entries = vim.tbl_filter(function(line)
      return line:match("error CS%d+:") ~= nil
    end, data)

    -- Transform matching lines into quickfix entries
    local entries = vim.tbl_map(function(line)
      local file, line_num, col, error_msg = line:match("(.-)%((%d+),(%d+)%): error (CS%d+:.*)")
      return {
        filename = file,
        lnum = tonumber(line_num),
        col = tonumber(col),
        text = error_msg,
        type = "E",
      }
    end, qf_entries)

    if #entries > 0 then
      vim.schedule(function()
        vim.fn.setqflist({}, "a", { items = entries })
      end)
    end
  end
end

-- Start dotnet watch
function M.start_watch()
  -- Clear quickfix list before starting
  vim.fn.setqflist({}, "r")

  -- Create new terminal buffer if it doesn't exist
  if not M.term_buf or not vim.api.nvim_buf_is_valid(M.term_buf) then
    M.term_buf = vim.api.nvim_create_buf(false, true)
  end


  -- Configure job
  local job_id = vim.fn.jobstart("dotnet watch --project FulcrumProduct run", {
    on_stdout = handle_stdout,
    stdout_buffered = true,
    pty = true,
  })

  if job_id <= 0 then
    vim.notify("Failed to start dotnet watch", vim.log.levels.ERROR)
    return
  end

  M.job_id = job_id

  -- Show terminal
  local win_height = math.floor(vim.o.lines * 0.3)
  M.term_win = vim.api.nvim_open_win(M.term_buf, true, {
    relative = "editor",
    style = "minimal",
    row = vim.o.lines - win_height - 2,
    col = 0,
    width = vim.o.columns,
    height = win_height,
  })

  print("term buf", M.term_buf)

  -- Set terminal buffer options
  vim.api.nvim_buf_set_option(M.term_buf, "buftype", "terminal")
  vim.api.nvim_buf_set_option(M.term_buf, "buflisted", false)
end

-- Stop dotnet watch
function M.stop_watch()
  if M.job_id then
    vim.fn.jobstop(M.job_id)
    M.job_id = nil
  end

  if M.term_win and vim.api.nvim_win_is_valid(M.term_win) then
    vim.api.nvim_win_hide(M.term_win)
    M.term_win = nil
  end

  if M.term_buf and vim.api.nvim_buf_is_valid(M.term_buf) then
    vim.api.nvim_buf_delete(M.term_buf, { force = true })
    M.term_buf = nil
  end
end

return M
