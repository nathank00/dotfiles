return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Auto-open when nvim is started on a directory
      local function open_nvim_tree(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
          require("nvim-tree.api").tree.open()
        end
      end
      vim.api.nvim_create_autocmd("VimEnter", { callback = open_nvim_tree })

      require("nvim-tree").setup({
        view = { width = 32 },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            glyphs = {
              git = {
                unstaged = "✦",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        filters = { dotfiles = false },
        git = { enable = true },
        actions = { open_file = { quit_on_open = false } },
      })
    end,
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = false,
        columns = { "icon", "permissions", "size" },
        view_options = { show_hidden = true },
        float = {
          padding = 4,
          border = "rounded",
        },
      })
      vim.keymap.set("n", "-", "<cmd>Oil --float<cr>", { desc = "Open parent dir (oil)" })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local colors = {
        bg = "#282A36",
        selection = "#44475A",
        comment = "#6272A4",
        purple = "#BD93F9",
        fg = "#F8F8F2",
        black = "#21222C",
      }
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "thin",
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = false,
          offsets = {
            {
              filetype = "NvimTree",
              text = "Explorer",
              text_align = "center",
              separator = false,
            },
          },
        },
        highlights = {
          fill = { bg = colors.black },
          background = { fg = colors.comment, bg = colors.black },
          buffer_selected = { fg = colors.fg, bg = colors.bg, bold = true },
          buffer_visible = { fg = colors.comment, bg = colors.black },
          separator = { fg = colors.black, bg = colors.black },
          separator_selected = { fg = colors.black, bg = colors.bg },
          indicator_selected = { fg = colors.purple, bg = colors.bg },
          modified_selected = { fg = colors.purple, bg = colors.bg },
        },
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local dracula = {
        bg       = "#282A36",
        fg       = "#F8F8F2",
        purple   = "#BD93F9",
        cyan     = "#8BE9FD",
        green    = "#50FA7B",
        orange   = "#FFB86C",
        pink     = "#FF79C6",
        red      = "#FF5555",
        yellow   = "#F1FA8C",
        comment  = "#6272A4",
        selection = "#44475A",
        black    = "#21222C",
      }

      local theme = {
        normal   = { a = { fg = dracula.black, bg = dracula.purple, gui = "bold" }, b = { fg = dracula.fg, bg = dracula.selection }, c = { fg = dracula.comment, bg = "NONE" } },
        insert   = { a = { fg = dracula.black, bg = dracula.cyan, gui = "bold" },   b = { fg = dracula.fg, bg = dracula.selection } },
        visual   = { a = { fg = dracula.black, bg = dracula.pink, gui = "bold" },   b = { fg = dracula.fg, bg = dracula.selection } },
        replace  = { a = { fg = dracula.black, bg = dracula.red, gui = "bold" },    b = { fg = dracula.fg, bg = dracula.selection } },
        command  = { a = { fg = dracula.black, bg = dracula.green, gui = "bold" },  b = { fg = dracula.fg, bg = dracula.selection } },
        inactive = { a = { fg = dracula.comment, bg = "NONE" },                     b = { fg = dracula.comment, bg = "NONE" }, c = { fg = dracula.comment, bg = "NONE" } },
      }

      require("lualine").setup({
        options = {
          theme = theme,
          component_separators = "",
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", { "diff", symbols = { added = " ", modified = " ", removed = " " } } },
          lualine_c = { { "filename", path = 1, symbols = { modified = "  ", readonly = " ", unnamed = "" } } },
          lualine_x = { { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } }, "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = { "c", "cpp", "python", "lua", "cmake", "bash", "markdown", "markdown_inline", "json", "yaml", "toml", "typescript", "javascript" },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local map = function(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end
          map("n", "]h", gs.next_hunk, "Next hunk")
          map("n", "[h", gs.prev_hunk, "Prev hunk")
          map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
          map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
          map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
          map("n", "<leader>hd", gs.diffthis, "Diff this")
        end,
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│", highlight = "IblIndent" },
        scope = { enabled = true, highlight = "IblScope" },
      })
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#44475A" })
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#6272A4" })
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        win = { border = "rounded" },
      })
      require("which-key").add({
        { "<leader>f", group = "Find" },
        { "<leader>h", group = "Git hunks" },
        { "<leader>b", group = "Buffer" },
        { "<leader>l", group = "LSP" },
        { "<leader>t", group = "Terminal" },
        { "<leader>x", group = "Trouble" },
      })
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
    end,
  },
}
