-- key mapping
local map = vim.keymap.set

-- Lazy vim
map('n', '<leader>lv', '<cmd>Lazy<cr>', { desc = 'Lazy Vim' })

-- better left/right
map({ 'o', 'v', 'n' }, 'L', '$', { noremap = true, silent = true })
map({ 'o', 'v', 'n' }, 'H', '^', { noremap = true, silent = true })

-- action on entire buffer
map('n', 'dae', 'ggVGd', { noremap = true, silent = true, desc = 'Delete entire file' })
map('n', 'yae', 'ggVGy', { noremap = true, silent = true, desc = 'Yank entire file' })
map('n', 'cae', 'ggVG"_c', { noremap = true, silent = true, desc = 'Change entire file' })
map('n', 'vae', 'ggVG', { noremap = true, silent = true, desc = 'Select entire file' })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move Down', silent = true })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move Up', silent = true })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down', silent = true })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up', silent = true })
map('v', '<A-j>', ':m \'>+1<cr>gv=gv', { desc = 'Move Down', silent = true })
map('v', '<A-k>', ':m \'<-2<cr>gv=gv', { desc = 'Move Up', silent = true })

-- Disable highlight for search
map('n', '<C-n>', '<cmd>nohlsearch<CR>', { noremap = true, silent = true })

-- Change without yanking
map({ 'n', 'x' }, 'c', '"_c', { noremap = true, silent = true })
map({ 'n', 'x' }, 'C', '"_C', { noremap = true, silent = true })

-- Find next alias
map('n', '<leader>1', '*', { noremap = true, silent = true })
map('n', '<leader>2', '#', { noremap = true, silent = true })

-- Add a new line from cursor (Not feel comfortable with this keybind)
map('n', '<leader>K', 'i<CR><esc>', { noremap = true, silent = true, desc = 'Add a new line from cursor' })

-- exit visual mode
map('v', '<leader><leader>', '<esc>', { noremap = true, silent = true })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  'n',
  '<leader>ur',
  '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>',
  { desc = 'Redraw / Clear hlsearch / Diff Update' }
)

-- save file
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- better up/down
map({ 'n', 'x' }, 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, silent = true })
map({ 'n', 'x' }, 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, silent = true })

-- buffers
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
map('n', '<leader>bh', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', '<leader>bl', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', '\'Nn\'[v:searchforward].\'zv\'', { expr = true, desc = 'Next search result' })
map('x', 'n', '\'Nn\'[v:searchforward]', { expr = true, desc = 'Next search result' })
map('o', 'n', '\'Nn\'[v:searchforward]', { expr = true, desc = 'Next search result' })
map('n', 'N', '\'nN\'[v:searchforward].\'zv\'', { expr = true, desc = 'Prev search result' })
map('x', 'N', '\'nN\'[v:searchforward]', { expr = true, desc = 'Prev search result' })
map('o', 'N', '\'nN\'[v:searchforward]', { expr = true, desc = 'Prev search result' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- new file
map('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

map('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location List' })
map('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix List' })

-- set in trouble.lua
-- map('n', '[q', vim.cmd.cprev, { desc = 'Previous quickfix' })
-- map('n', ']q', vim.cmd.cnext, { desc = 'Next quickfix' })

-- quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- highlights under cursor
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })
map('n', '<leader>uI', '<cmd>InspectTree<cr>', { desc = 'Inspect Tree' })

-- windows
map('n', '<leader>ww', '<C-W>p', { desc = 'Other window', remap = true })
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete window', remap = true })
map('n', '<leader>wo', '<C-W>o', { desc = 'Delete other windows', remap = true })
map('n', '<leader>w{', '<C-W>x', { desc = 'Swap window', remap = true })
map('n', '<leader>w}', '<C-W>x', { desc = 'Swap window', remap = true })
map('n', '<leader>w-', '<C-W>s', { desc = 'Split window below', remap = true })
map('n', '<leader>w|', '<C-W>v', { desc = 'Split window right', remap = true })
map('n', '<leader>w=', '<C-W>=', { desc = 'Equal window height and width', remap = true })
map('n', '<leader>-', '<C-W>s', { desc = 'Split window below', remap = true })
map('n', '<leader>|', '<C-W>v', { desc = 'Split window right', remap = true })

--buffer
map('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })
-- tabs
map('n', '<leader><tab><tab>', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
map('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'Close Other Tabs' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
map('n', '<leader><tab>n', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- Copy file name
map('n', '<leader>cy', ergou.copy.copy_filename, { desc = 'Copy Filename' })
map('n', '<leader>gy', ergou.copy.copy_git_branch, { desc = 'Copy Branch Name' })

-- Clear search and stop snippet on escape
map({ 'i', 'n', 's' }, '<esc>', function()
  vim.cmd('nohlsearch')
  local luasnip = require('luasnip')
  if luasnip.expand_or_jumpable() then
    luasnip.unlink_current()
  end
  if vim.snippet then
    vim.snippet.stop()
  end
  return '<esc>'
end, { expr = true, desc = 'Escape and clear snippet' })

-- Vue split
map('n', '<leader>vs', function()
  ergou.fold.split_vue_components({
    split_direction = 'vertical',
    template_first = true,
  })
end, { desc = 'Split Vue components' })

---Toggles---
ergou.toggle.quickfix():map('<leader>qf')
ergou.toggle.inlay_hints():map('<leader>ih')
ergou.toggle.wrap():map('<leader>tw')
ergou.toggle.diagnostics():map('<leader>ud')
ergou.toggle.treesitter():map('<leader>uT')
ergou.toggle.spelling():map('<leader>us')
ergou.toggle.zen():map('<leader>Z')
ergou.toggle.zoom():map('<leader>wm'):map('<leader>z')
