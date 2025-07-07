local builtin = require("telescope.builtin")
return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
    },
    "folke/todo-comments.nvim",
  },
  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
          },
          n = {
            ["q"] = actions.close,
            ["db"] = actions.delete_buffer,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    }
  end,
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("fzf")
  end,
  keys = {
    {
      "<leader>ft",
      "<cmd>TodoTelescope<CR>",
      desc = "Find todos",
    },
    {
      "<leader>sr",
      builtin.resume,
      desc = "Resume last search",
    },
    {
      "<leader>sw",
      builtin.live_grep,
      desc = "Search words",
    },
    {
      "<leader>fd",
      function()
        builtin.find_files({
          no_ignore = false,
          hidden = true,
          follow = true,
        })
      end,
      desc = "Find Files",
    },
    {
      "<leader>fk",
      builtin.keymaps,
      desc = "Find keymaps",
    },
    {
      "<leader>fb",
      function()
        builtin.buffers({
          sort_mru = true,
          sort_lastused = true,
          ignore_current_buffer = true,
        })
      end,
      desc = "Find buffers",
    },
    {
      "<leader>fr",
      function()
        builtin.oldfiles({ only_cwd = true })
      end,
      desc = "Find recent files",
    },
    {
      "<leader>fw",
      function()
        local word = vim.fn.expand("<cword>")
        builtin.grep_string({ search = word })
      end,
      desc = "Grep (word under cursor)",
    },
    {
      "<leader>fh",
      builtin.help_tags,
      desc = "Help pages",
    },
    {
      "<leader>fg",
      builtin.git_files,
      desc = "Find files (git files)",
    },
    {
      "<leader>fs",
      function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end,
      desc = "Grep",
    },
    {
      "<leader>fj",
      function()
        builtin.jumplist()
      end,
      desc = "Find jump list",
    },
  },
}
