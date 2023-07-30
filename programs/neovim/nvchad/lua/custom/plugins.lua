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
  { "rust-lang/rust.vim", lazy = false },
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
        				-- Enable completion triggered by <c-x><c-o>
        				vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        				-- Mappings.
        				-- See `:help vim.lsp.*` for documentation on any of the below functions
        				local bufopts = { noremap=true, silent=true, buffer=bufnr }
        				vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        				vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        				vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        				vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        				vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        				vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        				vim.keymap.set('n', '<leader>wl', function()
        					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        				end, bufopts)
        				vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
        				vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        				vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        				vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        				vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)

                vim.g.rustfmt_autosave = 1
                vim.g.rustfmt_command = 'cargo fmt'
                vim.g.rustfmt_fail_silently = 0
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
