require("bufferline").setup {
  options = {
    numbers = "none",
    close_command = "bdelete! %d",
    right_mouse_command = nil,
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      icon = "▎", -- this should be omitted if indicator style is not 'icon'
      style = "icon",
    },
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 10,
    diagnostics = false,
    custom_filter = function(bufnr)
      -- if the result is false, this buffer will be shown, otherwise, this
      -- buffer will be hidden.

      -- filter out filetypes you don't want to see
      local exclude_ft = { "qf", "fugitive", "git" }
      local cur_ft = vim.bo[bufnr].filetype
      local should_filter = vim.tbl_contains(exclude_ft, cur_ft)

      if should_filter then
        return false
      end

      return true
    end,
    show_buffer_icons = false,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    separator_style = "bar",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    sort_by = "id",
  },

  highlights = {
    fill = {
      bg = '#32302f' -- This sets the background of the entire bufferline bar
    },
    background = {
      -- fg = 'red',
      bg = '#32302f' -- This sets the background of the entire bufferline bar
    },
    tab = {
      -- fg = 'red',
      bg = '#32302f' -- This sets the background of the entire bufferline bar
    },
    tab_selected = {
      fg = '#fb4934',
      bg = '#32302f' -- This sets the background of the entire bufferline bar
    },
    tab_separator = {
      fg = '#b8bb26',
      -- bg = 'red',
    },
    tab_separator_selected = {
      fg = '#fb4934',
      -- bg = 'red',
      -- sp = 'red',
      -- underline = 'red',
    },
    tab_close = {
      -- fg = 'red',
      bg = '#32302f' -- This sets the background of the entire bufferline bar
    },
    close_button = {
      -- fg = 'red',
      bg = '#32302f' -- Background for close button
    },
    close_button_visible = {
      -- fg = 'red',
      bg = '#32302f' -- Background for close button
    },
    close_button_selected = {
      -- fg = 'red',
      bg = '#504945'
    },
    buffer_visible = {
      bg = '#504945', -- Background color for selected buffer
      -- bg = 'red',
    },
    buffer_selected = {
      bg = '#504945', -- Background color for selected buffer
      bold = true,
      italic = false,
    },
    -- numbers = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- numbers_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- numbers_selected = {
    --   fg = 'red',
    --   bg = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- diagnostic = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- diagnostic_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- diagnostic_selected = {
    --   fg = 'red',
    --   bg = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- hint = {
    --   fg = 'red',
    --   sp = 'red',
    --   bg = 'red',
    -- },
    -- hint_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- hint_selected = {
    --   fg = 'red',
    --   bg = 'red',
    --   sp = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- hint_diagnostic = {
    --   fg = 'red',
    --   sp = 'red',
    --   bg = 'red',
    -- },
    -- hint_diagnostic_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- hint_diagnostic_selected = {
    --   fg = 'red',
    --   bg = 'red',
    --   sp = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- info = {
    --   fg = 'red',
    --   sp = 'red',
    --   bg = 'red',
    -- },
    -- info_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- info_selected = {
    --   fg = 'red',
    --   bg = 'red',
    --   sp = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- info_diagnostic = {
    --   fg = 'red',
    --   sp = 'red',
    --   bg = 'red',
    -- },
    -- info_diagnostic_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- info_diagnostic_selected = {
    --   fg = 'red',
    --   bg = 'red',
    --   sp = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- warning = {
    --   fg = 'red',
    --   sp = 'red',
    --   bg = 'red',
    -- },
    -- warning_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- warning_selected = {
    --   fg = 'red',
    --   bg = 'red',
    --   sp = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- warning_diagnostic = {
    --   fg = 'red',
    --   sp = 'red',
    --   bg = 'red',
    -- },
    -- warning_diagnostic_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- warning_diagnostic_selected = {
    --   fg = 'red',
    --   bg = 'red',
    --   sp = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- error = {
    --   fg = 'red',
    --   bg = 'red',
    --   sp = 'red',
    -- },
    -- error_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- error_selected = {
    --   fg = 'red',
    --   bg = 'red',
    --   sp = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- error_diagnostic = {
    --   fg = 'red',
    --   bg = 'red',
    --   sp = 'red',
    -- },
    -- error_diagnostic_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- error_diagnostic_selected = {
    --   fg = 'red',
    --   bg = 'red',
    --   sp = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    modified = {
      fg = '#b8bb26',
      bg = '#32302f' -- This sets the background of the entire bufferline bar
    },
    modified_visible = {
      fg = '#b8bb26',
      bg = '#32302f' -- This sets the background of the entire bufferline bar
    },
    modified_selected = {
      fg = '#b8bb26',
      bg = '#504945', -- Background color for selected buffer
    },
    duplicate_selected = {
      -- fg = 'red',
      bg = '#504945', -- Background color for selected buffer
      italic = true,
    },
    duplicate_visible = {
      -- fg = 'red',
      bg = '#32302f', -- This sets the background of the entire bufferline bar
      italic = true,
    },
    duplicate = {
      -- fg = 'red',
      bg = '#32302f', -- This sets the background of the entire bufferline bar
      italic = true,
    },
    -- separator_selected = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    -- separator_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    separator = {
      fg = '#282828',
      bg = '#282828' -- This sets the background of the entire bufferline bar
    },
    -- indicator_visible = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    indicator_selected = {
      fg = '#b8bb26',
      bg = '#504945', -- Background color for selected buffer
    },
    -- pick_selected = {
    --   fg = 'red',
    --   bg = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- pick_visible = {
    --   fg = 'red',
    --   bg = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- pick = {
    --   fg = 'red',
    --   bg = 'red',
    --   bold = true,
    --   italic = true,
    -- },
    -- offset_separator = {
    --   fg = 'red',
    --   bg = 'red',
    -- },
    trunc_marker = {
      fg = '#b8bb26',
      -- bg = 'red',
    }
  },


}

-- vim.keymap.set("n", "<space>bp", "<cmd>BufferLinePick<CR>", {
--   desc = "pick a buffer",
-- })
