require("nvim-treesitter.configs").setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "python", "cpp", "lua", "vim", "json", "toml", "typescript", "javascript", "css", "markdown", "markdown_inline" },

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  ignore_install = {},    -- List of parsers to ignore installing
  highlight = {
    enable = true,        -- false will disable the whole extension
    disable = { 'help' }, -- list of language that will be disabled
  },
}
