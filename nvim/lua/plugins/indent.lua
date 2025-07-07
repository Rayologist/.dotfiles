return {
  {
    "tpope/vim-sleuth",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = function()
      -- local highlight = {
      --   "RainbowYellow",
      --   "RainbowBlue",
      --   "RainbowOrange",
      --   "RainbowGreen",
      --   "RainbowViolet",
      --   "RainbowRed",
      --   "RainbowCyan",
      -- }
      -- local hooks = require("ibl.hooks")
      -- Create the highlight groups in the highlight setup hook, so they are reset
      -- every time the color scheme changes
      -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      --   vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      --   vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      --   vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      --   vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      --   vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      --   vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      --   vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      -- end)

      -- Register a hook that modifies how virtual text is rendered in insert mode
      -- hooks.register(hooks.type.VIRTUAL_TEXT, function(tick, bufnr, row, virtual_text)
      --   -- Only modify virtual text in insert mode
      --   if vim.api.nvim_get_mode().mode:find("i") then
      --     -- Modify virtual text to avoid cursor rendering issues
      --     -- This example returns empty virtual text near the cursor row
      --     local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1
      --     if cursor_row == row then
      --       return {}
      --     end
      --   end
      --
      --   return virtual_text -- Return unmodified for normal mode
      -- end)

      -- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      -- vim.g.rainbow_delimiters = { highlight = highlight }

      local js = { "object", "object_pattern" }

      ---@module "indent-blankline"
      ---@type ibl.config
      return {
        scope = {
          -- highlight = highlight,
          show_end = false,
          show_start = false,
          include = {
            node_type = {
              lua = { "table", "table_constructor" },
              tsx = js,
              javascript = js,
              typescript = js,
            },
          },
        },
        indent = {
          char = "▏",
        },
      }
    end,
  },
  -- {
  --   "hiphish/rainbow-delimiters.nvim",
  --   ---@type rainbow_delimiters.config
  --   opts = {
  --     query = {
  --       javascript = 'rainbow-parens',
  --       tsx = 'rainbow-parens'
  --     }
  --   },
  --   main = 'rainbow-delimiters.setup',
  -- }
}
