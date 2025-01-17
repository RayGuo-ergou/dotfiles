local function augroup(name)
  return vim.api.nvim_create_augroup('ergou_' .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('gitsigns_refresh'),
  pattern = '*lazygit',
  callback = function()
    if package.loaded['gitsigns.actions'] then
      require('gitsigns.actions').refresh()
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup('resize_splits'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('last_loc'),
  callback = function(event)
    local exclude = { 'gitcommit' }
    local modify = vim.fn.fnamemodify
    local filename = modify(vim.api.nvim_buf_get_name(event.buf), ':t')
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].ergou_last_loc or filename == 'COMMIT_EDITMSG' then
      return
    end
    vim.b[buf].ergou_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('go_top_on_enter'),
  pattern = 'COMMIT_EDITMSG',
  callback = function()
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close_with_q'),
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'neotest-output',
    'checkhealth',
    'neotest-summary',
    'neotest-output-panel',
    'grug-far',
    'dbout',
    'DressingInput',
    'query',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'kulala://ui',
  group = vim.api.nvim_create_augroup('kulala_ui_close_with_q', { clear = true }),
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('wrap_spell'),
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown', 'http' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup('auto_create_dir'),
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('json_conceal'),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- disable noice markdown keys gx and k
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'noice' },
  group = augroup('noice_disable_keys'),
  callback = function(event)
    vim.b[event.buf].markdown_keys = true
  end,
})

-- After this PR merged, can get win id from ev
---@see PR https://github.com/neovim/neovim/pull/26430
vim.api.nvim_create_autocmd('WinNew', {
  pattern = { '*.vue', '*.ts', '*.js' },
  group = augroup('TS_lsp_float_vue'),
  callback = function(ev)
    local new_win = ergou.get_float_win_from_buf(ev.buf)

    if not new_win then
      return
    end

    -- Use schedule to wait for the window to be open
    vim.schedule(function()
      -- Get the buf to change filetype
      local new_win_buf = vim.bo[vim.api.nvim_win_get_buf(new_win)]
      if new_win_buf.filetype == 'vue' then
        new_win_buf.filetype = 'typescript'
      end
    end)
  end,
})
