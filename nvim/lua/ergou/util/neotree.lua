--- @class ergou.util.neotree
local M = {}

function M.copy_selector(state)
  -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
  -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
  local node = state.tree:get_node()
  local filepath = node:get_id()
  local filename = node.name
  local modify = vim.fn.fnamemodify

  local results = {
    filepath,
    modify(filepath, ':.'),
    modify(filepath, ':~'),
    filename,
    modify(filename, ':r'),
    modify(filename, ':e'),
  }

  vim.ui.select({
    '1. Absolute path: ' .. results[1],
    '2. Path relative to CWD: ' .. results[2],
    '3. Path relative to HOME: ' .. results[3],
    '4. Filename: ' .. results[4],
    '5. Filename without extension: ' .. results[5],
    '6. Extension of the filename: ' .. results[6],
  }, { prompt = 'Choose to copy to clipboard:' }, function(choice)
    if choice then
      local i = tonumber(choice:sub(1, 1))
      if i then
        local result = results[i]
        -- @see https://neovim.io/doc/user/options.html#clipboard-unnamedplus
        vim.fn.setreg('+', result)
        vim.notify('Copied: ' .. result)
      else
        vim.notify('Invalid selection')
      end
    else
      vim.notify('Selection cancelled')
    end
  end)
end

function M.left_movement(state)
  local node = state.tree:get_node()
  if node.type == 'directory' and node:is_expanded() then
    require('neo-tree.sources.filesystem').toggle_directory(state, node)
  else
    require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
  end
end

function M.right_movement(state)
  local node = state.tree:get_node()
  if node.type == 'directory' then
    if not node:is_expanded() then
      require('neo-tree.sources.filesystem').toggle_directory(state, node)
    elseif node:has_children() then
      require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
    end
  else
    state.commands.open(state)
  end
end

return M
