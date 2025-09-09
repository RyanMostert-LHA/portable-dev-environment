-- Mode indicator and keypress display plugins
return {
  -- Show which keys you're pressing
  {
    "folke/which-key.nvim",
    opts = {
      show_help = true,
      show_keys = true,
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      triggers = "auto",
      popup_mappings = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      window = {
        border = "rounded",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 1, 2, 1, 2 },
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      ignore_missing = true,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
      show_help_popup = true,
      triggers_blacklist = {
        i = { "j", "k" },
        v = { "j", "k" },
      },
    },
  },

  -- Show current mode in statusline
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.sections then opts.sections = {} end
      if not opts.sections.lualine_a then opts.sections.lualine_a = {} end
      
      -- Add mode with icons
      table.insert(opts.sections.lualine_a, {
        "mode",
        fmt = function(str)
          local mode_icons = {
            ["NORMAL"] = "🅽 ",
            ["INSERT"] = "🅸 ",
            ["VISUAL"] = "🆅 ",
            ["V-LINE"] = "🆅 ",
            ["V-BLOCK"] = "🆅 ",
            ["COMMAND"] = "🅲 ",
            ["SELECT"] = "🆂 ",
            ["REPLACE"] = "🆁 ",
            ["TERMINAL"] = "🆃 ",
          }
          return (mode_icons[str] or "⚡ ") .. str
        end,
      })
      
      return opts
    end,
  },

  -- Show keystrokes in real-time
  {
    "NStefan002/screenkey.nvim",
    lazy = false,
    version = "*",
    config = function()
      require("screenkey").setup({
        win_opts = {
          row = vim.o.lines - 3,
          col = vim.o.columns - 40,
          relative = "editor",
          anchor = "NE",
          width = 40,
          height = 1,
          border = "rounded",
          title = " Keys ",
          title_pos = "center",
          style = "minimal",
          focusable = false,
          noautocmd = true,
        },
        compress_after = 3,
        clear_after = 3,
        disable = {
          filetypes = {},
          buftypes = {},
        },
        show_leader = true,
        group_mappings = true,
        display_infront = {},
        display_behind = {},
        filter = function(keys)
          -- Hide some noise
          if keys == "y" or keys == "d" or keys == "c" then
            return false
          end
          return true
        end,
        keys = {
          ["<TAB>"] = "⇥",
          ["<CR>"] = "⏎",
          ["<ESC>"] = "⎋",
          ["<SPACE>"] = "␣",
          ["<BS>"] = "⌫",
          ["<DEL>"] = "⌦",
          ["<LEFT>"] = "←",
          ["<RIGHT>"] = "→",
          ["<UP>"] = "↑",
          ["<DOWN>"] = "↓",
          ["<HOME>"] = "⇱",
          ["<END>"] = "⇲",
          ["<PAGEUP>"] = "⇞",
          ["<PAGEDOWN>"] = "⇟",
          ["<INSERT>"] = "⎀",
          ["<F1>"] = "󱊫",
          ["<F2>"] = "󱊬",
          ["<F3>"] = "󱊭",
          ["<F4>"] = "󱊮",
          ["<F5>"] = "󱊯",
          ["<F6>"] = "󱊰",
          ["<F7>"] = "󱊱",
          ["<F8>"] = "󱊲",
          ["<F9>"] = "󱊳",
          ["<F10>"] = "󱊴",
          ["<F11>"] = "󱊵",
          ["<F12>"] = "󱊶",
        },
      })
    end,
  },

  -- Better mode indicator in command line
  {
    "folke/noice.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.views then opts.views = {} end
      if not opts.views.cmdline then opts.views.cmdline = {} end
      
      opts.views.cmdline.position = {
        row = "50%",
        col = "50%",
      }
      
      if not opts.lsp then opts.lsp = {} end
      if not opts.lsp.override then opts.lsp.override = {} end
      
      opts.lsp.override["vim.lsp.util.convert_input_to_markdown_lines"] = true
      opts.lsp.override["vim.lsp.util.stylize_markdown"] = true
      opts.lsp.override["cmp.entry.get_documentation"] = true
      
      return opts
    end,
  },
}