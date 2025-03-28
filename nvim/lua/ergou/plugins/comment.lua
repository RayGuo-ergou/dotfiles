return {
  'numToStr/Comment.nvim',
  event = 'LazyFile',
  opts = {
    pre_hook = function()
      local ft = require('Comment.ft')
      if vim.bo.filetype == 'blade' then
        -- make html comment {{--%s--}}
        ft.set('html', { '{{--%s--}}', '{{--%s--}}' })
      else
        -- else fallback to default html comment <!--%s-->
        ft.set('html', { '<!--%s-->', '<!--%s-->' })
      end
    end,
  },
  config = function(_, opts)
    local ft = require('Comment.ft')
    -- blade uses php comment for none html part
    ft.set('blade', ft.get('php') or { '//%s', '/*%s*/' })

    require('Comment').setup(opts)
  end,
  keys = {
    {
      'gcc',
    },
  },
}
