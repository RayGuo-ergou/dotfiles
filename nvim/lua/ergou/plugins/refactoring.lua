return {
  'ThePrimeagen/refactoring.nvim',
  config = true,
  keys = {
    {
      '<leader>rf',
      function()
        require('refactoring').select_refactor({ show_success_message = true })
      end,
      desc = 'Picking a refactoring',
    },
  },
}
