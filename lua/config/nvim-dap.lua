local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  -- "vue",
}

local dap = require("dap")
local ui = require("dapui")

--require("dapui").setup()
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    ui.setup()
  end,
})

require("nvim-dap-virtual-text").setup {
  -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
  display_callback = function(variable)
    local name = string.lower(variable.name)
    local value = string.lower(variable.value)
    if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
      return "*****"
    end

    if #variable.value > 15 then
      return " " .. string.sub(variable.value, 1, 15) .. "... "
    end

    return " " .. variable.value
  end,
}

local Config = require("lazyvim.config")
vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

for name, sign in pairs(Config.icons.dap) do
  sign = type(sign) == "table" and sign or { sign }
  vim.fn.sign_define(
    "Dap" .. name,
    ---@diagnostic disable-next-line: assign-type-mismatch
    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
  )
end

for _, language in ipairs(js_based_languages) do
  dap.configurations[language] = {
    -- Debug single nodejs files
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
    },
    -- Debug nodejs processes (make sure to add --inspect or --inspect-brk  when you run the process)
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require("dap.utils").pick_process,
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to nodemon",
      cwd = vim.fn.getcwd(),
      skipFiles = {
        "<node_internals>/**",
        '**/node_modules/**',
      },
      port = 9229,
      sourceMaps = true,
    },
    -- Debug web applications (client side)
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Launch & Debug Chrome",
      url = function()
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({
            prompt = "Enter URL: ",
            default = "http://localhost:3000",
          }, function(url)
            if url == nil or url == "" then
              return
            else
              coroutine.resume(co, url)
            end
          end)
        end)
      end,
      webRoot = vim.fn.getcwd(),
      protocol = "inspector",
      sourceMaps = true,
      userDataDir = false,
    },
    -- Divider for the launch.json derived configs
    {
      name = "----- ↓ launch.json configs ↓ -----",
      type = "",
      request = "launch",
    },
  }
end

-- keys = {
--   {
--     "<leader>dO",
--     function()
--       require("dap").step_out()
--     end,
--     desc = "Step Out",
--   },
--   {
--     "<leader>do",
--     function()
--       require("dap").step_over()
--     end,
--     desc = "Step Over",
--   },
--   {
--     "<leader>da",
--     function()
--       if vim.fn.filereadable(".vscode/launch.json") then
--         local dap_vscode = require("dap.ext.vscode")
--         dap_vscode.load_launchjs(nil, {
--           ["pwa-node"] = js_based_languages,
--           ["chrome"] = js_based_languages,
--           ["pwa-chrome"] = js_based_languages,
--         })
--       end
--       require("dap").continue()
--     end,
--     desc = "Run with Args",
--   },
-- },



-- vim.keymap.set("n", "<space>bb", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
-- vim.keymap.set("n", "<space>bg", dap.run_to_cursor, { desc = "Run to cursor" })

-- Eval var under cursor
-- vim.keymap.set("n", "<space>b?", function()
--   require("dapui").eval(nil, { enter = true })
-- end, { desc = "Eval variable under cursor" })

-- vim.keymap.set("n", "<space>bc", function()
--   require("dapui").toggle()
-- end, { desc = "Toggle ui" })

vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_into)
vim.keymap.set("n", "<F3>", dap.step_over)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<F5>", dap.step_back)
vim.keymap.set("n", "<F12>", dap.restart)

dap.listeners.before.attach.dapui_config = function()
  ui.open()
end
dap.listeners.before.launch.dapui_config = function()
  ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  ui.close()
end
