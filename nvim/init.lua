-- basics
vim.opt.number = true
vim.opt.relativenumber = true
vim.o.termguicolors = true
vim.g.mapleader = ","

-- macOS クリップボードと常に連携（yank/delete が OS クリップボードへ）
vim.opt.clipboard = "unnamedplus"


-- lazy.nvim bootstrap（最小）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  { "rebelot/kanagawa.nvim", priority = 1000 },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
})

-- kanagawa（透過）
require("kanagawa").setup({
  transparent = true,
})
vim.cmd.colorscheme("kanagawa")

-- 透過の追い打ち（Normal/Float を明示的に透明化）
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- nvim-tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

-- LSP
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "bashls", "jsonls", "yamlls", "ts_ls" },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
    },
  },
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("bashls")
vim.lsp.enable("jsonls")
vim.lsp.enable("yamlls")
vim.lsp.enable("ts_ls")

-- TypeScript/JavaScript は 2 スペースインデント
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
