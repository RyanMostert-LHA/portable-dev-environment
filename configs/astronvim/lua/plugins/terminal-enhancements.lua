-- Terminal and UI enhancements - FIXED VERSION
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

  -- Simple and reliable keypress display
  {
    "tamton-aquib/keys.nvim",
    event = "VeryLazy",
    config = function()
      require("keys").setup({
        enable_on_startup = true,
        display_time = 3000,
        display_char_count = 5,
        hide_in_insert = false,
        position = "top-right",
        border = "rounded",
        text_hl = "String",
        bg_hl = "Normal",
        border_hl = "FloatBorder",
        width = 30,
        height = 2,
      })
    end,
  },

  -- Mode display and UI enhancements
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      -- Add mode display keybinding
      if not opts.mappings then opts.mappings = {} end
      if not opts.mappings.n then opts.mappings.n = {} end
      
      -- Show current mode with detailed info
      opts.mappings.n["<Leader>uM"] = {
        function()
          local mode = vim.fn.mode()
          local mode_names = {
            n = "🟢 NORMAL",
            i = "🔵 INSERT", 
            v = "🟠 VISUAL",
            V = "🟡 V-LINE",
            ["\22"] = "🟣 V-BLOCK",
            c = "⚪ COMMAND",
            s = "🔴 SELECT",
            S = "🔴 S-LINE",
            ["\19"] = "🔴 S-BLOCK",
            R = "🔴 REPLACE",
            r = "🔴 REPLACE",
            Rv = "🔴 V-REPLACE",
            t = "💻 TERMINAL",
          }
          local mode_display = mode_names[mode] or ("❓ " .. mode:upper())
          vim.notify("Current Mode: " .. mode_display, vim.log.levels.INFO, { title = "Vim Mode" })
        end,
        desc = "Show current mode",
      }

      -- Toggle keypress display
      opts.mappings.n["<Leader>uk"] = {
        function()
          local ok, keys = pcall(require, "keys")
          if ok then
            if keys.enabled then
              keys.disable()
              vim.notify("🚫 Keypress display disabled", vim.log.levels.INFO)
            else
              keys.enable()
              vim.notify("👀 Keypress display enabled", vim.log.levels.INFO)
            end
          else
            vim.notify("❌ Keys plugin not available", vim.log.levels.ERROR)
          end
        end,
        desc = "Toggle keypress display",
      }

      -- Quick mode check
      opts.mappings.n["<Leader>um"] = {
        function()
          local mode = vim.fn.mode()
          local modes = { n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", c = "COMMAND", t = "TERMINAL" }
          vim.api.nvim_echo({{ "Mode: " .. (modes[mode] or mode), "Title" }}, false, {})
        end,
        desc = "Quick mode check",
      }
      
      return opts
    end,
  },
}