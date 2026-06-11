vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn = "120"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 5
vim.opt.termguicolors = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.opt.foldenable = false

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_set_keymap("n", "<C-S>", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
vim.api.nvim_set_keymap("n", "<C-Q>", ":q<CR>", { noremap = true, silent = true, desc = "Quit file" })
vim.api.nvim_set_keymap("n", "<C-l>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.api.nvim_set_keymap("n", "<C-h>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
vim.api.nvim_set_keymap("n", "<leader>l", ":bnext<bar>bd#<CR>", { noremap = true, silent = true, desc = "Next buffer and close previous" })
vim.api.nvim_set_keymap("n", "<leader>h", ":bprevious<bar>bd#<CR>", { noremap = true, silent = true, desc = "Previous buffer and close previous" })
vim.api.nvim_set_keymap("n", "<C-d>", ":bd<CR>", { noremap = true, silent = true, desc = "Delete buffer" })
vim.api.nvim_set_keymap("t", "<C-w>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>o", ":Neotree focus<CR>", { noremap = true, silent = true })

require("config.lazy")

require("bufferline").setup({
  options = {
    name_formatter = function(buf)
      return vim.fn.fnamemodify(buf.path, ":t")
    end,
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        text_align = "center",
      },
    },
  },
})

require("ibl").setup()
require("gitsigns").setup()

local builtin = require("telescope.builtin")
vim.keymap.set("n", ",e", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<space>", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Telescope resume last picker" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = ev.buf, desc = "Telescope lsp definitions" })
  end,
})

vim.cmd([[colorscheme tokyonight-moon]])
