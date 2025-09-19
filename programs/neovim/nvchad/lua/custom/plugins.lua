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
    "mrcjkb/rustaceanvim",
    version = '^6',  
    lazy = false,
  },
  { "folke/trouble.nvim", lazy = false, opts = {}, cmd = "Trouble" },
  "mfussenegger/nvim-dap",
  {
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- add any opts here
      -- for example
      provider = "ollama",
      providers = {
        ---@type AvanteSupportedProvider
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-opus-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          context_window = 200000,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32000,
          },
        },
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "o4-mini",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32768,
          },
        },
        gemini = {
          endpoint = "https://generativelanguage.googleapis.com/v1beta",
          model = "gemini-2.0-flash",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32768,
          },
        },
        ---@type AvanteSupportedProvider
        ollama = {
          endpoint = "http://127.0.0.1:11434",
          model = "codellama",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            num_ctx = 20480,
            keep_alive = "5m",
          },
          is_env_set = function()
            return true
          end,
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick",         -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua",              -- for file_selector provider fzf
      "stevearc/dressing.nvim",        -- for input provider dressing
      "folke/snacks.nvim",             -- for input provider snacks
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}

return plugins
