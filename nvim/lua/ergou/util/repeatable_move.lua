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

-- Create a repeatable move pair using the appropriate method
-- If the new make_repeatable_move exists, use it with the new pattern
-- Otherwise, fall back to the old make_repeatable_move_pair
function M.create_repeatable_move_pair(forward_fn, backward_fn)
  local module = get_ts_repeat_move()
  if not module then
    -- No treesitter textobjects available, return original functions
    return forward_fn, backward_fn
  end

  if has_make_repeatable_move() then
    -- Use the new make_repeatable_move pattern
    local repeatable_forward = module.make_repeatable_move(function(opts, ...)
      if opts.forward then
        forward_fn(...)
      else
        backward_fn(...)
      end
    end)
    
    local function forward_wrapper(...)
      return repeatable_forward({ forward = true }, ...)
    end
    
    local function backward_wrapper(...)
      return repeatable_forward({ forward = false }, ...)
    end
    
    return forward_wrapper, backward_wrapper
  else
    -- Fall back to the old make_repeatable_move_pair
    if module.make_repeatable_move_pair then
      return module.make_repeatable_move_pair(forward_fn, backward_fn)
    else
      -- Fallback to original functions if no repeatable move functionality is available
      return forward_fn, backward_fn
    end
  end
end

-- Get the repeat functions for manual key mapping
function M.get_repeat_functions()
  local module = get_ts_repeat_move()
  if not module then
    return nil, nil
  end
  
  if has_make_repeatable_move() then
    -- New API uses repeat_last_move_next and repeat_last_move_previous
    return module.repeat_last_move_next, module.repeat_last_move_previous
  else
    -- Old API uses the same function names
    return module.repeat_last_move_next, module.repeat_last_move_previous
  end
end

return M