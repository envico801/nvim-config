-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`

-- vim.keymap.set('n', '<A-H>', require('smart-splits').resize_left, {desc = "Resize buffer left"})
-- vim.keymap.set('n', '<A-J>', require('smart-splits').resize_down, {desc = "Resize buffer down"})
-- vim.keymap.set('n', '<A-K>', require('smart-splits').resize_up, {desc = "Resize buffer up"})
-- vim.keymap.set('n', '<A-L>', require('smart-splits').resize_right, {desc = "Resize buffer right"})

-- moving between splits

-- vim.keymap.set('n', '<A-h>', require('smart-splits').move_cursor_left, {desc = "Split move cursor left"})
-- vim.keymap.set('n', '<A-j>', require('smart-splits').move_cursor_down, {desc = "Split move cursor down"})
-- vim.keymap.set('n', '<A-k>', require('smart-splits').move_cursor_up, {desc = "Split move cursor up"})
-- vim.keymap.set('n', '<A-l>', require('smart-splits').move_cursor_right, {desc = "Split move cursor right"})

-- vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)

-- swapping buffers between windows

-- vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left, {desc = "Swap buffer left"})
-- vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down, {desc = "Swap buffer down"})
-- vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up, {desc = "Swap buffer up"})
-- vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right, {desc = "Swap buffer right"})
