---@see lazyvim https://github.com/LazyVim/LazyVim/blob/6f91b406ddf2b298efe43f6467ca0a9103881a88/lua/lazyvim/plugins/lsp/init.lua#L259-L296
return {
  'mason-org/mason.nvim',
  cmd = 'Mason',
  keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
  build = ':MasonUpdate',
  opts_extend = { 'ensure_installed' },
  opts = {
    ensure_installed = {
      'stylua',
      'eslint_d',
      'phpcbf',
      'cspell',
      'phpcs',
      'prettierd',
      'blade-formatter',
      'ts_query_ls',
      'yamlfmt',
      'sleek',
    },
    ui = {
      border = 'rounded',
    },
  },
  ---@param opts MasonSettings | {ensure_installed: string[]}
  config = function(_, opts)
    require('mason').setup(opts)
    local mr = require('mason-registry')
    mr:on('package:install:success', function()
      vim.defer_fn(function()
        -- trigger FileType event to possibly load this newly installed LSP server
        require('lazy.core.handler.event').trigger({
          event = 'FileType',
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)

    for _, tool in ipairs(opts.ensure_installed) do
      if not mr.is_installed(tool) then
        vim.notify('Installing ' .. tool .. '...')
        local p = mr.get_package(tool)
        p:install()
      end
    end
  end,
}
