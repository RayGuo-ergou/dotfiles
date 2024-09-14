---@class ergou.util.lsp.words
local M = {}

---@alias LspWord {from:{[1]:number, [2]:number}, to:{[1]:number, [2]:number}, current?:boolean} 1-0 indexed
M = {}
M.ns = vim.api.nvim_create_namespace('vim_lsp_references')

---@return LspWord[]
function M.get()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return vim.tbl_map(function(extmark)
    local ret = {
      from = { extmark[2] + 1, extmark[3] },
      to = { extmark[4].end_row + 1, extmark[4].end_col },
    }
    if cursor[1] >= ret.from[1] and cursor[1] <= ret.to[1] and cursor[2] >= ret.from[2] and cursor[2] <= ret.to[2] then
      ret.current = true
    end
    return ret
  end, vim.api.nvim_buf_get_extmarks(0, M.ns, 0, -1, { details = true }))
end

---@param words? LspWord[]
---@return LspWord?, number?
function M.at(words)
  for idx, word in ipairs(words or M.get()) do
    if word.current then
      return word, idx
    end
  end
end

function M.jump(count)
  local words = M.get()
  local _, idx = M.at(words)
  if not idx then
    return
  end
  local target = words[idx + count]
  if target then
    vim.api.nvim_win_set_cursor(0, target.from)
  end
end

return M
