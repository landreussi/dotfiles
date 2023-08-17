local M = {}

M.general = {
  n = {
    ["<leader>wv"] = { "<cmd> vsplit <CR>", "Split window vertically" },
    ["<leader>wh"] = { "<cmd> split <CR>", "Split window horizontally" },
    ["<tab>"] = { "<cmd> wincmd w <CR>", "Cycle windows" },
    ["L"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },

    ["H"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "Goto prev buffer",
    },
    ["<leader>ld"] = { "<cmd> Trouble <CR>", "Toggle diagnostics" },
    ["<leader>lf"] = { "<cmd> Trouble lsp_document_diagnostics <CR>", "Toggle file diagnostics" },
    ["<leader>lw"] = { "<cmd> Trouble lsp_workspace_diagnostics <CR>", "Toggle workspace diagnostics" },
    ["<leader>ll"] = { "<cmd> Trouble loclist <CR>", "Toggle loclist diagnostics" },
  }
}

return M
