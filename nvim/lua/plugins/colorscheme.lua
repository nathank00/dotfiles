return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("dracula").setup({
        transparent_bg = true,
        italic_comment = true,
        overrides = function(colors)
          return {
            NormalFloat = { bg = colors.menu },
            FloatBorder = { fg = colors.purple, bg = colors.menu },
            TelescopeNormal = { bg = colors.menu },
            TelescopeBorder = { fg = colors.purple, bg = colors.menu },
            TelescopePromptNormal = { bg = colors.bg },
            TelescopePromptBorder = { fg = colors.purple, bg = colors.bg },
            TelescopePromptTitle = { fg = colors.bg, bg = colors.purple },
            TelescopePreviewTitle = { fg = colors.bg, bg = colors.cyan },
            TelescopeResultsTitle = { fg = colors.bg, bg = colors.pink },
            WinSeparator = { fg = colors.selection, bg = "NONE" },
            CursorLine = { bg = colors.selection },
            LineNr = { fg = colors.comment },
            CursorLineNr = { fg = colors.purple, bold = true },
            GitSignsAdd = { fg = colors.green },
            GitSignsChange = { fg = colors.orange },
            GitSignsDelete = { fg = colors.red },
          }
        end,
      })
      vim.cmd.colorscheme("dracula")
    end,
  },
}
