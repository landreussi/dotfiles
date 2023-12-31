local M = {}

local highlights = require "custom.highlights"

M.ui = {
  theme = "everforest",
  theme_toggle = { "everforest", "everforest_light" },
  hl_override = highlights.override,

  nvdash = {
    load_on_startup = true,

    buttons = {
      { "  Find File", "; f f", "Telescope find_files" },
      { "󰈭  Find Word", "; f w", "Telescope live_grep" },
      { "  Themes", "; t h", "Telescope themes" },
      { "  Mappings", "; c h", "NvCheatsheet" },
    },

    header = {
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣾⣷⣾⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⡟⣿⣿⣶⣄⡀⠀⠀⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣸⣿⣇⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣻⣿⡄⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⡿⠍⠙⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⣱⣾⠟⠀⢠⠉⠉⠉⠻⣿⣿⡇⠀⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽⣿⣿⣿⣿⣿⡿⠛⣡⣶⣿⣧⣤⠸⡟⠂⠀⠀⠀⢹⣿⡇⠀⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⠇⠀⢈⣥⣿⣿⣿⣿⣿⣷⣆⢰⣆⠀⢸⡏⠀⠀⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣏⣿⡏⠀⣾⣾⣿⣿⣿⣿⣿⣿⣿⣿⢻⣿⣷⣾⡃⠀⠀⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣷⡄⠘⠹⢿⣿⣍⠉⢛⣿⣿⣿⠸⣿⣿⠿⠁⠀⠀⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⢿⣿⣿⣿⣿⣦⣀⣿⣿⣿⣶⣾⣿⣿⣿⡇⠁⠈⡄⠀⠀⠀⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡟⢺⣿⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⡺⠁⠀⠀⠀⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⢸⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣏⣻⡶⠁⠀⠀⠀⠀⠀⠀⠀⠀ ",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡿⠀⣿⡏⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣬⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      "⣀⣀⣤⣤⣤⣤⣀⣀⣠⣤⣤⣶⣶⣿⣿⡛⠻⠿⣿⡿⠛⠁⢰⣿⣿⠃⢘⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      "⣩⣿⣿⡿⠿⣻⣿⣿⣿⣿⣿⣿⣅⠄⢉⣙⣿⣿⡟⠀⠀⠀⠘⣿⡇⠀⠀⣿⣦⣿⣿⣿⣿⣿⣿⣿⣟⣻⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      "⠟⠋⢱⣦⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⣸⠀⡇⢠⣿⣧⠀⢠⣿⡿⢿⠿⠋⠙⠛⠛⠛⠛⠋⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      "⣶⠶⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⠏⣸⣿⣿⣿⣧⠀⠀⠀⣷⠸⣿⠃⣴⣿⡟⠙⠁⠀⠀⠀⠀⠀⣾⣄⣀⡀⠉⠢⣀⠀⠀⠀⠀⠀⠀⠀ ",
      "⡇⠀⢉⣹⣾⣿⣿⣿⣿⣿⣿⣿⣶⣬⣿⣿⣿⣿⣦⡄⣀⡿⠀⣿⣿⣇⠹⣷⣤⣾⠇⠀⠀⠀⣰⣿⣿⣿⣿⣆⠀⠈⠳⡀⠀⠀⠀⠀⠀ ",
      "⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⢰⣿⣿⡿⢶⣿⣿⡟⢀⣤⠀⣰⣿⣿⣿⣿⡿⣭⣷⣄⡀⠘⢄⠀⠀⠀⠀ ",
      "⣠⣾⣿⣿⢋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⣼⣿⣿⣧⣾⣿⢿⡷⠟⠉⠀⠹⠟⠛⢉⠁⡀⠈⠉⠉⠑⢦⡈⠳⡀⠀⠀ ",
      "⡏⠀⠘⣳⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⠙⢿⣿⣿⣿⣿⠉⠀⢀⡉⡦⠄⠀⠀⠀⠀⣿⠀⠠⠄⠀⠀⠀⠀⠑⠠⠉⠒⢄ ",
      "⣷⡆⢸⡯⠤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⢘⣿⣿⢋⠍⢿⣶⣽⣿⡿⢿⡄⠀⠀⣸⡯⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
      "⣿⣿⣄⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣾⣿⣿⣿⣿⣶⣿⣿⣿⣿⣿⣷⣶⣾⣿⣤⣷⣶⣄⣰⣤⣀⣀⣀⣀⣀⣀⣀ ",
      "                                                  ",
      "███    ██ ██    ██  ██████ ██   ██  █████  ██████ ",
      "████   ██ ██    ██ ██      ██   ██ ██   ██ ██   ██",
      "██ ██  ██ ██    ██ ██      ███████ ███████ ██   ██",
      "██  ██ ██  ██  ██  ██      ██   ██ ██   ██ ██   ██",
      "██   ████   ████    ██████ ██   ██ ██   ██ ██████ ",
    },
  }
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
