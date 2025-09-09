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

  -- Custom keypress display using built-in Neovim features
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      -- Initialize keypress display state
      vim.g.keypress_display_enabled = false
      vim.g.keypress_win = nil
      vim.g.keypress_buf = nil

      -- Create keypress display functions
      local function create_keypress_window()
        if vim.g.keypress_buf and vim.api.nvim_buf_is_valid(vim.g.keypress_buf) then
          vim.api.nvim_buf_delete(vim.g.keypress_buf, { force = true })
        end

        vim.g.keypress_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(vim.g.keypress_buf, 'bufhidden', 'wipe')
        vim.api.nvim_buf_set_option(vim.g.keypress_buf, 'filetype', 'keypress')

        local width = 30
        local height = 2
        vim.g.keypress_win = vim.api.nvim_open_win(vim.g.keypress_buf, false, {
          relative = 'editor',
          anchor = 'NE',
          width = width,
          height = height,
          col = vim.o.columns,
          row = 0,
          style = 'minimal',
          border = 'rounded',
          title = ' Keys ',
          title_pos = 'center',
          focusable = false,
          zindex = 100,
        })

        vim.api.nvim_win_set_option(vim.g.keypress_win, 'winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder')
      end

      local function show_keypress(key)
        if not vim.g.keypress_display_enabled then return end
        
        if not vim.g.keypress_win or not vim.api.nvim_win_is_valid(vim.g.keypress_win) then
          create_keypress_window()
        end

        -- Format the key display
        local display_key = key
        if key == ' ' then display_key = '󱁐 SPACE' 
        elseif key == '\r' or key == '\n' then display_key = '⏎ ENTER'
        elseif key == '\27' then display_key = ' ESC'
        elseif key == '\t' then display_key = '󰌒 TAB'
        end

        -- Update the window content
        vim.api.nvim_buf_set_lines(vim.g.keypress_buf, 0, -1, false, {
          ' Last Key: ' .. display_key,
          ' Mode: ' .. string.upper(vim.fn.mode())
        })

        -- Auto-hide after 3 seconds
        vim.defer_fn(function()
          if vim.g.keypress_win and vim.api.nvim_win_is_valid(vim.g.keypress_win) then
            vim.api.nvim_buf_set_lines(vim.g.keypress_buf, 0, -1, false, {
              ' Waiting for keys...',
              ' Mode: ' .. string.upper(vim.fn.mode())
            })
          end
        end, 3000)
      end

      -- Set up keypress capture
      vim.on_key(function(key, typed)
        if typed and vim.g.keypress_display_enabled then
          show_keypress(typed)
        end
      end)

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
          vim.g.keypress_display_enabled = not vim.g.keypress_display_enabled
          
          if vim.g.keypress_display_enabled then
            create_keypress_window()
            vim.notify("👀 Keypress display enabled", vim.log.levels.INFO)
          else
            if vim.g.keypress_win and vim.api.nvim_win_is_valid(vim.g.keypress_win) then
              vim.api.nvim_win_close(vim.g.keypress_win, true)
            end
            vim.notify("🚫 Keypress display disabled", vim.log.levels.INFO)
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