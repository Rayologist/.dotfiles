return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  ---@type CatppuccinOptions
  opts = {
    flavour = "macchiato",
    float = {
      transparent = true,
      solid = false,
    },
    no_italic = true,
    transparent_background = true,
    integrations = {
      lsp_trouble = true,
      mason = true,
      fidget = true,
      harpoon = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      indent_blankline = {
        enabled = false,
        -- scope_color = 'text',
        -- colored_indent_levels = false,
      },
    },
    custom_highlights = function(colors)
      return {
        CmpGhostText = { fg = colors.mantle },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
