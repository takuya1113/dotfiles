-- basics
vim.opt.number = true
vim.opt.relativenumber = true
vim.o.termguicolors = true

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
  { "neovim/nvim-lspconfig" },
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

-- TypeScript LSP（typescript-language-server 経由）
vim.lsp.config("ts_ls", {})
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
