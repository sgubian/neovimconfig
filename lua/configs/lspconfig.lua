require("nvchad.configs.lspconfig").defaults()

local servers = {
  "air",
  "lua_ls",
  "pylsp",
  "julials",
  "marksman",
  "html",
  "cssls",
}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
