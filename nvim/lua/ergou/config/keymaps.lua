-- key mapping
local map = vim.keymap.set

-- better left/right
map({ 'o', 'v', 'n' }, '<leader>l', '$', { noremap = true, silent = true })
map({ 'o', 'v', 'n' }, '<leader>h', '^', { noremap = true, silent = true })

-- action on entire buffer
map('n', 'dae', 'ggVGd', { noremap = true, silent = true, desc = 'Delete entire file' })
map('n', 'yae', 'ggVGy', { noremap = true, silent = true, desc = 'Yank entire file' })
map('n', 'cae', 'ggVG"_c', { noremap = true, silent = true, desc = 'Change entire file' })
map('n', 'vae', 'ggVG', { noremap = true, silent = true, desc = 'Select entire file' })

-- Disable highlight for search
map('n', '<C-n>', '<cmd>nohl<CR>', { noremap = true, silent = true })

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

-- Clear search highlight
map('i', '<C-n>', '<esc><cmd>nohl<CR>', { noremap = true, silent = true })

-- save file
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- better up/down
map({ 'n', 'x' }, 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, silent = true })
map({ 'n', 'x' }, 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, silent = true })

-- buffers
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
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

map('n', '[q', vim.cmd.cprev, { desc = 'Previous quickfix' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next quickfix' })

-- quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- highlights under cursor
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })

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
map('n', '<leader>bd', require('ergou.util').ui.bufremove, { desc = 'Delete Buffer' })
map('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })
-- tabs
-- map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
-- map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
-- map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
-- map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
-- map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
-- map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- Toggle Quickfix
map('n', '<leader>qf', function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd('cclose')
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd('copen')
  end
end, { desc = 'Toggle Quickfix' })

-- Toggle wrap or unwrap
map('n', '<leader>tw', function()
  if vim.wo.wrap then
    vim.wo.wrap = false
  else
    vim.wo.wrap = true
  end
end, { desc = 'Toggle Wrap' })
