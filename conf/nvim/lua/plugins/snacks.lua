return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bufdelete = { enabled = true },
      dim = { enabled = true },
      gitbrowse = { enabled = true },
      picker = { ui_select = true },
      lazygit = { enabled = true },
      terminal = { enabled = true },
    },
    config = function()
      require("snacks.dim").disable()
      require("snacks.picker").setup({ ui_select = true })
    end,
    keys = {
      { "<leader>bd", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
      { "ggh", function() Snacks.gitbrowse.open() end, desc = "Open GitHub" },
      { "<leader>t", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    },
  },
}
