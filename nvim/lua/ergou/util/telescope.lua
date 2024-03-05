local Util = require('ergou.util')

---@class ergou.util.telescope.opts
---@field cwd? string|boolean
---@field show_untracked? boolean

---@class ergou.util.telescope
---@overload fun(builtin:string, opts?:ergou.util.telescope.opts)
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.telescope(...)
  end,
})

-- this will return a function that calls telescope.
-- cwd will default to ergou.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
---@param builtin string
---@param opts? ergou.util.telescope.opts
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend('force', { cwd = Util.root() }, opts or {}) --[[@as ergou.util.telescope.opts]]
    if builtin == 'files' then
      if vim.uv.fs_stat((opts.cwd or vim.uv.cwd()) .. '/.git') then
        opts.show_untracked = true
        builtin = 'git_files'
      else
        builtin = 'find_files'
      end
    end
    if opts.cwd and opts.cwd ~= vim.uv.cwd() then
      ---@diagnostic disable-next-line: inject-field
      opts.attach_mappings = function(_, map)
        map('i', '<a-c>', function()
          local action_state = require('telescope.actions.state')
          local line = action_state.get_current_line()
          M.telescope(
            params.builtin,
            vim.tbl_deep_extend('force', {}, params.opts or {}, { cwd = false, default_text = line })
          )()
        end)
        return true
      end
    end

    require('telescope.builtin')[builtin](opts)
  end
end

function M.config_files()
  return Util.telescope('find_files', { cwd = vim.fn.stdpath('config') })
end

function M.harpoon(harpoon_files)
  local conf = require('telescope.config').values
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end

return M
