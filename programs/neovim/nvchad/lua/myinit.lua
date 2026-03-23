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
  update_in_insert = false, -- Don't flicker while typing
})
