return {
  "stevearc/conform.nvim",
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      javascript = { "prettier", "eslint_d" },
      typescript = { "prettier", "eslint_d" },
      javascriptreact = { "prettier", "eslint_d" },
      typescriptreact = { "prettier", "eslint_d" },
      svelte = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      graphql = { "prettier" },
      liquid = { "prettier" },
      lua = { "stylua" },
      go = { "gofmt" },
      python = { "isort", "black" },
    },
    format_on_save = {
      lsp_format = "fallback",
      async = false,
      quiet = false,
      timeout_ms = 1000,
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
  },
  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format({
          lsp_format = "fallback",
          async = false,
          quiet = false,
          timeout_ms = 1000,
        })
      end,
      desc = "Format",
    },
  },
}
