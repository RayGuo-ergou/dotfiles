local function detect_browser()
  -- This function attempts to determine if it's running under WSL by checking the command's success
  local wsl_check = os.execute('wsl.exe -l > /dev/nul 2>&1')

  if wsl_check == 0 then
    -- Command succeeded, WSL is present
    return 'powershell.exe', { 'Start-Process' }
  else
    -- Command failed, assuming running on Linux or other environments
    return 'x-www-browser', {}
  end
end

local browser_app, browser_args = detect_browser()
return {
  'chrishrb/gx.nvim',
  keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
  cmd = { 'Browse' },
  init = function()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  submodules = false, -- not needed, submodules are required only for tests
  opts = {
    open_browser_app = browser_app, -- dynamically set based on OS detection
    open_browser_args = browser_args, -- dynamically set based on OS detection
    -- open_browser_app = 'powershell.exe', -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
    -- open_browser_args = { 'Start-Process' }, -- specify any arguments, such as --background for macOS' "open".
    handlers = {
      plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
      github = true, -- open github issues
      brewfile = true, -- open Homebrew formulas and casks
      package_json = true, -- open dependencies from package.json
      search = true, -- search the web/selection on the web if nothing else is found
    },
    handler_options = {
      search_engine = 'google', -- you can select between google, bing, duckduckgo, and ecosia
    },
  },
}
