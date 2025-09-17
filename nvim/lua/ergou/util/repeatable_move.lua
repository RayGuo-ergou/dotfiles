---@class ergou.util.repeatable_move
local M = {}

-- Cache for the treesitter textobjects repeatable_move module
local ts_repeat_move = nil

-- Initialize the module and cache it
local function get_ts_repeat_move()
  if ts_repeat_move then
    return ts_repeat_move
  end

  local ok_old, module_old = pcall(require, 'nvim-treesitter.textobjects.repeatable_move')
  if ok_old then
    ts_repeat_move = module_old
    return ts_repeat_move
  end

  -- new is `nvim-treesitter-textobjects` instead of `nvim-treesitter.textobjects`
  local ok_new, module_new = pcall(require, 'nvim-treesitter-textobjects.repeatable_move')
  if ok_new then
    ts_repeat_move = module_new
    return ts_repeat_move
  end

  return nil
end

-- Check if the new make_repeatable_move function exists
local function has_make_repeatable_move()
  local module = get_ts_repeat_move()
  return module and type(module.make_repeatable_move) == 'function'
end

---Creates a repeatable move function using ts-repeat-move module if available
---@param move_fn fun(opts: {forward: boolean}, ...: any): any A movement function that takes direction options and additional arguments
---@return fun(opts: {forward: boolean}, ...: any): any # Returns the original function or a repeatable version
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

M.setup_diagnostic = function()
  local map = vim.keymap.set
  -- Override the default text objects next and previous
  local repeat_next, repeat_prev = ergou.repeatable_move.get_repeat_functions()
  if repeat_next and repeat_prev then
    map({ 'n', 'x', 'o' }, ';', repeat_next)
    map({ 'n', 'x', 'o' }, ',', repeat_prev)
  end

  -- Create diagnostic move function with severity
  local function create_diagnostic_move(severity)
    return ergou.repeatable_move.create_repeatable_move(function(opt)
      if opt.forward then
        vim.diagnostic.jump({ count = 1, severity = severity })
      else
        vim.diagnostic.jump({ count = -1, severity = severity })
      end
    end)
  end
  -- Default diagnostic navigation (without severity)
  local diagnostic_repeat = create_diagnostic_move(nil)
  map({ 'n', 'x', 'o' }, ']d', function()
    diagnostic_repeat({ forward = true })
  end, { desc = 'Next Diagnostic' })
  map({ 'n', 'x', 'o' }, '[d', function()
    diagnostic_repeat({ forward = false })
  end, { desc = 'Prev Diagnostic' })

  -- Diagnostic navigation for specific severities
  local diagnostic_error_repeat = create_diagnostic_move(vim.diagnostic.severity.ERROR)
  map({ 'n', 'x', 'o' }, ']e', function()
    diagnostic_error_repeat({ forward = true })
  end, { desc = 'Next Error' })
  map({ 'n', 'x', 'o' }, '[e', function()
    diagnostic_error_repeat({ forward = false })
  end, { desc = 'Prev Error' })

  local diagnostic_warn_repeat = create_diagnostic_move(vim.diagnostic.severity.WARN)
  map({ 'n', 'x', 'o' }, ']w', function()
    diagnostic_warn_repeat({ forward = true })
  end, { desc = 'Next Warning' })
  map({ 'n', 'x', 'o' }, '[w', function()
    diagnostic_warn_repeat({ forward = false })
  end, { desc = 'Prev Warning' })
end
return M
