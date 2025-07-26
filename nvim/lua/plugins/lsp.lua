--- @class (exact) LspConfig
--- @field lspconfig? vim.lsp.Config
--- @field enabled? boolean

--- @class (exact) ServerConfig
--- @field language_servers table<string, LspConfig>
--- @field linters string[]
--- @field formatters string[]

--- @param config ServerConfig
local function create_server_config(config)
  --- @type string[]
  local ensure_installed = {}

  vim.list_extend(ensure_installed, config.linters or {})
  vim.list_extend(ensure_installed, config.formatters or {})
  vim.list_extend(ensure_installed, vim.tbl_keys(config.language_servers or {}))

  --- @type table<string, LspConfig>
  local enabled_ls = {}

  for name, cfg in pairs(config.language_servers or {}) do
    if cfg.enabled ~= false then
      enabled_ls[name] = cfg
    end
  end

  return ensure_installed, enabled_ls
end

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
        opts = {
          ensure_installed = {}, -- already handled by mason-tool-installer
          automatic_installation = false,
          automatic_enable = true,
        },
      },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
      {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-neo-tree/neo-tree.nvim",
        },
        opts = {},
      },
      "b0o/SchemaStore.nvim",
    },
    config = function()
      --- Setup keymaps for LSP clients
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
            desc = "Show LSP declaration",
          })
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
        end,
      })

      --- diagnostics
      vim.diagnostic.config({
        float = { border = "rounded" },
        severity_sort = true,
        jump = {
          float = true,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
      })

      --- lsp config
      local schema_store = require("schemastore")
      local ensure_installed, enabled_ls = create_server_config({
        linters = {
          "cspell",
          "eslint_d",
          "golangci-lint",
          "hadolint",
          "ruff",
          "markdownlint-cli2",
          "shellcheck",
        },
        formatters = {
          "gofumpt",
          "goimports",
          "gomodifytags",
          "prettier",
          "shfmt",
          "stylua",
          "markdown-toc",
        },
        language_servers = {
          dockerls = {},
          bashls = {
            lspconfig = {
              settings = {
                bashIde = {
                  shellcheckPath = "", -- disable shellcheck because nvim-lint is used
                  shfmt = {
                    path = "", -- disable shfmt because conform is used
                  },
                },
              },
            },
          },
          docker_compose_language_service = {},
          marksman = {},
          jsonls = {
            lspconfig = {
              settings = {
                json = {
                  schemas = schema_store.json.schemas({
                    select = {
                      "package.json",
                      ".eslintrc",
                      "tsconfig.json",
                      "pnpm Workspace (pnpm-workspace.yaml)",
                      "prettierrc.json",
                      "nest-cli",
                    },
                  }),
                  format = {
                    enable = true,
                  },
                  validate = { enable = true },
                },
              },
            },
          },
          yamlls = {
            lspconfig = {
              settings = {
                schemas = schema_store.yaml.schemas({
                  select = {
                    "docker-compose.yml",
                    "GitHub Workflow",
                  },
                }),
                redhat = { telemetry = { enabled = false } },
                yaml = {
                  keyOrdering = false,
                  format = {
                    enable = true,
                  },
                  validate = true,
                  schemaStore = {
                    -- Must disable built-in schemaStore support to use
                    -- schemas from SchemaStore.nvim plugin
                    enable = false,
                    -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                    url = "",
                  },
                },
              },
            },
          },
          lua_ls = {},
          ts_ls = {},
          gopls = {},
          html = {},
          cssls = {},
          graphql = {},
          golangci_lint_ls = {},
          ruff = {
            lspconfig = {
              on_attach = function(client, _)
                client.server_capabilities.hoverProvider = false
              end,
            },
          },
          basedpyright = {
            lspconfig = {
              settings = {
                basedpyright = {
                  disableOrganizeImports = true, -- Using Ruff's import organizer
                },
                python = {
                  analysis = {
                    ignore = { "*" }, -- Ignore all files by default
                  },
                },
              },
            },
          },
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      for ls, cfg in pairs(enabled_ls) do
        local capabilities = cmp_nvim_lsp.default_capabilities()
        local lspconfig = cfg.lspconfig or {}

        if lspconfig.capabilities then
          capabilities = vim.tbl_deep_extend("force", {}, capabilities, lspconfig.capabilities)
        end

        lspconfig.capabilities = capabilities

        vim.lsp.config(ls, lspconfig)
      end
    end,
  },
}
