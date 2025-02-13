require('spectre').setup {
  -- mapping = {
    -- ['toggle_literal'] = {
    --   map = "<C-c>l",
    --   cmd = "<cmd>lua require('spectre').change_options('literal')<CR>",
    --   desc = "toggle literal text search"
    -- },
  -- },
  find_engine = {
    ['rg'] = {
      options = {
        -- you can put any rg search option you want here it can toggle with
        -- show_option function
        ['literal'] = {
          value = "--fixed-strings",
          desc = "literal string",
          icon = "[L]"
        },
      }
    },
  },
  default = {
    --find = {
    --  --pick one of item in find_engine
    --  cmd = "rg",
    --  options = { "ignore-case" }
    --},
    replace = {
      cmd = "oxi"
    }
  },
}

-- vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
--   desc = "Toggle Spectre"
-- })
-- vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
--   desc = "Search current word"
-- })
-- vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
--   desc = "Search current word"
-- })
-- vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
--   desc = "Search on current file"
-- })
