return {
  "akinsho/toggleterm.nvim",
  opts = {},
  config = function(_, opts)
    require('toggleterm').setup(opts)

    local width = vim.o.columns
    local height = vim.o.lines
    local win_width = math.floor(width * 0.95)
    local win_height = math.floor(height * 0.95)

    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit --use-config-dir ~/.config/lazygit/",
      direction = "float",
      float_opts = {
        border = "rounded",
        width = win_width,
        height = win_height,
      },
      hidden = true,
    })

    vim.keymap.set("n", "<leader>lg", function()
      lazygit:toggle()
    end, {})
  end
}
