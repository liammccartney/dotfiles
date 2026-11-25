-- Guided code tours driven by Claude over the server socket: a step sidebar,
-- PR diff signs against a base revision, and a quickfix list of the PR's hunks.
--
-- A tour is a JSON file Claude rewrites as the walkthrough goes:
--   { "title": "...", "root": "/abs/repo", "base": "<rev>",
--     "steps": [ { "title": "...", "file": "rel/path", "line": 12, "notes": "markdown",
--                  "locations": [ { "file": "rel/other", "line": 3, "label": "optional" } ] } ] }
-- `locations` is optional: a step that spans several files lists the others there, after its `file`.
-- `base` is optional: without it the tour walks the code as it is, with no diff signs or PR hunks.
local M = {}

local SIDEBAR_WIDTH = 60
-- The step list starts after the title line and a blank line.
local STEP_LIST_OFFSET = 2

local state = {
  path = nil,
  tour = nil,
  current = 1,
  -- Index into the current step's locations, and the sidebar line each location is rendered on.
  loc = 1,
  loc_lines = {},
  -- A multi-file step opens each location after the first in its own tab; the first stays in the tour's tab.
  main_tab = nil,
  loc_tabs = {},
  sidebar_buf = nil,
  inline_on = false,
}

local function read_tour(path)
  local fd = assert(io.open(path, 'r'))
  local tour = vim.json.decode(fd:read '*a')
  fd:close()
  tour.steps = tour.steps or {}
  return tour
end

local function has_tour()
  if state.tour then return true end
  vim.notify('No tour loaded. Start one with :Tour <file>', vim.log.levels.WARN)
  return false
end

local function sidebar_valid() return state.sidebar_buf and vim.api.nvim_buf_is_valid(state.sidebar_buf) end

local function is_code_win(win)
  if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).relative ~= '' then return false end
  local buf = vim.api.nvim_win_get_buf(win)
  return buf ~= state.sidebar_buf
    and vim.bo[buf].buftype ~= 'quickfix'
    and not vim.api.nvim_buf_get_name(buf):match '^gitsigns://'
end

local function sidebar_win()
  if not sidebar_valid() then return nil end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == state.sidebar_buf then return win end
  end
end

-- Prefer the window the user is in, so a step never yanks them into a split they weren't using.
local function code_win()
  local candidates = { vim.api.nvim_get_current_win(), vim.fn.win_getid(vim.fn.winnr '#') }
  vim.list_extend(candidates, vim.api.nvim_tabpage_list_wins(0))
  for _, win in ipairs(candidates) do
    if win ~= 0 and is_code_win(win) then return win end
  end
end

