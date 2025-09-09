-- Enhanced commenting configuration for AstroNvim
return {
  -- Override default commenting behavior
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      -- Ensure commenting mappings are properly set
      if not opts.mappings then opts.mappings = {} end
      if not opts.mappings.n then opts.mappings.n = {} end
      if not opts.mappings.v then opts.mappings.v = {} end
      if not opts.mappings.x then opts.mappings.x = {} end

      -- Normal mode commenting
      opts.mappings.n["gcc"] = { 
        function()
          local line = vim.api.nvim_get_current_line()
          if line:match("^%s*$") then
            return "o"
          else
            return "gcc"
          end
        end,
        desc = "Toggle comment line",
        expr = true,
      }

      -- Visual mode commenting
      opts.mappings.v["gc"] = { "gc", desc = "Toggle comment", remap = true }
      opts.mappings.x["gc"] = { "gc", desc = "Toggle comment", remap = true }

      return opts
    end,
  },

  -- Add nvim-comment as a fallback if built-in commenting fails
  {
    "terrortylor/nvim-comment",
    lazy = false,
    config = function()
      require("nvim_comment").setup({
        -- Add any configuration you want
        marker_padding = true,
        comment_empty = false,
        comment_empty_trim_whitespace = true,
        create_mappings = false, -- We'll create our own
        line_mapping = "gcc",
        operator_mapping = "gc",
        comment_chunk_text_object = "ic",
      })
    end,
  },
}