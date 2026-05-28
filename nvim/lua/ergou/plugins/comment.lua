return {
  {
    'folke/ts-comments.nvim',
    opts = {
      lang = {
        blade = {
          '{{-- %s --}}',
          program = '// %s',
          php_statement = '// %s',
        },
        vue = {
          '<!-- %s -->',
          script_element = '// %s',
        },
      },
    },
    event = 'LazyFile',
  },
}
