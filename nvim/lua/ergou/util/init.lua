local LazyUtil = require('lazy.core.util')

---@class ergou.util: LazyUtilCore
---@field public icons ergou.util.icons
---@field public lazy ergou.util.lazy
---@field public lsp ergou.util.lsp
---@field public root ergou.util.root
---@field public snippet ergou.util.snippet
---@field public cmp ergou.util.cmp
---@field public pick ergou.util.pick
---@field public toggle ergou.util.toggle
---@field public copy ergou.util.copy
---@field public fold ergou.util.fold
---@field public repeatable_move ergou.util.repeatable_move
---@field public treesitter ergou.util.treesitter
---@field public string ergou.util.string
local M = {}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require('ergou.util.' .. k)
    return t[k]
  end,
})

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

function M.is_win()
  return vim.uv.os_uname().sysname:find('Windows') ~= nil
end

---@param name string
function M.get_plugin(name)
  return require('lazy.core.config').spec.plugins[name]
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  path = path and '/' .. path or ''
  return plugin and (plugin.dir .. path)
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = require('lazy.core.config').spec.plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require('lazy.core.plugin')
  return Plugin.values(plugin, 'opts', false)
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  local Config = require('lazy.core.config')
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyLoad',
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

--- @param table table
--- @param keys string[]
function M.table_walk(table, keys)
  local result = table
  for _, key in ipairs(keys) do
    if type(result) == 'table' then
      result = result[key]
    else
      return nil
    end
  end
  return result
end

--- @param bufnr number
function M.get_float_win_from_buf(bufnr)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      local win_config = vim.api.nvim_win_get_config(win)
      if win_config.relative ~= '' then
        return win
      end
    end
  end
  return nil
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes('<c-G>u', true, true, true)
function M.create_undo()
  if vim.api.nvim_get_mode().mode == 'i' then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, 'n', false)
  end
end

M.sql_ft = { 'sql', 'mysql', 'plsql' }

return M
