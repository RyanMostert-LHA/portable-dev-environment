-- Simple and reliable keypress display
return {
  -- Show keypresses in a floating window
  {
    "tamton-aquib/keys.nvim",
    event = "VeryLazy",
    config = function()
      require("keys").setup({
        enable_on_startup = true,
        display_time = 2500,
        display_char_count = 3,
        hide_in_insert = false,
        position = "top-right",
        border = "rounded",
        text_hl = "String",
        bg_hl = "Normal",
        border_hl = "FloatBorder",
        width = 25,
        height = 1,
      })
    end,
  },

  -- Enhanced mode display in statusline 
  {
    "AstroNvim/astroui",
    opts = function(_, opts)
      if not opts.status then opts.status = {} end
      if not opts.status.separators then opts.status.separators = {} end
      
      -- Add mode indicator with colors
      if not opts.status.attributes then opts.status.attributes = {} end
      opts.status.attributes.mode = {
        bold = true,
      }
      
      return opts
    end,
  },

  -- Toggle screenkey display with keybinding
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      if not opts.mappings then opts.mappings = {} end
      if not opts.mappings.n then opts.mappings.n = {} end
      
      -- Add keybinding to toggle keypress display
      opts.mappings.n["<Leader>uk"] = {
        function()
          local keys = require("keys")
          if keys.enabled then
            keys.disable()
            vim.notify("Keypress display disabled", vim.log.levels.INFO)
          else
            keys.enable()
            vim.notify("Keypress display enabled", vim.log.levels.INFO)
          end
        end,
        desc = "Toggle keypress display",
      }
      
      return opts
    end,
  },
}