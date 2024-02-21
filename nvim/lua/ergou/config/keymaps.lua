-- key mapping
local map = vim.keymap.set

-- better left/right
map({ 'o', 'v' }, 'L', '$', { noremap = true, silent = true })
map({ 'o', 'v' }, 'H', '^', { noremap = true, silent = true })
map('n', '<leader>h', '^', { noremap = true, silent = true })
map('n', '<leader>l', '$', { noremap = true, silent = true })

-- action on entire buffer
map('n', 'dae', 'ggVGd', { noremap = true, silent = true, desc = 'Delete entire file' })
map('n', 'yae', 'ggVGy', { noremap = true, silent = true, desc = 'Yank entire file' })
map('n', 'cae', 'ggVGc', { noremap = true, silent = true, desc = 'Change entire file' })

-- Disable highlight for search
map('n', '<C-n>', '<cmd>nohl<CR>', { noremap = true, silent = true })

-- Change without yanking
map({ 'n', 'x' }, 'c', '"_c', { noremap = true, silent = true })
map({ 'n', 'x' }, 'C', '"_C', { noremap = true, silent = true })

-- Find next alias
map('n', '<leader>1', '*', { noremap = true, silent = true })
map('n', '<leader>2', '#', { noremap = true, silent = true })

-- Add a new line from cursor (Not feel comfortable with this keybind)
map('n', '<leader>k', 'i<CR><esc>', { noremap = true, silent = true, desc = 'Add a new line from cursor' })

-- exit visual mode
map('v', '<leader><leader>', '<esc>', { noremap = true, silent = true })

-- Exit insert mode
map('i', 'jj', '<esc>', { noremap = true, silent = true })

-- Clear search highlight
map('i', '<C-n>', '<esc><cmd>nohl<CR>', { noremap = true, silent = true })

-- save file
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- better up/down
map({ 'n', 'x' }, 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true, silent = true })
map({ 'n', 'x' }, 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
-- map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
-- map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
-- map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
-- map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Use <leader>hjkl to move window
map('n', '<leader>wh', '<C-w>h', { desc = 'Go to left window', remap = true })
map('n', '<leader>wj', '<C-w>j', { desc = 'Go to lower window', remap = true })
map('n', '<leader>wk', '<C-w>k', { desc = 'Go to upper window', remap = true })
map('n', '<leader>wl', '<C-w>l', { desc = 'Go to right window', remap = true })
map('n', '<leader>wo', '<C-w>o', { desc = 'Close other windows', remap = true })

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ':m \'>+1<cr>gv=gv', { desc = 'Move down' })
map('v', '<A-k>', ':m \'<-2<cr>gv=gv', { desc = 'Move up' })

-- buffers
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
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

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- highlights under cursor
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })

-- windows
map('n', '<leader>ww', '<C-W>p', { desc = 'Other window', remap = true })
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete window', remap = true })
map('n', '<leader>w-', '<C-W>s', { desc = 'Split window below', remap = true })
map('n', '<leader>w|', '<C-W>v', { desc = 'Split window right', remap = true })
map('n', '<leader>-', '<C-W>s', { desc = 'Split window below', remap = true })
map('n', '<leader>|', '<C-W>v', { desc = 'Split window right', remap = true })

-- tabs
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- floating terminal
map('n', '<c-/>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>', { desc = 'Terminal (root dir)' })
map('n', '<c-_>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>', { desc = 'which_key_ignore' })
map('i', '<c-/>', '<Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>', { desc = 'Terminal (root dir)' })
map('i', '<c-_>', '<Esc><Cmd>Texe v:count1 . "ToggleTerm"<CR>', { desc = 'which_key_ignore' })

-- Terminal Mappings
map('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
map('t', 'jj', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
map('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
map('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
map('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
map('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
map('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
map('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

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
