-- basics
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wildmenu = true
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

-- Split below and keep focus on current window
vim.api.nvim_create_user_command("Sp", function(opts)
  if opts.args ~= "" then
    vim.cmd("belowright split " .. vim.fn.fnameescape(opts.args))
  else
    vim.cmd("belowright split")
  end
  vim.cmd("wincmd p")
end, { nargs = "?", complete = "file" })

-- Vertical split right and keep focus on current window
vim.api.nvim_create_user_command("Vsp", function(opts)
  if opts.args ~= "" then
    vim.cmd("belowright vsplit " .. vim.fn.fnameescape(opts.args))
  else
    vim.cmd("belowright vsplit")
  end
  vim.cmd("wincmd p")
end, { nargs = "?", complete = "file" })

-- nvim-tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
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
  ensure_installed = { "lua_ls", "bashls", "jsonls", "yamlls", "ts_ls", "jdtls" },
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

-- Java LSP: PATH または Mason 管理下の jdtls を利用
do
  local mason_jdtls = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
  local jdtls_cmd = nil

  if vim.fn.executable("jdtls") == 1 then
    jdtls_cmd = "jdtls"
  elseif vim.fn.executable(mason_jdtls) == 1 then
    jdtls_cmd = mason_jdtls
  end

  if jdtls_cmd then
    vim.lsp.config("jdtls", {
      cmd = { jdtls_cmd },
    })
    vim.lsp.enable("jdtls")
  else
    vim.schedule(function()
      vim.notify("jdtls が見つかりません。:MasonInstall jdtls 後に nvim を再起動してください。", vim.log.levels.WARN)
    end)
  end
end

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>dn", function()
  vim.diagnostic.goto_next({ float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>dp", function()
  vim.diagnostic.goto_prev({ float = true })
end, { desc = "Prev diagnostic" })

vim.keymap.set("n", "<leader>dt", function()
  local current = vim.diagnostic.config().virtual_text
  local enabled = current ~= false
  vim.diagnostic.config({ virtual_text = not enabled })
end, { desc = "Toggle diagnostic virtual text" })

-- TypeScript/JavaScript/JSON は 2 スペースインデント
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact", "json", "jsonc" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Java は 4 スペースインデント
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "java" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
