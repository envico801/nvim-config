require("neorg").setup {
  load = {
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          notes = "~/notes",
        },
        default_workspace = "notes",
      },
    },
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp", -- or "coq_nvim" or "nvim-compe" depending on which you use
      },
    },
    ["core.dirman.utils"] = {},
    ["core.integrations.treesitter"] = {},
  },
}

vim.wo.foldlevel = 99
vim.wo.conceallevel = 2
