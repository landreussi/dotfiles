local plugins = {
  "folke/trouble.nvim",
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
