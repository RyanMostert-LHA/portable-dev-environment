-- AstroNvim User Configuration
-- This file configures AstroNvim with sensible defaults for the portable dev environment

return {
  -- Set colorscheme
  colorscheme = "astrodark",
  
  -- Configure AstroNvim options
  options = {
    opt = {
      -- Line numbers
      relativenumber = true,    -- Show relative line numbers
      number = true,            -- Show current line number
      
      -- Indentation
      tabstop = 2,              -- Tab width
      shiftwidth = 2,           -- Indent width
      expandtab = true,         -- Use spaces instead of tabs
      smartindent = true,       -- Smart indentation
      
      -- Text wrapping
      wrap = false,             -- Disable line wrapping
      linebreak = true,         -- Wrap at word boundaries
      
      -- Search
      ignorecase = true,        -- Ignore case in search
      smartcase = true,         -- Case sensitive if uppercase present
      
      -- Visual
      cursorline = true,        -- Highlight current line
      signcolumn = "yes",       -- Always show sign column
      colorcolumn = "80",       -- Show column at 80 characters
      
      -- Behavior
      clipboard = "unnamedplus", -- Use system clipboard
      mouse = "a",              -- Enable mouse support
      scrolloff = 8,            -- Keep 8 lines above/below cursor
      sidescrolloff = 8,        -- Keep 8 columns left/right of cursor
      
      -- Performance
      updatetime = 250,         -- Faster completion
      timeoutlen = 300,         -- Faster key sequence completion
    },
  },
  
  -- Configure key mappings
  mappings = {
    n = {
      -- Better window navigation
      ["<C-h>"] = { "<C-w>h", desc = "Move to left window" },
      ["<C-j>"] = { "<C-w>j", desc = "Move to bottom window" },
      ["<C-k>"] = { "<C-w>k", desc = "Move to top window" },
      ["<C-l>"] = { "<C-w>l", desc = "Move to right window" },
      
      -- Buffer navigation
      ["<S-l>"] = { function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer" },
      ["<S-h>"] = { function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer" },
      
      -- Quick save
      ["<leader>w"] = { "<cmd>w<cr>", desc = "Save file" },
      
      -- Clear search highlighting
      ["<leader>h"] = { "<cmd>nohlsearch<cr>", desc = "Clear search highlighting" },
    },
    
    -- Terminal mode mappings
    t = {
      ["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "Move to left window" },
      ["<C-j>"] = { "<cmd>wincmd j<cr>", desc = "Move to bottom window" },
      ["<C-k>"] = { "<cmd>wincmd k<cr>", desc = "Move to top window" },
      ["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "Move to right window" },
    },
  },
  
  -- Configure LSP settings
  lsp = {
    -- Configure language servers
    config = {
      -- Python
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoImportCompletions = true,
            },
          },
        },
      },
      
      -- JavaScript/TypeScript
      tsserver = {
        settings = {
          typescript = {
            preferences = {
              disableSuggestions = false,
            },
          },
        },
      },
    },
    
    -- Configure formatting
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {
          "python",
          "javascript",
          "typescript",
          "lua",
          "json",
          "yaml",
          "markdown",
        },
      },
    },
  },
  
  -- Configure which plugins to disable if needed
  plugins = {
    -- Example: disable a plugin
    -- ["plugin-name"] = false,
  },
}