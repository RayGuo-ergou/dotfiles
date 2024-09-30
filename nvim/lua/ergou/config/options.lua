-- This file is automatically loaded by plugins.core
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.clipboard = '' -- Sync with system clipboard
-- Set clipboard after nvim start
---@see discuession https://github.com/LazyVim/LazyVim/discussions/4112
vim.schedule(function()
  vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
end)
opt.comments = 's1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,fb:-,fb:•' ---@see https://neovim.io/doc/user/options.html#'comments'
opt.completeopt = 'menu,menuone,noselect'
opt.conceallevel = 0 -- Hide nothing in markdown files
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = 'jcroqlnt' -- tcqj
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.ignorecase = true -- Ignore case
opt.inccommand = 'nosplit' -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = 'a' -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { 'en' }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = 'screen'
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = 'longest:full,full' -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.linebreak = true -- Wrap lines at convenient points
opt.fillchars = {
  foldopen = '',
  foldclose = '',
  -- fold = "⸱",
  fold = ' ',
  foldsep = ' ',
  -- diff = "╱",
  eob = ' ',
}
-- Set pumblend to 0 so the cmp menu is not transparent
-- The transparent menu caused the icon not showing properly if any text is under that row
opt.pumblend = 0

if vim.fn.has('nvim-0.10') == 1 then
  opt.smoothscroll = true
end

-- Folding
opt.foldlevel = 99
opt.foldmethod = 'indent'
opt.foldlevelstart = 99
opt.foldenable = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Set filetype to `bigfile` for files larger than 1.5 MB
-- Only vim syntax will be enabled (with the correct filetype)
-- LSP, treesitter and other ft plugins will be disabled.
-- mini.animate will also be disabled.
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

-- Disable deprecation messages
-- vim.deprecate = function() end

vim.filetype.add({
  extension = {
    rasi = 'rasi',
    rofi = 'rasi',
    wofi = 'rasi',
    http = 'http',
    zsh = 'bash',
    sh = 'bash',
  },
  filename = {
    ['vifmrc'] = 'vim',
  },
  pattern = {
    ['%.env%.[%w_.-]+'] = 'bash',
  },
})
