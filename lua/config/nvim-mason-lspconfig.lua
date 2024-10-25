local lsp_config = require("config.lsp")

require("mason-lspconfig").setup {
  -- A list of servers to automatically install if they're not already installed
  ensure_installed = {
    "pylsp",
    "ltex",
    "clangd",
    "vimls",
    "bashls",
    "lua_ls",
    "ts_ls",
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

  -- Special handler for pylsp
  ["pylsp"] = function()
    local venv_path = os.getenv('VIRTUAL_ENV')
    local py_path = nil
    -- decide which python executable to use for mypy
    if venv_path ~= nil then
      py_path = venv_path .. "/bin/python3"
    else
      py_path = vim.g.python3_host_prog
    end

    require("lspconfig").pylsp.setup({
      on_attach = lsp_config.custom_attach,
      capabilities = lsp_config.capabilities,
      settings = {
        pylsp = {
          plugins = {
            -- formatter options
            black = { enabled = true },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
            -- linter options
            pylint = { enabled = true, executable = "pylint" },
            ruff = { enabled = false },
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            -- type checker
            pylsp_mypy = {
              enabled = true,
              overrides = { "--python-executable", py_path, true },
              report_progress = true,
              live_mode = false
            },
            -- auto-completion options
            jedi_completion = { fuzzy = true },
            -- import sorting
            isort = { enabled = true },
          },
        },
      },
      flags = {
        debounce_text_changes = 200,
      },
    })
  end,

  -- Special handler for ltex
  ["ltex"] = function()
    require("lspconfig").ltex.setup({
      on_attach = lsp_config.custom_attach,
      capabilities = lsp_config.capabilities,
      filetypes = { "text", "plaintex", "tex", "markdown" },
      settings = {
        ltex = {
          language = "en"
        },
      },
      flags = { debounce_text_changes = 300 },
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
    -- settings for lua-language-server can be found on https://github.com/LuaLS/lua-language-server/wiki/Settings .
    require("lspconfig").lua_ls.setup({
      on_attach = lsp_config.custom_attach,
      capabilities = lsp_config.capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
        },
      },
    })
  end,
})
