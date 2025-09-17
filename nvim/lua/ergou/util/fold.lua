--- @class ergou.util.fold
local M = {}

---@class ergou.util.fold.vue_split.Opts: table<string, any>
---@field split_direction? string Direction to split the Vue.js components ('vertical' or 'horizontal'). Default: 'vertical'.
---@field template_first? boolean Order of processing sections (true for template first, false for script first). Default: true.

---@param opts ergou.util.fold.vue_split.Opts
function M.split_vue_components(opts)
  -- Default options
  local default_opts = {
    split_direction = 'vertical', -- or 'horizontal'
    template_first = true, -- true for template->script, false for script->template
  }

  opts = vim.tbl_deep_extend('force', default_opts, opts or {})

  -- Helper function to get all script elements
  local function get_script_elements(root)
    local script_elements = {}
    for node in root:iter_children() do
      if node:type() == 'script_element' then
        table.insert(script_elements, node)
      end
    end
    return script_elements
  end

  -- Function to focus on specific node(s)
  local function focus_node(win, nodes)
    vim.api.nvim_win_call(win, function()
      -- Close all folds
      vim.cmd('normal! zM')

      -- Handle single node or multiple nodes
      if type(nodes) ~= 'table' or nodes.range then
        -- Single node case (either direct node or nodes.range exists)
        local node = type(nodes) == 'table' and nodes or nodes
        local start_row = node:range()
        vim.api.nvim_win_set_cursor(win, { start_row + 1, 0 })
        vim.cmd('normal! zO')
      else
        -- Multiple nodes case
        for _, node in ipairs(nodes) do
          local start_row = node:range()
          vim.api.nvim_win_set_cursor(win, { start_row + 1, 0 })
          vim.cmd('normal! zO')
        end
      end

      -- Center the view on the opened section
      vim.cmd('normal! zz')
    end)
  end

  -- Check if multiple windows are already open
  if #vim.api.nvim_list_wins() > 1 then
    vim.notify('Please close other windows first', vim.log.levels.WARN)
    return
  end

  -- Get current buffer and window
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()

  -- Check if current file is a Vue file
  local filetype = vim.bo.filetype
  if filetype ~= 'vue' then
    vim.notify('Not a Vue file', vim.log.levels.WARN)
    return
  end

  -- Get parser and root node
  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then
    vim.notify('Cannot find treesitter parser', vim.log.levels.ERROR)
    return
  end
  local tree = parser:parse()[1]
  local root = tree:root()

  -- Check if root is document
  if root:type() ~= 'document' then
    vim.notify('Invalid syntax tree: root is not document', vim.log.levels.WARN)
    return
  end

  -- Find template and script elements
  local template_element = nil
  local script_elements = get_script_elements(root)

  for node in root:iter_children() do
    if node:type() == 'template_element' then
      if template_element then
        vim.notify('Multiple template elements found', vim.log.levels.WARN)
        return
      end
      template_element = node
    end
  end

  -- Check if both template and script exist
  if not template_element then
    vim.notify('No template element found', vim.log.levels.WARN)
    return
  end
  if #script_elements == 0 then
    vim.notify('No script element found', vim.log.levels.WARN)
    return
  end

  -- Create new window
  local split_cmd = opts.split_direction == 'horizontal' and 'split' or 'vsplit'
  vim.cmd(split_cmd)

  -- Get both windows
  local windows = vim.api.nvim_list_wins()
  local win1, win2 = windows[1], windows[2]

  -- Set up windows based on template_first option
  if opts.template_first then
    focus_node(win1, template_element)
    focus_node(win2, script_elements)
  else
    focus_node(win1, script_elements)
    focus_node(win2, template_element)
  end

  -- Return to original window
  vim.api.nvim_set_current_win(winnr)
end

return M
