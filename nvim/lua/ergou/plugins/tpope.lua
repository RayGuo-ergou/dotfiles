-- This file contains ungrouped tpope plugins,
-- e.g. dadbod has it own group which includes all dadbod related plugins
return {
  {
    'tpope/vim-sleuth',
    event = 'LazyFile',
  },
  {
    'tpope/vim-fugitive',
    cmd = {
      'Git',
      'G',
    },
  },
}
