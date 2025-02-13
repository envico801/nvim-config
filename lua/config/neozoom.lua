require('neo-zoom').setup {
  popup = { enabled = true },
  winopts = {
    -- offset = {
      -- NOTE: omit `top`/`left` to center the floating window vertically/horizontally.
      -- top = 0.05,
      -- left = 0.22,

      -- width = 110,
      -- height = 0.55,
    -- },
    -- NOTE: check :help nvim_open_win() for possible border values.
    border = 'single', -- this is a preset, try it :)
  },
}

-- vim.api.nvim_create_autocmd({ 'WinEnter' }, {
--   callback = function()
--     local zoom_book = require('neo-zoom').zoom_book

--     if require('neo-zoom').is_neo_zoom_float()
--     then
--       for z, _ in pairs(zoom_book) do vim.wo[z].winbl = 0 end
--     else
--       for z, _ in pairs(zoom_book) do vim.wo[z].winbl = 30 end
--     end
--   end
-- })
