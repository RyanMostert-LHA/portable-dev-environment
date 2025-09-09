-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- Cheatsheet keybinding
        ["<Leader>?"] = { 
          function() 
            vim.cmd("edit " .. vim.fn.stdpath("config") .. "/cheatsheet.md")
          end, 
          desc = "Open Cheatsheet" 
        },

        -- Quick start guide for beginners
        ["<Leader>h?"] = { 
          function() 
            vim.cmd("edit " .. vim.fn.stdpath("config") .. "/quick-start.md")
          end, 
          desc = "Quick Start Guide" 
        },

        -- Fix commenting keybindings
        ["<Leader>/"] = {
          function()
            return vim.api.nvim_get_current_line():match("^%s*$") and "o" or "gcc"
          end,
          desc = "Toggle comment line",
          expr = true,
        },

        -- Terminal keybindings
        ["<C-\\>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
        ["<Leader>tf"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
        ["<Leader>th"] = { "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal terminal" },
        ["<Leader>tv"] = { "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Vertical terminal" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
      v = {
        -- Visual mode commenting
        ["<Leader>/"] = { "gc", desc = "Toggle comment", remap = true },
      },
      t = {
        -- Terminal mode mappings
        ["<C-\\>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
        ["<Esc><Esc>"] = { "<C-\\><C-n>", desc = "Exit terminal mode" },
      },
      i = {
        -- Insert mode mappings
        ["<C-\\>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      },
    },
  },
}
