-- basics
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wildmenu = true
vim.o.termguicolors = true
vim.g.mapleader = ","
vim.opt.expandtab = true
vim.opt.autoread = true

-- macOS クリップボードと常に連携（yank/delete が OS クリップボードへ）
vim.opt.clipboard = "unnamedplus"

local external_reload_group = vim.api.nvim_create_augroup("ExternalFileReload", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose" }, {
  group = external_reload_group,
  command = "if mode() != 'c' | checktime | endif",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = external_reload_group,
  callback = function()
    vim.notify("File reloaded from disk", vim.log.levels.INFO)
  end,
})

vim.keymap.set("n", "<F5>", "<cmd>checktime<CR>", { desc = "Reload file changed outside Neovim" })


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
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "html", "xml", "javascript", "typescript", "tsx" },
        auto_install = true,
        highlight = {
          enable = true,
        },
      })
    end,
  },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_and_accept", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = false,
        },
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets" },
        providers = {
          snippets = {
            opts = {
              use_label_description = true,
            },
          },
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },
  },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    },
  },
})

-- kanagawa
local kanagawa = require("kanagawa")
local transparent_enabled = true
local selection_highlights = {
  Visual = { bg = "#41507a", bold = true },
  VisualNOS = { bg = "#41507a", bold = true },
}
local transparent_groups = {
  "Normal",
  "NormalFloat",
  "SignColumn",
  "EndOfBuffer",
  "FoldColumn",
  "LineNr",
  "CursorLineNr",
}

local function apply_kanagawa_background()
  kanagawa.setup({
    transparent = transparent_enabled,
  })
  vim.cmd.colorscheme("kanagawa")

  if transparent_enabled then
    for _, group in ipairs(transparent_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
  end

  for group, opts in pairs(selection_highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

apply_kanagawa_background()

local function set_transparent_background(enabled)
  transparent_enabled = enabled
  apply_kanagawa_background()
  vim.notify(
    enabled and "Neovim background: transparent" or "Neovim background: opaque",
    vim.log.levels.INFO
  )
end

vim.api.nvim_create_user_command("NvimTransparentToggle", function()
  set_transparent_background(not transparent_enabled)
end, {})

vim.api.nvim_create_user_command("NvimTransparentOn", function()
  set_transparent_background(true)
end, {})

vim.api.nvim_create_user_command("NvimTransparentOff", function()
  set_transparent_background(false)
end, {})

vim.keymap.set("n", "<leader>tt", "<cmd>NvimTransparentToggle<CR>", { desc = "Toggle transparent background" })

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
  ensure_installed = { "lua_ls", "bashls", "jsonls", "yamlls", "ts_ls", "jdtls", "pyright" },
})

local blink_lsp_capabilities = require("blink.cmp").get_lsp_capabilities()

local function enable_lsp(server, config)
  config = config or {}
  config.capabilities = vim.tbl_deep_extend("force", {}, blink_lsp_capabilities, config.capabilities or {})
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

enable_lsp("lua_ls", {
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

enable_lsp("bashls")
enable_lsp("jsonls")
enable_lsp("yamlls")
enable_lsp("ts_ls")
enable_lsp("pyright")

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
    enable_lsp("jdtls", {
      cmd = { jdtls_cmd },
    })
  else
    vim.schedule(function()
      vim.notify("jdtls が見つかりません。:MasonInstall jdtls 後に nvim を再起動してください。", vim.log.levels.WARN)
    end)
  end
end

-- Diagnostic keymaps
local function format_line_diagnostics()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

  if vim.tbl_isempty(diagnostics) then
    return nil
  end

  local severity_names = {
    [vim.diagnostic.severity.ERROR] = "ERROR",
    [vim.diagnostic.severity.WARN] = "WARN",
    [vim.diagnostic.severity.INFO] = "INFO",
    [vim.diagnostic.severity.HINT] = "HINT",
  }

  local lines = {}
  for _, diagnostic in ipairs(diagnostics) do
    local parts = { severity_names[diagnostic.severity] or "UNKNOWN", diagnostic.message }

    if diagnostic.source then
      table.insert(parts, "(" .. diagnostic.source .. ")")
    end

    table.insert(lines, table.concat(parts, " "))
  end

  return table.concat(lines, "\n")
end

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

vim.keymap.set("n", "<leader>dy", function()
  local text = format_line_diagnostics()

  if not text then
    vim.notify("Current line has no diagnostics", vim.log.levels.WARN)
    return
  end

  vim.fn.setreg("+", text)
  vim.notify("Copied current line diagnostics")
end, { desc = "Copy line diagnostics" })

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
function _G.dotfiles_java_indent()
  local line = vim.fn.getline(vim.v.lnum)
  if line:match("^%s*%)%s*[,;]*%s*$") then
    local prev = vim.fn.prevnonblank(vim.v.lnum - 1)
    if prev > 0 and vim.fn.getline(prev):match("%(%s*$") then
      return vim.fn.indent(prev)
    end
  end

  if vim.fn.exists("*GetJavaIndent") == 1 then
    return vim.fn["GetJavaIndent"]()
  end

  return vim.fn.cindent(vim.v.lnum)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "java" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.indentexpr = "v:lua.dotfiles_java_indent()"
  end,
})
