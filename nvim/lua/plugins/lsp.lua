return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "mason-org/mason.nvim",
        branch = "v1.x",
        opts = {
          ui = {
            border = "rounded",
          },
        },
      },
      {
        "mason-org/mason-lspconfig.nvim",
        branch = "v1.x",
        opts = {
          ensure_installed = {
            -- lsp
            "yamlls",
            "lua_ls",
            "pyright",
            "ts_ls",
            "gopls",
            "html",
            "cssls",
            "graphql",
          },
          automatic_installation = true,
        },
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

      -- local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "󰋽" }
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        -- vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Add border to the diagnostic popup window
      vim.diagnostic.config({
        update_in_insert = true,
        -- virtual_text = {
        --   prefix = ' ', -- Could be '●', '▎', 'x', '■', , 
        --   current_line = true,
        -- },
        virtual_text = false,
        float = { border = "rounded" },
      })

      -- Add the border on hover and on signature help popup window
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
      }

      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            handlers = handlers,
            capabilities = capabilities,
          })
        end,
      })
    end,
  },
}
