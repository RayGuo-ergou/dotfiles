return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters = {
        phpcbf = {
          prepend_args = { "--standard=vendor/php-cs/ruleset.xml" },
        },
      },
      formatters_by_ft = {
        vue = { "eslint_d" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        css = { "eslint_d" },
        scss = { "eslint_d" },
        html = { "eslint_d" },
        json = { "eslint_d" },
        yaml = { "eslint_d" },
        markdown = { "eslint_d" },
        graphql = { "eslint_d" },
        lua = { "stylua" },
        python = { "isort", "black" },
        php = { "phpcbf" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>fm", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range" })
  end,
}
