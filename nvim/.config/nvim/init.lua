-- =====================================================
-- NEOVIM CONFIG (single file, cleaned + fixed LSP)
-- Neovim 0.11+
-- =====================================================

vim.g.mapleader = " "

-- =========================
-- OPTIONS
-- =========================

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.termguicolors = true

opt.fileformat = "unix"

vim.o.timeout = true
vim.o.timeoutlen = 300

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.completeopt = { "menu", "menuone", "noselect" }

opt.path:append("**")

opt.wildmenu = true
opt.wildmode = "longest:full,full"

vim.o.laststatus = 3
vim.o.showmode = false

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- =========================
-- LAZY
-- =========================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- =========================
-- PLUGINS
-- =========================

require("lazy").setup({

  -- dependencies
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  -- theme
  { "folke/tokyonight.nvim" },

  -- git
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
  },

  -- ui
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")

      wk.setup({
        preset = "modern",
      })

      wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>l", group = "LSP" },
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          section_separators = { left = "", right = "" },
          component_separators = { left = "|", right = "|" },
        },
      })
    end,
  },

  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[   .-"""-.   _  _       __   ___        ]],
        [[  ´  ,'''-` | \| |___ __\ \ / (_)_ __   ]],
        [[ [  (       | .` / -_) _ \ V /| | '  \  ]],
        [[  ,  '...-, |_|\_\___\___/\_/ |_|_|_|_| ]],
        [[   '-...-'                              ]],
        [[             Neo Vi IMproved            ]],
      }

      require("alpha").setup(dashboard.opts)
    end,
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- oil
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },

  -- autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- hex colors
  {
    "rrethy/vim-hexokinase",
    build = "make hexokinase",
    init = function()
      vim.g.Hexokinase_highlighters = {
        "backgroundfull",
      }
    end,
  },

  { "typicode/bg.nvim", lazy = true },

  -- indent/chunks
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        indent = {
          enable = true,
          style = {
            "#2a2a2a",
          },
        },

        chunk = {
          enable = true,

          duration = 100,
          delay = 20,

          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "┌",
            left_bottom = "└",
            right_arrow = "─",
          },

          style = {
            "#555555",
          },

          use_treesitter = true,
        },
      })
    end,
  },

  -- terminal
  { "voldikss/vim-floaterm" },

  -- move lines
  { "matze/vim-move" },

  -- ========================================
  -- MASON
  -- ========================================
  
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
  
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ts_ls",
        },
      })
    end,
  },
  
  -- ========================================
  -- LSP
  -- ========================================
  
  {
    "neovim/nvim-lspconfig",
  },
  
  -- ========================================
  -- AUTOCOMPLETE
  -- ========================================
  
  {
    "saghen/blink.cmp",
  
    version = "*",
  
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  
    opts = {
      keymap = {
        preset = "enter",
      },
  
      completion = {
        documentation = {
          auto_show = true,
        },
      },
  
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
        },
  
        providers = {
          lsp = {
            score_offset = 100,
          },
  
          path = {
            score_offset = 50,
          },
  
          snippets = {
            score_offset = 25,
          },
  
          buffer = {
            score_offset = 0,
          },
        },
      },
    },
  },

  -- tree
  { 'nvim-tree/nvim-tree.lua' },

})

-- ========================================
-- TREE
-- ========================================

---@type nvim_tree.config
local config = {
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
}
require("nvim-tree").setup(config)

vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>")

-- ========================================
-- LSP CONFIG
-- ========================================

local capabilities =
  require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("lua_ls", {
  capabilities = capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },

      workspace = {
        checkThirdParty = false,
      },
    },
  },
})

vim.lsp.config("pyright", {
  capabilities = capabilities,
})

vim.lsp.config("ts_ls", {
  capabilities = capabilities,
})

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "ts_ls",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = {
      buffer = ev.buf,
    }

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

    vim.keymap.set(
      "n",
      "<leader>lr",
      vim.lsp.buf.rename,
      opts
    )

    vim.keymap.set(
      "n",
      "<leader>la",
      vim.lsp.buf.code_action,
      opts
    )
  end,
})

-- =========================
-- THEME
-- =========================

vim.cmd.colorscheme("syntaxerror")

-- =========================
-- KEYMAPS
-- =========================

vim.keymap.set("n", "dd", '"_dd')
vim.keymap.set("n", "d", '"_d')

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>")

vim.keymap.set(
  "n",
  "<leader>ff",
  "<cmd>Telescope find_files<CR>",
  { desc = "Find Files" }
)

vim.keymap.set(
  "n",
  "<leader>e",
  "<cmd>Oil<CR>",
  { desc = "Explorer" }
)

vim.g.move_map_keys = false

vim.keymap.set("n", "<Esc>j", "<Plug>MoveLineDown")
vim.keymap.set("n", "<Esc>k", "<Plug>MoveLineUp")

-- =========================
-- LSP
-- =========================

-- IMPORTANTE:
-- usa a API nova do Neovim 0.11+
-- vim.lsp.config + vim.lsp.enable
--
-- docs:
-- https://neovim.io/doc/user/lsp.html
--
-- precisa do Neovim >= 0.11
--
-- :checkhealth vim.lsp
-- :LspInfo

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

vim.lsp.config("pyright", {})

vim.lsp.config("ts_ls", {})

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "ts_ls",
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = {
      buffer = ev.buf,
    }

    vim.keymap.set(
      "n",
      "K",
      vim.lsp.buf.hover,
      opts
    )

    vim.keymap.set(
      "n",
      "gd",
      vim.lsp.buf.definition,
      opts
    )

    vim.keymap.set(
      "n",
      "gr",
      vim.lsp.buf.references,
      opts
    )

    vim.keymap.set(
      "n",
      "<leader>lr",
      vim.lsp.buf.rename,
      opts
    )

    vim.keymap.set(
      "n",
      "<leader>la",
      vim.lsp.buf.code_action,
      opts
    )
  end,
})

-- =========================
-- CHECKS
-- =========================

vim.schedule(function()
  vim.notify("hai")
end)
