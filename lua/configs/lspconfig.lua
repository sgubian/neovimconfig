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
-- vim.lsp.config("rust_analyzer", {
--   cmd = { "rust-analyzer" },
--   filetypes = { "rust" },
--   root_markers = { "Cargo.toml", "rust-project.json" },
--   on_attach = function(client, _)
--     -- Kill automatic signature help triggers
--     if client.server_capabilities.signatureHelpProvider then
--       client.server_capabilities.signatureHelpProvider.triggerCharacters = {}
--     end
--   end,
-- })

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml' },
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
        buildScripts = {
          enable = true,
        },
      },
      procMacro = { enable = true },
      checkOnSave = {
        command = "clippy",
        enable = true,
      },
      diagnostics = {
        enable = true,
        refresh_support = true,  -- Important
        experimental = {
          enable = false,
        },
      },
      -- Force file watching
      files = {
        watcher = "server",  -- Use server-side watching
      },
    },
  },
})
vim.lsp.enable "rust_analyzer"


vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  if not result or not result.signatures or #result.signatures == 0 then return end
  vim.lsp.handlers["textDocument/signatureHelp"](err, result, ctx,
    vim.tbl_extend("force", config or {}, { border = "rounded" }))
end

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })

vim.api.nvim_create_user_command('LspClearCache', function()
  vim.fn.system('rm -rf ~/.cache/nvim/lsp/')
  vim.fn.system('rm -rf ~/.local/state/nvim/lsp/')
  vim.cmd('LspRestart')
  vim.notify('LSP cache cleared and restarted', vim.log.levels.INFO)
end, {})

