return {
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
    },
    keys = {
      {
        "]t",
        function()
          require('todo-comments').jump_next()
        end,
        desc = "Next todo comment"
      },
      {
        "[t",
        function()
          require('todo-comments').jump_prev()
        end,
        desc = "Next todo comment",
      }
    }
  }
}
