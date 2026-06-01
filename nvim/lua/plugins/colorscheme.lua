return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = false },
        },
        on_colors = function(colors)
          colors.bg = "#15101E"
          colors.bg_dark = "#110d1a"
          colors.bg_sidebar = "#110d1a"
        end,
      })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}
