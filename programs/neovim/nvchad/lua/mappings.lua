require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<leader>wv", "<cmd> vsplit <cr>", { desc = "Split vertically"})
map("n", "<leader>wh", "<cmd> split <cr>", { desc = "Split horizontally"})
map("n", "K", "<cmd> bp <cr>", {desc = "Previous tab"})
map("n", "L", "<cmd> bn <cr>", {desc = "Next tab"})
map("n", "<tab>", "<cmd> wincmd w <cr>", {desc = "Focus next split"})
map("n", "<leader>ca", function()
  require("actions-preview").code_actions()
end, { desc = "LSP Code Action Preview" })
map("n", "<leader>ld", "<cmd> Trouble diagnostics<CR>", {desc= "Toggle diagnostics" })
map("n", "<leader>lf", "<cmd> Trouble lsp_document_diagnostics <CR>", {desc = "Toggle file diagnostics" })
map("n", "<leader>lw", "<cmd> Trouble lsp_workspace_diagnostics <CR>", {desc= "Toggle workspace diagnostics" })
map("n", "<leader>ll", "<cmd> Trouble loclist <CR>", {desc= "Toggle loclist diagnostics" })
