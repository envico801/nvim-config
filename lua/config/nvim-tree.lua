local keymap = vim.keymap
local nvim_tree = require("nvim-tree")

local api = require("nvim-tree.api")

-- Detect OS and set the system open command accordingly
local system_open_cmd = ""
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- For Windows, using cmd to open the file
  system_open_cmd = 'explorer'
elseif vim.fn.has("mac") == 1 then
  -- For macOS, use "open"
  system_open_cmd = "open"
else
  -- Assume Unix/Linux; use "xdg-open"
  system_open_cmd = "xdg-open"
end

local function edit_or_open()
  local node = api.tree.get_node_under_cursor()

  if node.nodes ~= nil then
    -- expand or collapse folder
    api.node.open.edit()
  else
    -- open file
    api.node.open.edit()
    -- Close the tree if file was opened
    api.tree.close()
  end
end

-- open as vsplit on current node
local function vsplit_preview()
  local node = api.tree.get_node_under_cursor()

  if node.nodes ~= nil then
    -- expand or collapse folder
    api.node.open.edit()
  else
    -- open file as vsplit
    api.node.open.vertical()
  end

  -- Finally refocus on tree if it was lost
  api.tree.focus()
end

local function my_on_attach(bufnr)

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  -- on_attach
  keymap.set("n", "l", edit_or_open,          opts("Edit Or Open"))
  keymap.set("n", "L", vsplit_preview,        opts("Vsplit Preview"))
  keymap.set("n", "h", api.tree.close,        opts("Close"))
  keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
  keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
  keymap.set("n", "s", api.node.run.system, opts("Open: In system explorer"))

end

nvim_tree.setup {
  auto_reload_on_write = true,
  on_attach = my_on_attach,
  disable_netrw = false,
  hijack_netrw = true,
  hijack_cursor = false,
  hijack_unnamed_buffer_when_opening = false,
  open_on_tab = false,
  sort_by = "name",
  update_cwd = false,
  view = {
    width = 60,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },
  renderer = {
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = true,
    },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  system_open = {
    cmd = system_open_cmd,
    args = {},
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      diagnostics = false,
      git = false,
      profile = false,
    },
  },
}

keymap.set("n", "<space>s", api.tree.toggle, {
  silent = true,
  desc = "toggle nvim-tree",
})
