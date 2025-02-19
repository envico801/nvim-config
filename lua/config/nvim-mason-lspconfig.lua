local lsp_config = require("config.lsp")

require('mason-tool-installer').setup({

  -- a list of all tools you want to ensure are installed upon
  -- start
  ensure_installed = {
    -- LSP
    "ruff",
    "ltex",
    "clangd",
    "vimls",
    "bashls",
    "lua_ls",
    "ts_ls",
    "basedpyright",

    -- Formatters
    "stylua",
    -- "black",
    "prettier",

    -- Linters
    -- "flake8",
    "shellcheck",

    -- DAP
    -- "debugpy",
  },

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated. This setting does not
  -- affect :MasonToolsUpdate or :MasonToolsInstall.
  -- Default: false
  auto_update = false,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use :MasonToolsInstall or
  -- :MasonToolsUpdate to install tools and check for updates.
  -- Default: true
  run_on_start = true,

  -- set a delay (in ms) before the installation starts. This is only
  -- effective if run_on_start is set to true.
  -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
  -- Default: 0
  -- start_delay = 3000, -- 3 second delay

  -- Only attempt to install if 'debounce_hours' number of hours has
  -- elapsed since the last time Neovim was started. This stores a
  -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
  -- This is only relevant when you are using 'run_on_start'. It has no
  -- effect when running manually via ':MasonToolsInstall' etc....
  -- Default: nil
  -- debounce_hours = 5, -- at least 5 hours between attempts to install/update

  -- By default all integrations are enabled. If you turn on an integration
  -- and you have the required module(s) installed this means you can use
  -- alternative names, supplied by the modules, for the thing that you want
  -- to install. If you turn off the integration (by setting it to false) you
  -- cannot use these alternative names. It also suppresses loading of those
  -- module(s) (assuming any are installed) which is sometimes wanted when
  -- doing lazy loading.
  integrations = {
    ['mason-lspconfig'] = true,
    ['mason-null-ls'] = false,
    ['mason-nvim-dap'] = true,
  },
})

require("mason-lspconfig").setup_handlers({
  -- Default handler
  function(server_name)
    require("lspconfig")[server_name].setup({
      on_attach = lsp_config.custom_attach,
      capabilities = lsp_config.capabilities,
    })
  end,

  -- Special handler for basedpyright
  ["basedpyright"] = function()
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

    require("lspconfig").basedpyright.setup({
      on_attach = lsp_config.custom_attach,
      capabilities = merged_capability,
      settings = {
        basedpyright = {
          -- disable import sorting and use Ruff for this
          disableOrganizeImports = true,
          disableTaggedHints = false,
        },
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
            callArgumentNames = true,
            functionReturnTypes = true,
            genericTypes = true,
            variableTypes = true,
          }
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

  -- Special handler for ts_ls
  ["ts_ls"] = function()
    require("lspconfig").ts_ls.setup({
      on_attach = lsp_config.custom_attach,
      capabilities = lsp_config.capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        },
        javascript = {
          inlayHints = {
            -- Same settings for JavaScript if needed
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        }
      }
    })
  end,
})
