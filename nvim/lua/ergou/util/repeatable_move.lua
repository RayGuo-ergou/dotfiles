--- Utility module for handling repeatable move functionality migration
--- This module provides backwards compatibility between the old `make_repeatable_move_pair`
--- and the new `make_repeatable_move` functions in nvim-treesitter-textobjects.
---
--- The new API (if available) uses a single function that receives an opts table
--- with a 'forward' boolean parameter, while the old API uses separate functions.
---
--- Preferred usage (new convention):
---   local move_repeat = ergou.repeatable_move.create_repeatable_move(function(opts)
---     if opts.forward then
---       -- forward movement logic
---     else  
---       -- backward movement logic
---     end
---   end)
---   map('n', ']x', function() move_repeat({ forward = true }) end)
---   map('n', '[x', function() move_repeat({ forward = false }) end)
---
--- Legacy usage (backward compatibility):
---   local forward, backward = ergou.repeatable_move.create_repeatable_move_pair(forward_fn, backward_fn)
---   map('n', ']x', forward)
---   map('n', '[x', backward)

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
    -- No treesitter textobjects available, return the function as-is
    return move_fn
  end

  if has_make_repeatable_move() then
    -- Use the new make_repeatable_move pattern directly
    return module.make_repeatable_move(move_fn)
  else
    -- Fall back to creating separate functions and wrapping them
    if module.make_repeatable_move_pair then
      local forward_repeat, backward_repeat = module.make_repeatable_move_pair(
        function(...) move_fn({ forward = true }, ...) end,
        function(...) move_fn({ forward = false }, ...) end
      )
      return function(opts, ...)
        if opts.forward then
          forward_repeat(...)
        else
          backward_repeat(...)
        end
      end
    else
      -- Fallback to the original function if no repeatable move functionality is available
      return move_fn
    end
  end
end

-- Create a repeatable move pair using the appropriate method
-- If the new make_repeatable_move exists, use it with the new pattern
-- Otherwise, fall back to the old make_repeatable_move_pair
-- NOTE: This function is deprecated in favor of create_repeatable_move
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