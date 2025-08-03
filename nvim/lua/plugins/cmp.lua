return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "onsails/lspkind.nvim",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.3",
      build = "make install_jsregexp",
    },
    { "saadparwaiz1/cmp_luasnip" },
  },
  config = function()
    local cmp = require("cmp")
    local ls = require("luasnip")
    local lspkind = require("lspkind")
    local defaults = require("cmp.config.default")()

    require("luasnip.loaders.from_vscode").lazy_load()

    vim.keymap.set({ "i", "s" }, "<C-l>", function()
      ls.jump(1)
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-h>", function()
      ls.jump(-1)
    end, { silent = true })

    cmp.setup({
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      snippet = {
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = "menu,menuone,preview",
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-i>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
        ["<C-y>"] = cmp.config.disable,
        ["<C-n>"] = cmp.config.disable,
      }),
      sources = cmp.config.sources({
        { name = "lazydev", group_index = 0 },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "nvim_lsp_signature_help" },
      }, {
        { name = "buffer" },
      }),
      sorting = defaults.sorting,
      formatting = {
        fields = { "kind", "abbr", "menu" },
        expandable_indicator = true,
        format = lspkind.cmp_format({
          mode = "symbol",
          maxwidth = 50,
          ellipsis_char = "...",
          show_labeldetails = true,
          preset = "codicons",

          ---@param entry cmp.Entry
          ---@param vim_item vim.CompletedItem
          before = function(entry, vim_item)
            local source = ""

            local name = ({
              nvim_lsp = "LSP",
              buffer = "BUF",
              lazydev = "LZDV",
              nvim_lsp_signature_help = "SIG",
            })[entry.source.name]

            if name ~= nil then
              source = name
            else
              source = string.upper(entry.source.name)
            end

            vim_item.menu = "[" .. source .. "]"
            return vim_item
          end,
        }),
      },
    })

    local custom_mapping = {
      ["<C-j>"] = {
        c = function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end,
      },
      ["<C-k>"] = {
        c = function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end,
      },
      ["<Tab>"] = {
        c = cmp.mapping.confirm({ select = false }),
      },
    }

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(custom_mapping),
      sources = {
        { name = "buffer" },
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(custom_mapping),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
      matching = {
        disallow_fuzzy_matching = false,
        disallow_fullfuzzy_matching = false,
        disallow_partial_fuzzy_matching = false,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
        disallow_symbol_nonprefix_matching = false,
      },
    })
  end,
}
