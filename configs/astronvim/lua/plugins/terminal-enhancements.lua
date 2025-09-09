-- Terminal and UI enhancements
return {
  -- Enhanced terminal with proper keybindings
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>", "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal", mode = { "n", "t" } },
      { "<Leader>tf", "<Cmd>ToggleTerm direction=float<CR>", desc = "Float terminal" },
      { "<Leader>th", "<Cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
      { "<Leader>tv", "<Cmd>ToggleTerm direction=vertical<CR>", desc = "Vertical terminal" },
      { "<Leader>t", "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      winbar = {
        enabled = false,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      
      -- Terminal mode keymaps
      function _G.set_terminal_keymaps()
        local opt = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opt)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opt)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opt)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opt)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opt)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opt)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opt)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
  },

  -- Show keypresses and mode indicator
  {
    "NStefan002/screenkey.nvim", 
    lazy = false,
    version = "*", -- or branch = "dev", to use the latest commit
    config = function()
      require("screenkey").setup({
        win_opts = {
          relative = "editor",
          anchor = "NE",
          width = 40,
          height = 3,
          col = vim.o.columns - 1,
          row = 1,
          border = "single",
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
          return keys
        end,
        keys = {
          ["<TAB>"] = "󰌒",
          ["<CR>"] = "⏎",
          ["<ESC>"] = "Esc",
          ["<SPACE>"] = "󱁐",
          ["<BS>"] = "⌫",
          ["<DEL>"] = "⌦",
          ["<LEFT>"] = "",
          ["<RIGHT>"] = "",
          ["<UP>"] = "",
          ["<DOWN>"] = "",
          ["<HOME>"] = "Home",
          ["<END>"] = "End",
          ["<PAGEUP>"] = "PgUp",
          ["<PAGEDOWN>"] = "PgDn",
          ["<INSERT>"] = "Ins",
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

  -- Enhanced mode indicator in statusline
  {
    "AstroNvim/astroui",
    opts = function(_, opts)
      -- Ensure status table exists
      if not opts.status then opts.status = {} end
      if not opts.status.separators then opts.status.separators = {} end
      
      -- Add mode colors and indicators
      opts.status.separators.left = { "", "" }
      opts.status.separators.right = { "", "" }
      
      return opts
    end,
  },

  -- Show current mode prominently
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      -- Add mode display keybinding
      if not opts.mappings then opts.mappings = {} end
      if not opts.mappings.n then opts.mappings.n = {} end
      
      opts.mappings.n["<Leader>uM"] = {
        function()
          local mode = vim.fn.mode()
          local mode_names = {
            n = "NORMAL",
            i = "INSERT", 
            v = "VISUAL",
            V = "V-LINE",
            ["\22"] = "V-BLOCK",
            c = "COMMAND",
            s = "SELECT",
            S = "S-LINE",
            ["\19"] = "S-BLOCK",
            R = "REPLACE",
            r = "REPLACE",
            Rv = "V-REPLACE",
            t = "TERMINAL",
          }
          vim.notify("Current Mode: " .. (mode_names[mode] or mode:upper()), vim.log.levels.INFO)
        end,
        desc = "Show current mode",
      }
      
      return opts
    end,
  },
}