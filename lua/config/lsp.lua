local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp

-- local utils = require("utils")
local M = {}

-- Setup capabilities
M.capabilities = vim.lsp.protocol.make_client_capabilities()
-- required by nvim-ufo
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- Set up the LspAttach event to configure buffer behavior
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("buf_behavior_conf", { clear = true }),
  callback = function(event_context)
    local client = vim.lsp.get_client_by_id(event_context.data.client_id)

    if not client then
      return
    end

    local bufnr = event_context.buf

    -- Mappings.
    local map = function(mode, l, r, opts)
      opts = opts or {}
      opts.silent = true
      opts.buffer = bufnr
      keymap.set(mode, l, r, opts)
    end

    map("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
    map("n", "<C-]>", vim.lsp.buf.definition)
    map("n", "K", function()
      vim.lsp.buf.hover { border = "single", max_height = 25, max_width = 120 }
    end)
    map("n", "<C-o>", vim.lsp.buf.signature_help)
    map("n", "<space>rn", vim.lsp.buf.rename, { desc = "varialbe rename" })
    map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
    map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
    map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
    map("n", "<space>wl", function()
      vim.print(vim.lsp.buf.list_workspace_folders())
    end, { desc = "list workspace folder" })

    -- Set some key bindings conditional on server capabilities
    if client.server_capabilities.documentFormattingProvider and client.name ~= "lua_ls" then
      map({ "n", "x" }, "<space>f", vim.lsp.buf.format, { desc = "format code" })
    end

    -- Disable hover for ruff in favor of other providers
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end

    -- Uncomment code below to enable inlay hint from language server
    vim.lsp.inlay_hint.enable(true, {buffer=bufnr})

    -- The blow command will highlight the current variable and its usages in the buffer.
    if client.server_capabilities.documentHighlightProvider then
      local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
      api.nvim_create_autocmd("CursorHold", {
        group = gid,
        buffer = bufnr,
        callback = function()
          lsp.buf.document_highlight()
        end,
      })

      api.nvim_create_autocmd("CursorMoved", {
        group = gid,
        buffer = bufnr,
        callback = function()
          lsp.buf.clear_references()
        end,
      })
    end

    if vim.g.logging_level == "debug" then
      local msg = string.format("Language server %s started!", client.name)
      vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
    end
  end,
  nested = true,
  desc = "Configure buffer keymap and behavior based on LSP",
})

return M
