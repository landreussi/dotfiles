local plugins = {
  "folke/trouble.nvim",
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },
  {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
          require("nvim-surround").setup({
              -- Configuration here, or leave empty to use defaults
          })
      end
  },
  {
    "ggandor/lightspeed.nvim",
    lazy = false,
  },
  -- Language specific
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- nvim stuff
        "vim",
        "lua",

        -- front
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "vue",
        "svelte",

        -- back
        "rust",
        "go",
        "python",
        "zig",
        "solidity",
      },
    },
  },
  { 
      "simrat39/rust-tools.nvim", 
      lazy = false,
      config = function()
          local rt = require("rust-tools")

          rt.setup({
            server = {
              on_attach = function(_, bufnr)
                -- Hover actions
                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                -- Code action groups
                vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
              end,
            },
          })
      end
  },
  "mfussenegger/nvim-dap",
  -- Isnt working, might try it later...
  -- {
  --   "KadoBOT/nvim-spotify",
  --   requires = 'nvim-telescope/telescope.nvim',
  --   config = function()
  --       local spotify = require'nvim-spotify'
  --
  --       spotify.setup {
  --           -- default opts
  --           status = {
  --               update_interval = 10000, -- the interval (ms) to check for what's currently playing
  --               format = '%s %t by %a' -- spotify-tui --format argument
  --           }
  --       }
  --   end,
  --   run = 'make'
  -- }
}

return plugins
