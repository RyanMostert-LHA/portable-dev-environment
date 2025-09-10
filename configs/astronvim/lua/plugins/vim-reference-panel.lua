return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<F12>",
      function()
        -- Simple toggle: create or close vim reference window
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == 'vim-reference' then
            -- Found vim reference window, close it
            vim.api.nvim_win_close(win, false)
            return
          end
        end
        
        -- No vim reference window found, create one
        local content = {
          "╭─────────────────────────────────────╮",
          "│          VIM COMMANDS               │",
          "╰─────────────────────────────────────╯",
          "",
          "🚀 MOVEMENT",
          "─────────────────────────────────────",
          "  h j k l      ← ↓ ↑ → directions",
          "  w b e        word navigation",
          "  W B E        WORD navigation",
          "  ^ $ 0        line start/end/begin",
          "  gg G         file start/end",
          "  { }          paragraph up/down",
          "  ( )          sentence back/forward",
          "  % ctrl-d/u   bracket match/scroll",
          "",
          "✏️  EDITING",
          "─────────────────────────────────────",
          "  i a o        insert/append/open",
          "  I A O        insert line start/end/above",
          "  x X          delete char under/before",
          "  d dd dw      delete motion/line/word",
          "  c cc cw      change motion/line/word",
          "  y yy yw      yank motion/line/word",
          "  p P          paste after/before",
          "  u ctrl-r     undo/redo",
          "  .            repeat last command",
          "",
          "📄 BUFFERS",
          "─────────────────────────────────────",
          "  :e file      edit file",
          "  :bn :bp      next/previous buffer",
          "  :bd          close buffer",
          "  :ls          list buffers",
          "  ctrl-^       switch to last buffer",
          "",
          "🪟 WINDOWS",
          "─────────────────────────────────────",
          "  ctrl-w h/j/k/l   navigate splits",
          "  ctrl-w w         cycle windows",
          "  ctrl-w s/v       split horiz/vert",
          "  ctrl-w c/q       close window",
          "  ctrl-w +/-/</>   resize splits",
          "  ctrl-w =         equalize splits",
          "",
          "🔍 SEARCH",
          "─────────────────────────────────────",
          "  / ?          search forward/back",
          "  n N          next/previous match",
          "  * #          word under cursor",
          "  :noh         clear highlights",
          "",
          "💾 FILES",
          "─────────────────────────────────────",
          "  :w           save file",
          "  :q           quit",
          "  :wq :x       save and quit",
          "  :q!          quit without saving",
          "",
          "🎯 VISUAL MODE",
          "─────────────────────────────────────",
          "  v V ctrl-v   char/line/block select",
          "  y d c        yank/delete/change",
          "  > <          indent/unindent",
          "  =            auto-indent",
          "",
          "⚡ QUICK ACTIONS",
          "─────────────────────────────────────",
          "  zz zt zb     center/top/bottom",
          "  f F t T      find char forward/back",
          "  ; ,          repeat find forward/back",
          "  r R          replace char/mode",
          "  ~ g~         toggle case",
          "",
          "🔧 ASTRONVIM SPECIFIC",
          "─────────────────────────────────────",
          "  <Space>      Leader key",
          "  <Space>e     File explorer",
          "  <Space>ff    Find files",
          "  <Space>fw    Find words",
          "  <Space>gb    Git branches",
          "  <Space>gc    Git commits",
          "  <Space>th    Toggle terminal",
          "",
          "═══════════════════════════════════",
          "  Press <F12> to toggle this panel",
          "═══════════════════════════════════",
        }
        
        -- Create buffer and set content
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
        vim.bo[buf].modifiable = false
        vim.bo[buf].buftype = 'nofile'
        vim.bo[buf].bufhidden = 'wipe'
        vim.bo[buf].swapfile = false
        vim.bo[buf].filetype = 'vim-reference'
        vim.api.nvim_buf_set_name(buf, 'Vim Reference')
        
        -- Create window on the right side
        local width = 42
        local height = vim.o.lines - 4
        local win = vim.api.nvim_open_win(buf, false, {
          relative = 'editor',
          width = width,
          height = height,
          col = vim.o.columns - width,
          row = 1,
          style = 'minimal',
          border = 'rounded',
          title = ' Vim Reference ',
          title_pos = 'center',
        })
        
        -- Set window options
        vim.wo[win].wrap = false
        vim.wo[win].number = false
        vim.wo[win].relativenumber = false
        vim.wo[win].signcolumn = 'no'
        vim.wo[win].cursorline = false
      end,
      desc = "Toggle Vim Reference Panel",
    },
  },
  opts = {
    -- We'll use simple floating window instead of edgy sidebar for now
    right = {},
  },
  config = function(_, opts)
    require("edgy").setup(opts)
    
    -- Set up highlighting for the reference panel
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "vim-reference",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        
        -- Apply syntax highlighting
        vim.api.nvim_buf_call(buf, function()
          vim.cmd([[syntax match VimRefTitle "^╭.*╮\|^│.*│\|^╰.*╯\|^═.*═"]])
          vim.cmd([[syntax match VimRefSection "^🚀\|^✏️\|^📄\|^🪟\|^🔍\|^💾\|^🎯\|^⚡\|^🔧"]])
          vim.cmd([[syntax match VimRefSeparator "^─.*─"]])
          vim.cmd([[syntax match VimRefCommand "^\s\+[a-zA-Z<>^*#/:~={}()%.-]\+"]])
          vim.cmd([[syntax match VimRefDescription "\s\s.*$" contained]])
          vim.cmd([[syntax match VimRefKeybind "^\s*Press.*$"]])
          
          vim.cmd([[highlight VimRefTitle guifg=#7dcfff gui=bold]])
          vim.cmd([[highlight VimRefSection guifg=#ff9e64 gui=bold]])
          vim.cmd([[highlight VimRefSeparator guifg=#565f89]])
          vim.cmd([[highlight VimRefCommand guifg=#9ece6a gui=bold]])
          vim.cmd([[highlight VimRefDescription guifg=#c0caf5]])
          vim.cmd([[highlight VimRefKeybind guifg=#bb9af7 gui=italic]])
        end)
      end,
    })
  end,
}