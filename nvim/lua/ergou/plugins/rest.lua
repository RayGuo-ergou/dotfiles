---@param callback function
local function find_env(callback)
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local sorters = require('telescope.sorters')
  local actions = require('telescope.actions')
  local actions_state = require('telescope.actions.state')

  local function call_with_selected(prompt_bufnr)
    local selection = actions_state.get_selected_entry(prompt_bufnr)
    actions.close(prompt_bufnr)
    callback(selection.value)
  end

  pickers
    .new({}, {
      prompt_title = 'Select .env file',
      finder = finders.new_oneshot_job({ 'find', '.', '-type', 'f', '-name', '.env*' }),
      sorter = sorters.get_fuzzy_file(),
      attach_mappings = function(_, map)
        map('i', '<CR>', call_with_selected)
        map('n', '<CR>', call_with_selected)
        return true
      end,
    })
    :find()
end
return {
  'rest-nvim/rest.nvim',
  -- Lazy load otherwise it will break tree sitter
  ft = 'http',
  config = function()
    require('rest-nvim').setup({
      -- Open request results in a horizontal split
      result_split_horizontal = false,
      -- Keep the http file buffer above|left when split horizontal|vertical
      result_split_in_place = false,
      -- stay in current windows (.http file) or change to results window (default)
      stay_in_current_window_after_split = false,
      -- Skip SSL verification, useful for unknown certificates
      skip_ssl_verification = false,
      -- Encode URL before making request
      encode_url = true,
      -- Highlight request on run
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        -- toggle showing URL, HTTP info, headers at top the of result window
        show_url = true,
        -- show the generated curl command in case you want to launch
        -- the same request via the terminal (can be verbose)
        show_curl_command = false,
        show_http_info = true,
        show_headers = true,
        -- table of curl `--write-out` variables or false if disabled
        -- for more granular control see Statistics Spec
        show_statistics = false,
        -- executables or functions for formatting response body [optional]
        -- set them to false if you want to disable them
        formatters = {
          json = 'jq',
          html = function(body)
            return vim.fn.system({ 'tidy', '-i', '-q', '-' }, body)
          end,
        },
      },
      -- Jump to request line on run
      jump_to_request = false,
      env_file = 'http.env',
      -- TODO: config telescope somehow it's not working for me
    })
    vim.keymap.set({ 'n' }, '<leader>rs', function()
      find_env(function(file)
        rest.select_env(file)
        print('Using env file: ' .. file)
      end)
    end)
  end,
  keys = {
    {
      '<leader>cr',
      '<Plug>RestNvim',
      mode = { 'n', 'x' },
      desc = '[C]url [R]equest',
    },
    {
      '<leader>cp',
      '<Plug>RestNvimPreview',
      mode = { 'n', 'x' },
      desc = '[C]url [P]review',
    },
  },
}
