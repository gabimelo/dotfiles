return {
  { "ixru/nvim-markdown" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "bash", "lua", "python", "typescript" },
    },
  },
  {
    "williamboman/mason.nvim",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      vim.lsp.enable({ "pyright", "ts_ls" })
    end,
  },
}
