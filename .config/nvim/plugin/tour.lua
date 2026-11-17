-- Commands for lua/tour.lua. All take `bar` so Claude can chain them over the socket.
local function command(name, fn, opts)
  vim.api.nvim_create_user_command(name, fn, vim.tbl_extend('force', { bar = true }, opts or {}))
end

command('Tour', function(o) require('tour').start(o.args) end, { nargs = 1, complete = 'file', desc = 'Start a tour from a JSON file' })
command('TourReload', function() require('tour').reload() end, { desc = 'Re-read the tour file' })
command('TourGoto', function(o) require('tour').goto(tonumber(o.args)) end, { nargs = 1, desc = 'Go to tour step N' })
command('TourNext', function() require('tour').next() end, { desc = 'Next tour step' })
command('TourPrev', function() require('tour').prev() end, { desc = 'Previous tour step' })
command('TourLocNext', function() require('tour').next_loc() end, { desc = 'Next file in the tour step' })
command('TourLocPrev', function() require('tour').prev_loc() end, { desc = 'Previous file in the tour step' })
command('TourShow', function(o) require('tour').show(o.fargs[1], tonumber(o.fargs[2])) end, { nargs = '+', complete = 'file', desc = 'Open FILE [LINE] in the code window' })
command('TourSidebar', function() require('tour').toggle_sidebar() end, { desc = 'Toggle the tour sidebar' })
command('TourDiff', function() require('tour').toggle_diff() end, { desc = 'Toggle a side-by-side diff against the tour base' })
command('TourInline', function() require('tour').toggle_inline() end, { desc = 'Toggle inline changed-line and word highlights' })
command('TourHunks', function() require('tour').load_hunks() end, { desc = 'Reload the quickfix list of PR hunks' })
command('TourFileHunks', function() require('tour').file_hunks() end, { desc = "Quickfix list of the current file's hunks" })
