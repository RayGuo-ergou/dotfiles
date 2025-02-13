return {
  'tzachar/highlight-undo.nvim',
  event = 'LazyFile',
  opts = {
    ignore_cb = function(buf)
      local bo = vim.bo[buf]

      -- Check for special buffer types
      if bo.buftype ~= '' then
        return true
      end

      -- Check if buffer is modifiable
      if not bo.modifiable then
        return true
      end

      return false
    end,
  },
}
