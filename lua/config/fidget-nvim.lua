require("fidget").setup {
  progress = {
    display = {
      render_limit = 10, -- Show more messages at once
      done_icon = "✔  ",
      done_style = "DiagnosticOk",                                -- Use semantic highlights that follow colorscheme
      progress_icon = { pattern = "dots_scrolling", period = 1 }, -- More visible progress
      -- progress_style = "DiagnosticInfo",
      -- group_style = "Title",
      -- icon_style = "Special",
      -- priority = 50, -- Higher priority to ensure visibility
      -- skip_history = false, -- Keep in history for reference
    },
  },

  notification = {
    view = {
      icon_separator = " 󰁔 ", -- Changed to a more distinctive separator
      group_separator = "━━━", -- More visible separator
    },
    window = {
      normal_hl = "Normal", -- Use normal text color for better readability
      winblend = 0,         -- Solid background as requested
      border = "single",    -- Add border for better visibility
      max_width = 40,       -- Reasonable width limit
      max_height = 20,      -- Reasonable height limit
    },
  },

  -- Keep default integration settings
  integration = {
    ["nvim-tree"] = {
      enable = true,
    },
  },
}
