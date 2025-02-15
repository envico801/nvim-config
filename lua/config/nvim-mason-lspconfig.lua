local lsp_config = require("config.lsp")

require("mason-lspconfig").setup {
  -- A list of servers to automatically install if they're not already installed
  ensure_installed = {
    "pyright", -- Changed from pylsp to pyright
    "ruff",    -- Added ruff
    "ltex",
    "clangd",
    "vimls",
    "bashls",
    "lua_ls",
    "ts_ls",
    "stylua"
    -- Add any other servers you want to install
  },
  -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed
  automatic_installation = true,
}

require("mason-lspconfig").setup_handlers({
  -- Default handler
  function(server_name)
    require("lspconfig")[server_name].setup({
      on_attach = lsp_config.custom_attach,
      capabilities = lsp_config.capabilities,
    })
  end,

  -- Special handler for pyright
  ["pyright"] = function()
    local new_capability = {
      textDocument = {
        publishDiagnostics = {
          tagSupport = {
            valueSet = { 2 }
          }
        }
      },
      hover = {
        contentFormat = { "plaintext" },
        dynamicRegistration = true,
      },
    }
    local merged_capability = vim.tbl_deep_extend("force", lsp_config.capabilities, new_capability)

    require("lspconfig").pyright.setup({
      on_attach = lsp_config.custom_attach,
      capabilities = merged_capability,
      settings = {
        pyright = {
          -- disable import sorting and use Ruff for this
          disableOrganizeImports = true,
          disableTaggedHints = false,
        },
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            typeCheckingMode = "standard",
            useLibraryCodeForTypes = true,
            -- we can this setting below to redefine some diagnostics
            diagnosticSeverityOverrides = {
              deprecateTypingAliases = false,
            },
            -- inlay hint settings are provided by pylance?
            inlayHints = {
              callArgumentNames = "partial",
              functionReturnTypes = true,
              pytestParameters = true,
              variableTypes = true,
            },
          },
        },
      },
    })
  end,

  -- Special handler for ruff
  ["ruff"] = function()
    require("lspconfig").ruff.setup({
      on_attach = function(client, bufnr)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
        -- Call the regular custom_attach
        lsp_config.custom_attach(client, bufnr)
      end,
      capabilities = lsp_config.capabilities,
      init_options = {
        settings = {
          organizeImports = true,
        }
      }
    })
  end,

  -- Special handler for ltex
  ["ltex"] = function()
    require("lspconfig").ltex.setup({
      on_attach = lsp_config.custom_attach,
      capabilities = lsp_config.capabilities,
      -- filetypes = { "text", "plaintex", "tex", "markdown" },
      settings = {
        ltex = {
          language = "en"
        },
      },
      flags = {
        debounce_text_changes = 10000,
      },
      -- handlers = {
      --   ["textDocument/publishDiagnostics"] = vim.lsp.with(
      --     vim.lsp.diagnostic.on_publish_diagnostics, {
      --       -- Disable updates in insert mode
      --       update_in_insert = false,
      --       -- Keep your existing high debounce
      --       delay = 10000,
      --     }
      --   )
      -- }
    })
  end,

  -- Special handler for clangd
  ["clangd"] = function()
    require("lspconfig").clangd.setup({
      on_attach = lsp_config.custom_attach,
      capabilities = lsp_config.capabilities,
      filetypes = { "c", "cpp", "cc" },
      flags = {
        debounce_text_changes = 500,
      },
    })
  end,

  -- Special handler for vimls
  ["vimls"] = function()
    require("lspconfig").vimls.setup({
      on_attach = lsp_config.custom_attach,
      capabilities = lsp_config.capabilities,
      flags = {
        debounce_text_changes = 500,
      },
    })
  end,

  -- Special handler for lua_ls
  ["lua_ls"] = function()
    -- settings for lua-language-server can be found on https://luals.github.io/wiki/settings/
    require("lspconfig").lua_ls.setup({
      on_attach = lsp_config.custom_attach,
      capabilities = lsp_config.capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          hint = {
            enable = true
          }
        },
      },
    })
  end,
})
