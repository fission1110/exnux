require('leap').create_default_mappings()

--- Set leap hl colors
--- LeapMatch, LeapLabelPrimary, LeapLabelSecondary
vim.cmd("highlight link LeapMatch Todo")
vim.cmd("highlight link LeapLabelPrimary Error")
vim.cmd("highlight link LeapLabelSecondary CurSearch")
