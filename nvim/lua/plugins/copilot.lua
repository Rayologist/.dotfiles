return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      copilot_model = "gpt-4o-copilot",
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-y>",
          dismiss = "<C-n>",
        },
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {},
  },
}
