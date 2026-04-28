{ pkgs, ... }: {
  enable = true;
  extraPackages = with pkgs; [
    vscode-langservers-extracted
    stylua
  ];
  chadrcConfig = ''
    local M = {}
    M.base46 = {
      theme = "gruvchad",
    }
    M.nvdash = {
      load_on_startup = true,
    }
    return M
  '';
  extraPlugins = ''
    return {
      {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
          require("nvim-surround").setup({})
        end,
      },
      {
        "ggandor/lightspeed.nvim",
        lazy = false,
      },
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          ensure_installed = {
            "vim", "lua",
            "html", "css", "javascript", "typescript", "tsx", "json", "vue", "svelte",
            "rust", "go", "python", "zig", "solidity",
            "hcl", "terraform",
          },
        },
      },
      { "rust-lang/rust.vim", lazy = false },
      {
        "mrcjkb/rustaceanvim",
        version = "^6",
        lazy = false,
      },
      {
        "aznhe21/actions-preview.nvim",
        config = function()
          require("actions-preview").setup {
            telescope = require("telescope.themes").get_dropdown {
              width = 0.8,
              height = 0.9,
              prompt_position = "top",
            },
          }
        end,
      },
      { "folke/trouble.nvim", lazy = false, opts = {}, cmd = "Trouble" },
      "mfussenegger/nvim-dap",
      {
        "yetone/avante.nvim",
        build = "make",
        event = "VeryLazy",
        branch = "main",
        config = function()
          require("avante").setup({
            windows = {
              ask = {
                floating = true,
                border = "rounded",
                start_insert = true,
              },
            },
          })
        end,
        dependencies = {
          "nvim-lua/plenary.nvim",
          "MunifTanjim/nui.nvim",
          "echasnovski/mini.pick",
          "nvim-telescope/telescope.nvim",
          "hrsh7th/nvim-cmp",
          "ibhagwan/fzf-lua",
          "stevearc/dressing.nvim",
          "folke/snacks.nvim",
          "nvim-tree/nvim-web-devicons",
          {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
              default = {
                embed_image_as_base64 = false,
                prompt_for_file_name = false,
                drag_and_drop = { insert_mode = true },
                use_absolute_path = true,
              },
            },
          },
          {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = { file_types = { "markdown", "Avante" } },
            ft = { "markdown", "Avante" },
          },
        },
      },
    }
  '';
  extraConfig = ''
    vim.g.mapleader = ";"
    vim.o.shell = "fish"
    vim.api.nvim_command("set mouse=")
    vim.api.nvim_command("set rnu!")
    vim.deprecate = function() end
    vim.lsp.inlay_hint.enable(true)
    vim.diagnostic.config({
      virtual_text = {
        spacing = 4,
        prefix = "■",
      },
      underline = true,
      update_in_insert = false,
    })

    require "nvchad.mappings"
    local map = vim.keymap.set
    map("n", "<leader>wv", "<cmd> vsplit <cr>", { desc = "Split vertically" })
    map("n", "<leader>wh", "<cmd> split <cr>", { desc = "Split horizontally" })
    map("n", "K", "<cmd> bp <cr>", { desc = "Previous tab" })
    map("n", "L", "<cmd> bn <cr>", { desc = "Next tab" })
    map("n", "<tab>", "<cmd> wincmd w <cr>", { desc = "Focus next split" })
    map("n", "<leader>ca", function()
      require("actions-preview").code_actions()
    end, { desc = "LSP Code Action Preview" })
    map("n", "<leader>ld", "<cmd> Trouble diagnostics<CR>", { desc = "Toggle diagnostics" })
    map("n", "<leader>lf", "<cmd> Trouble lsp_document_diagnostics <CR>", { desc = "Toggle file diagnostics" })
    map("n", "<leader>lw", "<cmd> Trouble lsp_workspace_diagnostics <CR>", { desc = "Toggle workspace diagnostics" })
    map("n", "<leader>ll", "<cmd> Trouble loclist <CR>", { desc = "Toggle loclist diagnostics" })

    local on_attach = require("nvchad.configs.lspconfig").on_attach
    local capabilities = require("nvchad.configs.lspconfig").capabilities
    local lspconfig = require "lspconfig"
    local servers = { "html", "cssls", "ts_ls", "pyright", "nixd" }
    vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end
  '';
}
