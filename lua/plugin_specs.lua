local utils = require("utils")

local plugin_dir = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_dir .. "/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- check if firenvim is active
local firenvim_not_active = function()
  return not vim.g.started_by_firenvim
end

local plugin_specs = {
  -- auto-completion engine
  {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    -- event = 'InsertEnter',
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-omni",
      "quangnguyen30192/cmp-nvim-ultisnips",
    },
    config = function()
      require("config.nvim-cmp")
    end,
  },
  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    dependencies = {
      -- Mason and mason-lspconfig must be dependencies of lspconfig
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        config = function()
          require("config.nvim-mason")
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          require("config.nvim-mason-lspconfig")
        end,
      },
    },
    config = function()
      require("config.lsp")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- enabled = function()
    --   if vim.g.is_mac then
    --     return true
    --   end
    --   return false
    -- end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },

  -- Python-related text object
  { "jeetsukumaran/vim-pythonsense", ft = { "python" } },

  -- { "machakann/vim-swap", event = "VeryLazy" },

  -- IDE for Lisp
  -- 'kovisoft/slimv'
  -- {
  --   "vlime/vlime",
  --   enabled = function()
  --     if utils.executable("sbcl") then
  --       return true
  --     end
  --     return false
  --   end,
  --   config = function(plugin)
  --     vim.opt.rtp:append(plugin.dir .. "/vim")
  --   end,
  --   ft = { "lisp" },
  -- },

  -- Super fast buffer jump
  {
    "smoka7/hop.nvim",
    -- event = "VeryLazy",
    keys = {
      { "f", function() require('hop').hint_char1() end, mode = { "n", "v", "o" }, silent = true, noremap = true, desc = "nvim-hop char1" },
    },
    config = function()
      require("config.nvim_hop")
    end,
  },

  {
    "ThePrimeagen/vim-be-good",
    cmd = { "VimBeGood" }
    -- config = function()
    --   require("config.nvim_hop")
    -- end,
  },

  -- Show match number and index for searching
  {
    "kevinhwang91/nvim-hlslens",
    branch = "main",
    keys = { "*", "#", "n", "N" },
    config = function()
      require("config.hlslens")
    end,
  },
  -- {
  --   "Yggdroot/LeaderF",
  --   cmd = "Leaderf",
  --   build = function()
  --     local leaderf_path = plugin_dir .. "/LeaderF"
  --     vim.opt.runtimepath:append(leaderf_path)
  --     vim.cmd("runtime! plugin/leaderf.vim")

  --     if not vim.g.is_win then
  --       vim.cmd("LeaderfInstallCExtension")
  --     end
  --   end,
  -- },
  {
    "ThePrimeagen/harpoon",
    -- event = "BufReadPost",
    keys = {
      { "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Harpoon add file" },
      { "<leader>ee", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Harpoon toggle menu" },
      { "<C-j>", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "Harpoon file 1" },
      { "<C-k>", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "Harpoon file 2" },
      { "<C-l>", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "Harpoon file 3" },
      { "<C-h>", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "Harpoon file 4" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function ()
      require("config.harpoon")
    end
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>S", "<cmd>lua require('spectre').toggle()<CR>", desc = "Toggle Spectre" },
      { "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", mode = "n", desc = "Search current word" },
      { "<leader>sw", "<esc><cmd>lua require('spectre').open_visual()<CR>", mode = "v", desc = "Search current word" },
      { "<leader>sp", "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", desc = "Search on current file" },
    },
    config = function ()
      require('config.spectre-nvim')
    end
  },
  {
    'mrjones2014/smart-splits.nvim',
    event = { "BufRead", "BufNewFile" },
    keys = {
      -- Resizing splits
      { "<A-H>", function() require('smart-splits').resize_left() end, desc = "Resize buffer left" },
      { "<A-J>", function() require('smart-splits').resize_down() end, desc = "Resize buffer down" },
      { "<A-K>", function() require('smart-splits').resize_up() end, desc = "Resize buffer up" },
      { "<A-L>", function() require('smart-splits').resize_right() end, desc = "Resize buffer right" },

      -- Moving between splits
      { "<A-h>", function() require('smart-splits').move_cursor_left() end, desc = "Split move cursor left" },
      { "<A-j>", function() require('smart-splits').move_cursor_down() end, desc = "Split move cursor down" },
      { "<A-k>", function() require('smart-splits').move_cursor_up() end, desc = "Split move cursor up" },
      { "<A-l>", function() require('smart-splits').move_cursor_right() end, desc = "Split move cursor right" },

      -- Swapping buffers
      { "<leader><leader>h", function() require('smart-splits').swap_buf_left() end, desc = "Swap buffer left" },
      { "<leader><leader>j", function() require('smart-splits').swap_buf_down() end, desc = "Swap buffer down" },
      { "<leader><leader>k", function() require('smart-splits').swap_buf_up() end, desc = "Swap buffer up" },
      { "<leader><leader>l", function() require('smart-splits').swap_buf_right() end, desc = "Swap buffer right" },
    },
    config = function ()
      require('config.smart-splits-nvim')
    end
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "BufReadPost",  -- Loads plugin when a buffer is read
    -- config = function()
    --     vim.g.VM_default_mappings = true
    -- end
  },
  {
    "nyngwang/NeoZoom.lua",
    keys = {
      { "<space>kk", function() vim.cmd('NeoZoomToggle') end, mode = "n", silent = true, nowait = true, desc = "Toggle NeoZoom" },
    },
    config = function ()
      require('config.neozoom')
    end
  },
  -- {
  --   "edkolev/tmuxline.vim",
  --   config = function ()
  --     require('config.tmuxline')
  --   end
  -- },
  {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    -- cmd = "Telescope",
    -- keys = {
    --   { "<leader>ff", function() require('telescope.builtin').find_files() end, desc = "Telescope find files" },
    --   { "<leader>fg", function() require('telescope.builtin').live_grep() end, desc = "Telescope live grep" },
    --   { "<leader>fb", function() require('telescope.builtin').buffers() end, desc = "Telescope buffers" },
    --   { "<leader>fh", function() require('telescope.builtin').help_tags() end, desc = "Telescope help tags" },
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
      },
      {
        "nvim-telescope/telescope-smart-history.nvim",
        dependencies = {
          {
            "kkharji/sqlite.lua"
          },
        }
      },
      "nvim-telescope/telescope-frecency.nvim",
      "fcying/telescope-ctags-outline.nvim",
      -- "nvim-telescope/telescope-ui-select.nvim"
    },
    config = function ()
      require('config.telescope')
    end
  },
  -- {
  --   "ibhagwan/fzf-lua",
  --   -- optional for icon support
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   config = function()
  --     -- calling `setup` is optional for customization
  --     require("fzf-lua").setup {}
  --   end,
  -- },
  {
    "MeanderingProgrammer/markdown.nvim",
    main = "render-markdown",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  },
  -- A list of colorscheme plugin you may want to try. Find what suits you.
  -- { "navarasu/onedark.nvim", lazy = true },
  -- { "sainnhe/edge", lazy = true },
  -- { "sainnhe/sonokai", lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
  -- { "sainnhe/everforest", lazy = true },
  -- { "EdenEast/nightfox.nvim", lazy = true },
  -- { "catppuccin/nvim", name = "catppuccin", lazy = true },
  -- { "olimorris/onedarkpro.nvim", lazy = true },
  -- { "marko-cerovac/material.nvim", lazy = true },
  -- {
  --   "rockyzhang24/arctic.nvim",
  --   dependencies = { "rktjmp/lush.nvim" },
  --   name = "arctic",
  --   branch = "v2",
  -- },
  -- { "rebelot/kanagawa.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    cond = firenvim_not_active,
    config = function()
      require("config.lualine")
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = { "BufEnter" },
    cond = firenvim_not_active,
    config = function()
      require("config.bufferline")
    end,
  },

  -- fancy start screen
  {
    "nvimdev/dashboard-nvim",
    cond = firenvim_not_active,
    config = function()
      require("config.dashboard-nvim")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    config = function()
      require("config.indent-blankline")
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    opts = {},
    config = function()
      require("config.nvim-statuscol")
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy",
    opts = {},
    init = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      require("config.nvim_ufo")
    end,
  },
  -- Highlight URLs inside vim
  { "itchyny/vim-highlighturl", event = "VeryLazy" },

  -- notification plugin
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      require("config.nvim-notify")
    end,
  },

  -- For Windows and Mac, we can open an URL in the browser. For Linux, it may
  -- not be possible since we maybe in a server which disables GUI.
  -- {
  --   "chrishrb/gx.nvim",
  --   keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
  --   cmd = { "Browse" },
  --   init = function()
  --     vim.g.netrw_nogx = 1 -- disable netrw gx
  --   end,
  --   enabled = function()
  --     if vim.g.is_win or vim.g.is_mac then
  --       return true
  --     else
  --       return false
  --     end
  --   end,
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = true, -- default settings
  --   submodules = false, -- not needed, submodules are required only for tests
  -- },

  -- Only install these plugins if ctags are installed on the system
  -- show file tags in vim window
  {
    "liuchengxu/vista.vim",
    enabled = function()
      if utils.executable("ctags") then
        return true
      else
        return false
      end
    end,
    cmd = "Vista",
  },

  -- Snippet engine and snippet template
  { "SirVer/ultisnips", dependencies = {
    "honza/vim-snippets",
  }, event = "InsertEnter" },

  -- Automatic insertion and deletion of a pair of characters
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Comment plugin
  { "tpope/vim-commentary", event = "VeryLazy" },

  -- Multiple cursor plugin like Sublime Text?
  -- 'mg979/vim-visual-multi'

  -- Autosave files on certain events
  { "907th/vim-auto-save", event = "InsertEnter" },

  -- Show undo history visually
  { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } },

  -- better UI for some nvim actions
  { "stevearc/dressing.nvim" },

  -- Manage your yank history
  {
    "gbprod/yanky.nvim",
    config = function()
      require("config.yanky")
    end,
    event = "VeryLazy",
  },

  -- Handy unix command inside Vim (Rename, Move etc.)
  { "tpope/vim-eunuch", cmd = { "Rename", "Delete" } },

  -- Repeat vim motions
  { "tpope/vim-repeat", event = "VeryLazy" },

  { "nvim-zh/better-escape.vim", event = { "InsertEnter" } },

  -- Keyboard layout switch (EN/CH)
  -- {
  --   "lyokha/vim-xkbswitch",
  --   enabled = function()
  --     if vim.g.is_mac and utils.executable("xkbswitch") then
  --       return true
  --     end
  --     return false
  --   end,
  --   event = { "InsertEnter" },
  -- },

  -- Language switch (EN/CH)
  -- {
  --   "Neur1n/neuims",
  --   enabled = function()
  --     if vim.g.is_win then
  --       return true
  --     end
  --     return false
  --   end,
  --   event = { "InsertEnter" },
  -- },

  -- Auto format tools
  { "sbdchd/neoformat", cmd = { "Neoformat" } },

  -- Git command inside vim
  {
    "tpope/vim-fugitive",
    event = "User InGitRepo",
    config = function()
      require("config.fugitive")
    end,
  },

  -- Better git log display
  { "rbong/vim-flog", cmd = { "Flog" } },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "ruifm/gitlinker.nvim",
    event = "User InGitRepo",
    config = function()
      require("config.git-linker")
    end,
  },

  -- Show git change (change, delete, add) signs in vim sign column
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.gitsigns")
    end,
  },

  -- Better git commit experience
  { "rhysd/committia.vim", lazy = true },

  {
    "sindrets/diffview.nvim",
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require("config.bqf")
    end,
  },

  -- Another markdown plugin
  { "preservim/vim-markdown", ft = { "markdown" } },

  -- Faster footnote generation
  { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } },

  -- Vim tabular plugin for manipulate tabular, required by markdown plugins
  { "godlygeek/tabular", cmd = { "Tabularize" } },

  -- Markdown previewing (only for Mac and Windows)
  {
    "iamcco/markdown-preview.nvim",
    enabled = function()
      if vim.g.is_win or vim.g.is_mac then
        return true
      end
      return false
    end,
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  {
    "rhysd/vim-grammarous",
    enabled = function()
      if vim.g.is_mac then
        return true
      end
      return false
    end,
    ft = { "markdown" },
  },

  { "chrisbra/unicode.vim", event = "VeryLazy" },

  -- Additional powerful text object for vim, this plugin should be studied
  -- carefully to use its full power
  { "wellle/targets.vim", event = "VeryLazy" },

  -- Plugin to manipulate character pairs quickly
  { "machakann/vim-sandwich", event = "VeryLazy" },

  -- Add indent object for vim (useful for languages like Python)
  { "michaeljsmith/vim-indent-object", event = "VeryLazy" },

  -- Only use these plugin on Windows and Mac and when LaTeX is installed
  {
    "lervag/vimtex",
    enabled = function()
      if utils.executable("latex") then
        return true
      end
      return false
    end,
    ft = { "tex" },
  },

  -- Since tmux is only available on Linux and Mac, we only enable these plugins
  -- for Linux and Mac
  -- .tmux.conf syntax highlighting and setting check
  {
    "tmux-plugins/vim-tmux",
    enabled = function()
      if utils.executable("tmux") then
        return true
      end
      return false
    end,
    ft = { "tmux" },
  },

  -- Modern matchit implementation
  { "andymass/vim-matchup", event = "BufRead" },
  { "tpope/vim-scriptease", cmd = { "Scriptnames", "Messages", "Verbose" } },

  -- Asynchronous command execution
  { "skywind3000/asyncrun.vim", lazy = true, cmd = { "AsyncRun" } },
  { "cespare/vim-toml", ft = { "toml" }, branch = "main" },

  -- Edit text area in browser using nvim
  {
    "glacambre/firenvim",
    enabled = function()
      local result = vim.g.is_win or vim.g.is_mac
      return result
    end,
    -- it seems that we can only call the firenvim function directly.
    -- Using vim.fn or vim.cmd to call this function will fail.
    build = function()
      local firenvim_path = plugin_dir .. "/firenvim"
      vim.opt.runtimepath:append(firenvim_path)
      vim.cmd("runtime! firenvim.vim")

      -- macOS will reset the PATH when firenvim starts a nvim process, causing the PATH variable to change unexpectedly.
      -- Here we are trying to get the correct PATH and use it for firenvim.
      -- See also https://github.com/glacambre/firenvim/blob/master/TROUBLESHOOTING.md#make-sure-firenvims-path-is-the-same-as-neovims
      local path_env = vim.env.PATH
      local prologue = string.format('export PATH="%s"', path_env)
      -- local prologue = "echo"
      local cmd_str = string.format(":call firenvim#install(0, '%s')", prologue)
      vim.cmd(cmd_str)
    end,
  },
  -- Debugger plugin
  -- {
  --   "sakhnik/nvim-gdb",
  --   enabled = function()
  --     if vim.g.is_win or vim.g.is_linux then
  --       return true
  --     end
  --     return false
  --   end,
  --   build = { "bash install.sh" },
  --   lazy = true,
  -- },

  -- Session management plugin
  -- { "tpope/vim-obsession", cmd = "Obsession" },

  {
    "ojroques/vim-oscyank",
    enabled = function()
      if vim.g.is_linux then
        return true
      end
      return false
    end,
    cmd = { "OSCYank", "OSCYankReg" },
  },

  -- The missing auto-completion for cmdline!
  {
    "gelguy/wilder.nvim",
    build = ":UpdateRemotePlugins",
  },

  -- showing keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("config.which-key")
    end,
  },

  -- show and trim trailing whitespaces
  { "jdhao/whitespace.nvim", event = "VeryLazy" },

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.nvim-tree")
    end,
  },

  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    tag = "v1.4.5",
    -- tag = "legacy",
    config = function()
      require("config.fidget-nvim")
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {},
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup {}
    end,
  },
  {
    "smjonas/live-command.nvim",
    -- live-command supports semantic versioning via Git tags
    -- tag = "2.*",
    cmd = "Preview",
    config = function()
      require("config.live-command")
    end,
    event = "VeryLazy",
  },
}

require("lazy").setup {
  spec = plugin_specs,
  ui = {
    border = "rounded",
    title = "Plugin Manager",
    title_pos = "center",
  },
  rocks = {
    enabled = false,
  },
}
