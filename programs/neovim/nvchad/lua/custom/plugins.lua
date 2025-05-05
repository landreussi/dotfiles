local plugins = {
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

        -- devops
        "hcl",
        "terraform",
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
          -- The default doesn't work, so we need to override it.
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
            -- Mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
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

            vim.g.rustfmt_autosave = 1
            vim.g.rustfmt_fail_silently = 0
          end,
          on_init = function(client)
            local path = client.workspace_folders[1].name

            if path == vim.fn.expand("~/projects/tm") then
              client.config.settings["rust-analyzer"].cargo.buildScripts.overrideCommand = {
                "bazel", "build", "--@rules_rust//:error_format=json", "//...",
                "--noshow_progress", "--ui_event_filters=-INFO", "--keep_going"
              }
              client.config.settings["rust-analyzer"].check.overrideCommand = {
                "rust-analyzer-check"
              }
            end

            return true
          end,
        },
      })
    end
  },
  { "folke/trouble.nvim", lazy = false, opts = {}, cmd = "Trouble" },
  "mfussenegger/nvim-dap",
}

return plugins
