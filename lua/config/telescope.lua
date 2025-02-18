local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
-- local data = assert(vim.fn.stdpath "data") --[[@as string]]
local db_path = vim.fn.stdpath("config") .. "/lua/config/databases/telescope_history.sqlite3"

-- This ensures that the db_path directory exists
local db_dir = vim.fn.fnamemodify(db_path, ":h")
if vim.fn.isdirectory(db_dir) == 0 then
  vim.fn.mkdir(db_dir, "p")
end

-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require("telescope").setup {
  defaults = {
    file_ignore_patterns = {
      "dune.lock",
      "node_modules/.*", -- Ignore node_modules globally
    },
    history = {
      path = db_path,
      limit = 100,
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.cycle_history_prev,
        ["<C-k>"] = actions.cycle_history_next,
      },
    },
  },
  pickers = {
    find_files = {
      previewer = false, -- Disable preview for find_files
    },
    git_files = {
      previewer = false, -- Disable preview for git_files
    },
    buffers = {
      previewer = false, -- Disable preview for buffers
    },
    frecency = {
      previewer = false, -- Disable preview for frecency
    },
  },
  extensions = {
    wrap_results = true,

    fzf = {},
    -- ["ui-select"] = {
    --   require("telescope.themes").get_dropdown {},
    -- },
    ctags_outline = {
      ctags = { "ctags" },
      -- ft_opt = {
      --   -- ... other file type options
      --   javascript = '--javascript-kinds=f',
      --   -- The --javascript-kinds=a will include async functions
      -- },
      sorting_strategy = "ascending",
    },
  },
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:

require("telescope").load_extension("fzf")
require("telescope").load_extension("smart_history")
require("telescope").load_extension("frecency")
require("telescope").load_extension("ctags_outline")

-- pcall(require("telescope").load_extension, "fzf")
-- pcall(require("telescope").load_extension, "smart_history")
-- pcall(require("telescope").load_extension, "ui-select")

-- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set("n", "<leader>fa", "<cmd>Telescope ctags_outline<cr>", { desc = "Telescope ctags current buffer" })
vim.keymap.set(
  "n",
  "<leader>fb",
  "<cmd>Telescope ctags_outline buf=all<cr>",
  { desc = "Telescope ctags on all buffers" }
)
vim.keymap.set("n", "<leader>fc", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set(
  "n",
  "<leader>fd",
  "<cmd>Telescope frecency workspace=CWD<cr>",
  { desc = "Telescope frecency for current workspace" }
)
vim.keymap.set("n", "<leader>fe", "<cmd>Telescope frecency<cr>", { desc = "Telescope frecency" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", require("config.multi-ripgrep"), { desc = "Telescope multi ripgrep" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>ft", builtin.git_files, { desc = "Telescope git files" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Telescope grep word under cursor" })
vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "Telescope buffer fuzzy find" })

vim.keymap.set("n", "<leader>gj", "<cmd>DiffviewOpen<cr>", { desc = "Diffview Open" })
vim.keymap.set("n", "<leader>gk", "<cmd>DiffviewClose<cr>", { desc = "Diffview Close" })

--vim.keymap.set("n", "<leader>fa", function()
--  ---@diagnostic disable-next-line: param-type-mismatch
--  builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
--end)

--vim.keymap.set("n", "<leader>en", function()
--  builtin.find_files { cwd = vim.fn.stdpath "config" }
--end)

--vim.keymap.set("n", "<leader>eo", function()
--  builtin.find_files { cwd = "~/.config/nvim-backup/" }
--end)

--vim.keymap.set("n", "<leader>fp", function()
--  builtin.find_files { cwd = "~/plugins/" }
--end)
