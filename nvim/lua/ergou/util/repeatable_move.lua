---@class ergou.util.repeatable_move
local M = {}

-- Cache for the treesitter textobjects repeatable_move module
local ts_repeat_move = nil

-- Initialize the module and cache it
local function get_ts_repeat_move()
  if ts_repeat_move then
    return ts_repeat_move
  end

  local ok, module = pcall(require, 'nvim-treesitter.textobjects.repeatable_move')
  if ok then
    ts_repeat_move = module
    return ts_repeat_move
  end

  return nil
end

-- Check if the new make_repeatable_move function exists
local function has_make_repeatable_move()
  local module = get_ts_repeat_move()
  return module and type(module.make_repeatable_move) == 'function'
end

-- Create a repeatable move using the new convention
-- Takes a single function that receives { forward = boolean } opts
-- Returns a function that takes { forward = boolean } opts
function M.create_repeatable_move(move_fn)
  local module = get_ts_repeat_move()
  if not module then
    return move_fn
  end

  if has_make_repeatable_move() then
    return module.make_repeatable_move(move_fn)
  else
    if module.make_repeatable_move_pair then
      local forward_repeat, backward_repeat = module.make_repeatable_move_pair(function(...)
        move_fn({ forward = true }, ...)
      end, function(...)
        move_fn({ forward = false }, ...)
      end)
      return function(opts, ...)
        if opts.forward then
          forward_repeat(...)
        else
          backward_repeat(...)
        end
      end
    else
      return move_fn
    end
  end
end

function M.get_repeat_functions()
  local module = get_ts_repeat_move()
  if not module then
    return nil, nil
  end

  return module.repeat_last_move_next, module.repeat_last_move_previous
end

return M
