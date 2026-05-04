vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

vim.o.timeout = true
vim.o.timeoutlen = 300

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2 
vim.opt.expandtab = true

vim.o.laststatus = 0
vim.o.showmode = false

-- Caminho onde o lazy vai ficar
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Clona automaticamente se não existir
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

-- Adiciona ao runtime do Neovim
vim.opt.rtp:prepend(lazypath)

-- Setup básico
require("lazy").setup({
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    config = function()
      require("neogit").setup({})
    end
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end
  },
  -- Debug
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "igorlfs/nvim-dap-view",
    },
    config = function()
      local dap = require("dap")
      local dv = require("dap-view")
  
      dv.setup()
  
      dap.listeners.after.event_initialized["dapview"] = function()
        dv.open()
      end
  
      dap.listeners.before.event_terminated["dapview"] = function()
        dv.close()
      end
  
      dap.listeners.before.event_exited["dapview"] = function()
        dv.close()
      end
    end
  },
  -- Base
  { "nvim-lua/plenary.nvim" },

  -- Telescope (busca)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Treesitter (syntax)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  {
    "stevearc/oil.nvim",
    opts = {},
  },

  -- Instalador de LSP
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
  	"mason-org/mason-lspconfig.nvim",
	opts = {},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	}
  },

  -- Autocomplete
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },

  -- Key hints
  {
    "folke/which-key.nvim",
    config = true,
  },

   {
     "rrethy/vim-hexokinase",
     build = "make hexokinase",
     init = function()
         vim.g.Hexokinase_highlighters = { "backgroundfull" }
     end
   },
   { "typicode/bg.nvim", lazy = false },
   {
     "folke/tokyonight.nvim",
     lazy = false,
     priority = 1000,
     opts = {},
   },
   {
     "goolord/alpha-nvim",
     -- dependencies = { 'nvim-mini/mini.icons' },
     dependencies = { 'nvim-tree/nvim-web-devicons' },
     config = function()
       local startify = require("alpha.themes.startify")
       -- available: devicons, mini, default is mini
       -- if provider not loaded and enabled is true, it will try to use another provider
       startify.file_icons.provider = "devicons"
       require("alpha").setup(
         startify.config
       )
     end,
   },
   {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
   }
})

require('lualine').setup()

local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {
[[   .-"""-.   _  _       __   ___        ]], 
[[  ´  ,'''-` | \| |___ __\ \ / (_)_ __   ]],
[[ [  (       | .` / -_) _ \ V /| | '  \  ]],
[[  ,  '...-, |_|\_\___\___/\_/ |_|_|_|_| ]],
[[   '-...-'                              ]],
[[             Neo Vi IMproved            ]],
}


require("lualine").setup({
  options = {
    theme = "nightfly",
    component_separators = { left = '|', right = '|' }
  }
})


require("alpha").setup(dashboard.opts)

vim.cmd.colorscheme("tokyonight-moon")

local dap = require("dap")
local dv = require("dap-view")

dv.setup()

-- abrir/fechar UI automaticamente
dap.listeners.after.event_initialized["dapview"] = function()
  dv.open()
end

dap.listeners.before.event_terminated["dapview"] = function()
  dv.close()
end

dap.listeners.before.event_exited["dapview"] = function()
  dv.close()
end

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>")

vim.keymap.set("n", "<F5>", dap.continue)       -- iniciar / continuar
vim.keymap.set("n", "<F10>", dap.step_over)     -- próxima linha
vim.keymap.set("n", "<F11>", dap.step_into)     -- entrar na função
vim.keymap.set("n", "<F12>", dap.step_out)      -- sair da função
vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { os.getenv("HOME") .. "/.local/share/js-debug/src/dapDebugServer.js", "8123" },
}

dap.configurations.javascript = {
  {
    type = "node2",
    request = "launch",
    name = "manyplug list",

    program = "/home/syntax/work/active/manyplug/bin/manyplug.js",

    cwd = "/home/syntax/work/active/teste/manybot",

    runtimeExecutable = "node",
    args = { "list" },

    console = "integratedTerminal",
  },
}
-- LSP
local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),

  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
})

local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_lsp.default_capabilities()

-- define configs
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
})

vim.lsp.config("pyright", {
  capabilities = capabilities,
})

vim.lsp.config("ts_ls", {
  capabilities = capabilities,
})

vim.lsp.config("bashls", {
  capabilities = capabilities,
})

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
})

vim.lsp.config("clangd", {
  capabilities = capabilities,
})

local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_lsp.default_capabilities()

-- define configs
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
})

vim.lsp.config("pyright", {
  capabilities = capabilities,
})

vim.lsp.config("ts_ls", {
  capabilities = capabilities,
})

vim.lsp.config("bashls", {
  capabilities = capabilities,
})

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
})

vim.lsp.config("clangd", {
  capabilities = capabilities,
})

-- ativa
vim.lsp.enable({
  "lua_ls",
  "pyright",
  "ts_ls",
  "bashls",
  "rust_analyzer",
  "clangd",
})

-- ativa
vim.lsp.enable({
  "lua_ls",
  "pyright",
  "ts_ls",
  "bashls",
  "rust_analyzer",
  "clangd",
})

local wk = require("which-key")

wk.setup({
  preset = "modern",
})

local wk = require("which-key")

wk.add({
  { "<leader>f", group = "Find" },
  { "<leader>l", group = "LSP" },
})

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })

-- Oil
vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Explorer (Oil)" })

-- LSP
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
