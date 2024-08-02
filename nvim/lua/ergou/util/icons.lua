--- @class ergou.util.icons
local icons = {
  kinds = {
    File = ' ',
    Module = ' ',
    Namespace = ' ',
    Package = ' ',
    Class = ' ',
    Method = ' ',
    Property = ' ',
    Field = ' ',
    Constructor = ' ',
    Enum = ' ',
    Interface = ' ',
    Function = ' ',
    Variable = ' ',
    Constant = ' ',
    String = ' ',
    Number = ' ',
    Boolean = ' ',
    Array = ' ',
    Object = ' ',
    Key = ' ',
    Null = ' ',
    EnumMember = ' ',
    Struct = ' ',
    Event = ' ',
    Operator = ' ',
    TypeParameter = ' ',
  },
  -- diagnostics = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' },
  diagnostics = { Error = '●', Warn = '●', Hint = '●', Info = '●' },
  git = {
    added = ' ',
    modified = ' ',
    removed = ' ',
  },
  file = {
    symbols = {
      modified = ' ●', -- Text to show when the buffer is modified
      alternate_file = '#', -- Text to show to identify the alternate file
      directory = '', -- Text to show when the buffer is a directory
    },
  },
  ---@type table<string, string|string[]> {icon, text_highlight, line/num_highlight}
  dap = {
    Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
    Breakpoint = ' ',
    BreakpointCondition = ' ',
    BreakpointRejected = { ' ', 'DiagnosticError' },
    LogPoint = '.>',
  },
  others = {
    rest = '',
    clock = ' ',
    maximize = ' ',
    terminal = ' ',
    npm = ' ',
  },
}

return icons
