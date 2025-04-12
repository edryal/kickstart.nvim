local macro_recording = function()
  local reg = vim.fn.reg_recording()
  if reg ~= '' then
    return 'Recording @' .. reg
  end
  return ''
end

return {
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'

    -- Don't show statusline for these filetypes
    local blocked_filetypes = {
      ['neo-tree'] = true,
      ['NvimTree'] = true,
    }

    statusline.setup {
      -- set use_icons to true if you have a Nerd Font
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          if blocked_filetypes[vim.bo.filetype] then
            return ''
          end

          local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
          local git = MiniStatusline.section_git { trunc_width = 40 }
          local diff = MiniStatusline.section_diff { trunc_width = 75 }
          local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
          local filename = '%t'
          local location = MiniStatusline.section_location { trunc_width = 75 }
          local lsp = MiniStatusline.section_lsp { trunc_width = 75 }

          return MiniStatusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, macro_recording() } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { lsp } },
            { hl = mode_hl, strings = { location } },
          }
        end,
      },
    }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
