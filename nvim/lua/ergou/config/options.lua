local opt = vim.opt

opt.spelllang = { "en" }
opt.spell = true
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.formatoptions = "jcroqlnt" -- tcqj
opt.shiftround = true -- Round indent
opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