--- The step's `file` and `line` first, then its `locations`, skipping a repeat of the first.
local function step_locations(step)
  local locs = {}
  if step.file then locs[1] = { file = step.file, line = step.line } end
  for _, loc in ipairs(step.locations or {}) do
    local first = locs[1]
    if loc.file and not (first and first.file == loc.file and (first.line or 1) == (loc.line or 1)) then
      locs[#locs + 1] = loc
    end
  end
  return locs
end

local function render()
  if not sidebar_valid() then return end
  local tour = state.tour
  local lines = { '# ' .. (tour.title or 'Tour'), '' }
  state.loc_lines = {}
  for i, step in ipairs(tour.steps) do
    lines[#lines + 1] = ('%s %d. %s'):format(i == state.current and '▶' or ' ', i, step.title)
  end
  local step = tour.steps[state.current]
  if step then
    vim.list_extend(lines, { '', '---', '', ('## %d. %s'):format(state.current, step.title), '' })
    local locs = step_locations(step)
    for j, loc in ipairs(locs) do
      local where = ('`%s:%d`'):format(loc.file, loc.line or 1)
      local marker = #locs > 1 and (j == state.loc and '▶ ' or '  ') or ''
      lines[#lines + 1] = marker .. (loc.label and (loc.label .. ' — ' .. where) or where)
      state.loc_lines[#lines] = j
    end
    if #locs > 0 then lines[#lines + 1] = '' end
    vim.list_extend(lines, vim.split(step.notes or '_Notes coming…_', '\n'))
  end
  vim.bo[state.sidebar_buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.sidebar_buf, 0, -1, false, lines)
  vim.bo[state.sidebar_buf].modifiable = false
end

local function create_sidebar_buf()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].filetype = 'markdown'
  vim.bo[buf].bufhidden = 'hide'
  vim.api.nvim_buf_set_name(buf, 'tour://sidebar')
  vim.keymap.set('n', '<CR>', function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    if state.loc_lines[row] then return M.goto_loc(state.loc_lines[row]) end
    local i = row - STEP_LIST_OFFSET
    if state.tour.steps[i] then M.goto(i) end
  end, { buffer = buf, desc = 'Go to tour step or step location' })
  vim.keymap.set('n', 'q', M.toggle_sidebar, { buffer = buf, desc = 'Close tour sidebar' })
  return buf
end

function M.open_sidebar()
  if sidebar_win() then return end
  if not sidebar_valid() then state.sidebar_buf = create_sidebar_buf() end
  local prev = vim.api.nvim_get_current_win()
  vim.cmd 'topleft vsplit'
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, state.sidebar_buf)
  vim.api.nvim_win_set_width(win, SIDEBAR_WIDTH)
  vim.wo[win].winfixwidth = true
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = 'no'
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
  vim.api.nvim_set_current_win(prev)
  render()
end

function M.toggle_sidebar()
  local win = sidebar_win()
  if win then
    vim.api.nvim_win_close(win, false)
  elseif has_tour() then
    M.open_sidebar()
  end
end

--- Open a location in the code window; `edit` records the jump, so <C-o> returns.
function M.show(file, line)
  local win = code_win()
  if not win then
    vim.cmd 'botright vsplit'
    win = vim.api.nvim_get_current_win()
  end
  vim.api.nvim_set_current_win(win)
  vim.cmd(('edit +%d %s'):format(line or 1, vim.fn.fnameescape(file)))
  vim.cmd 'normal! zz'
end

local function file_hunks_title(buf) return 'Hunks: ' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':.') end

--- `action` ' ' pushes a new list, so :colder returns to the PR-wide one; 'r' refreshes this file's list in place.
local function set_file_hunks(buf, hunks, action)
  local items = {}
  for _, hunk in ipairs(hunks) do
    local kind = hunk.type == 'add' and 'Added' or hunk.type == 'delete' and 'Removed' or 'Changed'
    items[#items + 1] = {
      bufnr = buf,
      lnum = math.max(hunk.added.start, 1),
      text = ('%-7s %s'):format(kind, hunk.added.lines[1] or hunk.removed.lines[1] or ''),
    }
  end
  vim.fn.setqflist({}, action, { title = file_hunks_title(buf), items = items })
  vim.cmd 'copen | wincmd p'
end

--- Fill the quickfix list with gitsigns' hunks for `buf`, which compare against the tour base and include
--- uncommitted edits. A fresh buffer, or one whose base just changed, has no hunks until gitsigns' async diff
--- finishes, and GitSignsUpdate only fires when the change summary differs, so poll briefly instead.
local HUNK_POLL_MS, HUNK_POLL_TRIES = 100, 30

function M.file_hunks(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  state.hunks_poll = (state.hunks_poll or 0) + 1
  local poll = state.hunks_poll
  local hunks = require('gitsigns').get_hunks(buf) or {}
  set_file_hunks(buf, hunks, ' ')
  if #hunks > 0 then return end
  local tries = 0
  local function retry()
    if poll ~= state.hunks_poll or not vim.api.nvim_buf_is_valid(buf) then return end
    hunks = require('gitsigns').get_hunks(buf) or {}
    if #hunks > 0 then
      if vim.fn.getqflist({ title = 0 }).title == file_hunks_title(buf) then set_file_hunks(buf, hunks, 'r') end
      return
    end
    tries = tries + 1
    if tries < HUNK_POLL_TRIES then vim.defer_fn(retry, HUNK_POLL_MS) end
  end
  vim.defer_fn(retry, HUNK_POLL_MS)
end

--- Quickfix entries, one per hunk, from `git diff -U0 <args>` run in the tour root.
local function diff_items(args)
  local root = state.tour.root or vim.fn.getcwd()
  local cmd = vim.list_extend({ 'git', 'diff', '-U0', '--no-color', '--no-ext-diff' }, args)
  local diff = vim.system(cmd, { cwd = root, text = true }):wait()
  if diff.code ~= 0 then
    vim.notify(diff.stderr, vim.log.levels.ERROR)
    return nil
  end
  local items, file = {}, nil
  for _, line in ipairs(vim.split(diff.stdout, '\n')) do
    if line:match '^%+%+%+ ' then
      local path = line:match '^%+%+%+ b/(.+)$'
      file = path and (root .. '/' .. path)
    else
      local start, count, context = line:match '^@@ %-%S+ %+(%d+),?(%d*) @@ ?(.*)$'
      if start and file then
        local kind = count == '0' and 'deleted' or 'changed'
        items[#items + 1] = {
          filename = file,
          lnum = math.max(tonumber(start), 1),
          text = context ~= '' and (kind .. ': ' .. context) or kind,
        }
      end
    end
  end
  return items
end

--- Hunks across every file of a multi-file step. gitsigns only diffs buffers it has attached to, so this asks git
--- instead: base against the working tree, which includes saved but uncommitted edits.
local function step_hunks(step, locs)
  if not state.tour.base then return end
  local files, seen = {}, {}
  for _, loc in ipairs(locs) do
    if not seen[loc.file] then
      seen[loc.file] = true
      files[#files + 1] = loc.file
    end
  end
  local args = vim.list_extend({ state.tour.base, '--' }, files)
  local items = diff_items(args)
  if not items then return end
  state.hunks_poll = (state.hunks_poll or 0) + 1
  vim.fn.setqflist({}, ' ', { title = ('Hunks: step %d, %s'):format(state.current, step.title), items = items })
  vim.cmd 'copen | wincmd p'
end

local function tab_valid(tab) return tab and vim.api.nvim_tabpage_is_valid(tab) end

local function to_main_tab()
  if tab_valid(state.main_tab) then vim.api.nvim_set_current_tabpage(state.main_tab) end
end

--- Close the tabs the previous step opened. A tab whose buffer can't be abandoned stays open.
local function close_step_tabs()
  to_main_tab()
  for _, tab in pairs(state.loc_tabs) do
    if tab ~= state.main_tab and tab_valid(tab) then
      pcall(vim.cmd.tabclose, vim.api.nvim_tabpage_get_number(tab))
    end
  end
  state.loc_tabs = {}
end

local function open_loc_tab(loc)
  vim.cmd(('tabedit +%d %s'):format(loc.line or 1, vim.fn.fnameescape(loc.file)))
  vim.cmd 'normal! zz'
  M.open_sidebar()
  return vim.api.nvim_get_current_tabpage()
end

--- Open the current step's locations: the first in the tour's tab, each other in a tab of its own. The quickfix
--- list, in the tour's tab, holds every location's hunks.
local function enter_step(step, locs)
  close_step_tabs()
  if #locs == 0 then return end
  M.show(locs[1].file, locs[1].line)
  if #locs == 1 then
    if state.tour.base then M.file_hunks() end
    return
  end
  step_hunks(step, locs)
  state.loc_tabs[1] = state.main_tab
  for k = 2, #locs do
    state.loc_tabs[k] = open_loc_tab(locs[k])
  end
  to_main_tab()
end

--- Switch to location `j` of the current step, reopening its tab if it was closed.
function M.goto_loc(j)
  if not has_tour() then return end
  local step = state.tour.steps[state.current]
  if not step then return end
  local locs = step_locations(step)
  local loc = locs[j]
  if not loc then return end
  state.loc = j
  if j == 1 then
    to_main_tab()
    if #locs == 1 then M.show(loc.file, loc.line) end
  elseif tab_valid(state.loc_tabs[j]) then
    vim.api.nvim_set_current_tabpage(state.loc_tabs[j])
  else
    state.loc_tabs[j] = open_loc_tab(loc)
  end
  render()
end

--- Keep the sidebar's ▶ on the location whose tab the user switched to with gt or a click.
local function sync_loc_with_tab()
  local tab = vim.api.nvim_get_current_tabpage()
  for j, loc_tab in pairs(state.loc_tabs) do
    if loc_tab == tab and j ~= state.loc then
      state.loc = j
      return render()
    end
  end
end

function M.goto(i)
  if not has_tour() then return end
  local step = state.tour.steps[i]
  if not step then return end
  state.current = i
  state.loc = 1
  render()
  enter_step(step, step_locations(step))
end

local function cycle_loc(delta)
  if not has_tour() then return end
  local step = state.tour.steps[state.current]
  local count = step and #step_locations(step) or 0
  if count > 1 then M.goto_loc((state.loc - 1 + delta) % count + 1) end
end

function M.next_loc() cycle_loc(1) end

function M.prev_loc() cycle_loc(-1) end

function M.current() return state.current end

function M.next()
  if has_tour() then M.goto(math.min(state.current + 1, #state.tour.steps)) end
end

function M.prev()
  if has_tour() then M.goto(math.max(state.current - 1, 1)) end
end

--- Fill the quickfix list with one entry per hunk of `git diff base HEAD`.
function M.load_hunks()
  if not has_tour() or not state.tour.base then return end
  local items = diff_items { state.tour.base, 'HEAD' }
  if not items then return end
  vim.fn.setqflist({}, ' ', { title = 'PR hunks vs ' .. state.tour.base:sub(1, 10), items = items })
end

--- Side-by-side diff of the current file against the tour's base; call again to close it.
function M.toggle_diff()
  if not has_tour() then return end
  if not state.tour.base then return vim.notify('This tour has no base to diff against', vim.log.levels.WARN) end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)):match '^gitsigns://' then
      vim.api.nvim_win_close(win, true)
      vim.cmd 'diffoff!'
      return
    end
  end
  local win = code_win()
  if not win then return end
  vim.api.nvim_set_current_win(win)
  require('gitsigns').diffthis(state.tour.base, { vertical = true })
end

--- Highlight changed lines and words in place, without opening a split.
function M.toggle_inline()
  if has_tour() and not state.tour.base then
    return vim.notify('This tour has no base to diff against', vim.log.levels.WARN)
  end
  state.inline_on = not state.inline_on
  local gitsigns = require 'gitsigns'
  gitsigns.toggle_linehl(state.inline_on)
  gitsigns.toggle_word_diff(state.inline_on)
end

--- Point gitsigns at the tour's base and list its hunks. A tour without a base walks the code as it is: gitsigns
--- goes back to its default (the index, so only edits made during the tour show) and the PR hunks are cleared.
local function apply_base()
  require('gitsigns').change_base(state.tour.base, true)
  state.applied_base = state.tour.base
  if state.tour.base then return M.load_hunks() end
  vim.fn.setqflist({}, 'f')
  vim.cmd 'cclose'
end

function M.start(path)
  state.path = vim.fn.fnamemodify(path, ':p')
  state.tour = read_tour(state.path)
  state.current = 1
  state.main_tab = vim.api.nvim_get_current_tabpage()
  state.loc_tabs = {}
  vim.api.nvim_create_autocmd('TabEnter', {
    group = vim.api.nvim_create_augroup('tour_tabs', { clear = true }),
    callback = sync_loc_with_tab,
  })
  if state.tour.root then vim.cmd.cd(vim.fn.fnameescape(state.tour.root)) end
  apply_base()
  -- Shadows the default tag-stack ]t/[t, but only once a tour is running.
  vim.keymap.set('n', ']t', M.next, { desc = 'Next tour step' })
  vim.keymap.set('n', '[t', M.prev, { desc = 'Previous tour step' })
  vim.keymap.set('n', ']f', M.next_loc, { desc = "Next file in the tour step" })
  vim.keymap.set('n', '[f', M.prev_loc, { desc = "Previous file in the tour step" })
  M.open_sidebar()
  M.goto(1)
end

--- Re-read the tour file after Claude edits it, keeping the current step.
function M.reload()
  if not state.path then return end
  state.tour = read_tour(state.path)
  if state.tour.base ~= state.applied_base then apply_base() end
  state.current = math.min(state.current, math.max(#state.tour.steps, 1))
  local step = state.tour.steps[state.current]
  state.loc = math.min(state.loc, math.max(step and #step_locations(step) or 1, 1))
  render()
end

return M
