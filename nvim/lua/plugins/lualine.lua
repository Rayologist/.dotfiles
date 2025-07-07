-- Copied from: https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/utils/lualine.lua
local function getLuaLineTheme()
  local C = require("catppuccin.palettes").get_palette()
  local M = require("catppuccin.palettes").get_palette("macchiato")
  local O = require("catppuccin").options
  local bg = O.transparent_background and "NONE" or C.mantle

  local catppuccin = {}

  -- local y = { bg = C.maroon, fg = C.base }
  -- local z = { bg = C.flamingo, fg = C.mantle }

  local y = { bg = C.surface0, fg = C.blue }
  local z = { bg = C.blue, fg = C.mantle }

  catppuccin.normal = {
    a = { bg = C.blue, fg = C.mantle, gui = "bold" },
    b = { bg = C.surface0, fg = C.blue },
    c = { bg = bg, fg = C.text },

    x = { bg = bg, fg = C.overlay0 },
    y = y,
    z = z,
  }

  catppuccin.insert = {
    a = { bg = C.maroon, fg = C.base, gui = "bold" },

    y = y,
    z = z,
  }

  catppuccin.terminal = {
    a = { bg = C.green, fg = C.base, gui = "bold" },
    -- b = { bg = C.surface0, fg = C.green },
    y = y,
    z = z,
  }

  catppuccin.command = {
    a = { bg = C.peach, fg = C.base, gui = "bold" },
    -- b = { bg = C.surface0, fg = C.peach },

    y = y,
    z = z,
  }

  catppuccin.visual = {
    a = { bg = C.mauve, fg = C.base, gui = "bold" },
    -- b = { bg = C.surface0, fg = C.mauve },

    y = y,
    z = z,
  }

  catppuccin.replace = {
    a = { bg = C.red, fg = C.base, gui = "bold" },
    -- b = { bg = C.surface0, fg = C.red },

    y = y,
    z = z,
  }

  catppuccin.inactive = {
    a = { bg = bg, fg = C.blue },
    b = { bg = bg, fg = C.surface1, gui = "bold" },
    c = { bg = bg, fg = C.overlay0 },
  }

  return catppuccin
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local theme = getLuaLineTheme()
    return {
      options = {
        theme = theme,
        component_separators = "",
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {
            "neo-tree",
            "undotree",
          },
        }
      },
      sections = {
        lualine_a = {
          {
            "mode",
            icon = {
              "",
              align = "left",
            },
            separator = { left = "", right = "" },
          },
        },
        lualine_b = {
          {
            "filetype",
            separator = "",
            icon_only = true,
            colored = false,
            padding = { left = 2, right = 0 },
          },
          {
            "filename",
            symbols = { modified = "", readonly = " 󰌾" },
            padding = { left = 0, right = 1 },
            -- separator = { left = '', right = ''},
          },
        },
        lualine_c = {
          {
            "diagnostics",
          },
        },
        lualine_x = {
          {
            "branch",
            icon = "",
            fmt = function(str)
              str = str:gsub("CU%-(.-)_", "CU-")
              if #str > 20 then
                str = str:sub(1, 9) .. "..." .. str:sub(-8)
              end
              return str
            end,
          },
          {
            "diff",
            padding = { left = 0, right = 1 },
          },
          "encoding",
        },
        lualine_y = {
          {
            "lsp_status",
            symbols = {
              separator = " | ",
              done = "",
              spinner = {},
            },
            -- ignore_lsp = { "copilot" },
          },
        },
        lualine_z = {
          {
            "progress",
            icon = " ",
            padding = {
              left = 1,
              right = 0.75,
            },
          },
          {
            "location",
            separator = { right = "" },
          },
        },
      },
    }
  end,
}
