require("nvchad.configs.lspconfig").defaults()

local servers = {
  "air",
  "lua_ls",
  "julials",
  "marksman",
  "html",
  "cssls",
}
vim.lsp.enable(servers)

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- For python
vim.lsp.config('ruff', {})
vim.lsp.enable('ruff')

vim.lsp.config('pyright', {
  on_attach = function(client, _)
    if client.server_capabilities.signatureHelpProvider then
      client.server_capabilities.signatureHelpProvider.triggerCharacters = {}
    end
  end,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
      },
    },
  },
})
vim.lsp.enable('pyright')

-- For Rust
vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json" },
  on_attach = function(client, _)
    -- Kill automatic signature help triggers
    if client.server_capabilities.signatureHelpProvider then
      client.server_capabilities.signatureHelpProvider.triggerCharacters = {}
    end
  end,
})
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  if not result or not result.signatures or #result.signatures == 0 then return end
  vim.lsp.handlers["textDocument/signatureHelp"](err, result, ctx,
    vim.tbl_extend("force", config or {}, { border = "rounded" }))
end

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })

