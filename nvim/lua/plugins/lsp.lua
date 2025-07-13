return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {},
      },
      {
        "mason-org/mason-lspconfig.nvim",
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
          ensure_installed = {
            "prettier",
            "stylua",
            "isort",
            "black",
            "gofumpt",
            "eslint_d",
            "ruff",
            "golangci-lint",
            "cspell",
            "hadolint", -- dockerfile linter
          },
        },
      },
      "hrsh7th/cmp-nvim-lsp",
      {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-neo-tree/neo-tree.nvim",
        },
        opts = {},
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(e)
          local builtin = require("telescope.builtin")

          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = e.buf, desc = "Hover" })
          vim.keymap.set("n", "gd", builtin.lsp_definitions, {
            buffer = e.buf,
            desc = "Show LSP definitions",
          })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
            buffer = e.buf,
            desc = "Show LSP definitions",
          })
          vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = e.buf, desc = "Rename variable" })
          vim.keymap.set(
            { "n", "v" },
            "gra",
            vim.lsp.buf.code_action,
            { buffer = e.buf, desc = "Show available code actions" }
          )
          vim.keymap.set("n", "grr", builtin.lsp_references, {
            buffer = e.buf,
            desc = "Show LSP references",
          })
          vim.keymap.set("n", "gri", builtin.lsp_implementations, {
            buffer = e.buf,
            desc = "Show LSP implementations",
          })
          vim.keymap.set("n", "grt", builtin.lsp_type_definitions, {
            buffer = e.buf,
            desc = "Show LSP type definitions",
          })
          vim.keymap.set("n", "gO", builtin.lsp_document_symbols, {
            buffer = e.buf,
            desc = "Show LSP document symbols",
          })
          vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, {
            buffer = e.buf,
            desc = "Show signature help",
          })
        end,
      })

      -- Add border to the diagnostic popup window
      vim.diagnostic.config({
        float = { border = "rounded" },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
      })

      -- Add the border on hover and on signature help popup window

      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )

      require("mason-lspconfig").setup({
        ensure_installed = {
          "yamlls",
          "lua_ls",
          "pyright",
          "ts_ls",
          "gopls",
          "html",
          "cssls",
          "graphql",
        },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,
        },
        automatic_enable = true,
      })
    end,
  },
}
