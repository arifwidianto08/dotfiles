local status, null_ls = pcall(require, "null-ls")
if (not status) then return end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end

null_ls.setup {
  sources = {
    null_ls.builtins.formatting.prettierd.with({ filetypes = { "css", "scss", "less", "html", "json", "yaml", "markdown",
      "graphql", "javascript",
      "javascriptreact", "typescript", "typescriptreact", "css", "json", "jsonc", "json5", "vue" }, }),
    null_ls.builtins.formatting.prettier.with({
      -- extra_args = { "--single-quote", "--print-width 120" },
      filetypes = { "css", "scss", "less", "html", "json", "yaml", "markdown", "graphql", "javascript",
        "javascriptreact", "typescript", "typescriptreact", "css", "json", "jsonc", "json5", "vue" },
    }),
    -- null_ls.builtins.diagnostics.eslint_d.with({
    --   diagnostics_format = '[eslint] #{m}\n(#{c})'
    -- }),
    null_ls.builtins.diagnostics.eslint_d,
    -- null_ls.builtins.diagnostics.fish,
    null_ls.builtins.completion.luasnip,
    null_ls.builtins.completion.spell,
    null_ls.builtins.diagnostics.cspell,
    null_ls.builtins.code_actions.cspell,
    null_ls.builtins.hover.dictionary
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          lsp_formatting(bufnr)
          vim.lsp.buf.formatting_sync()
        end,
      })
    end
  end
}

vim.api.nvim_create_user_command(
  'DisableLspFormatting',
  function()
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
  end,
  { nargs = 0 }
)
