-- Disable netrw in favor of neo-tree
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>e', ':Neotree reveal<CR>', desc = 'Explorer', silent = true },
  },
  opts = {
    sources = {
      'filesystem',
      'buffers',
      'git_status',
    },
    source_selector = {
      sources = {
        { source = 'filesystem' },
        { source = 'buffers' },
        { source = 'git_status' },
      },
    },
    modified = {
      symbol = '+',
      highlight = 'NeoTreeModified',
    },
    window = {
      auto_expand_width = true,
    },
    hijack_netrw_behavior = 'open_default',
    mappings = {
      ['<space>'] = 'none',
      ['o'] = {
        'open',
        nowait = true,
      },
      ['Oc'] = 'order_by_created',
      ['Od'] = 'order_by_diagnostics',
      ['Og'] = 'order_by_git_status',
      ['Om'] = 'order_by_modified',
      ['On'] = 'order_by_name',
      ['Os'] = 'order_by_size',
      ['Ot'] = 'order_by_type',
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      window = {
        group_empty_dirs = false,
        mappings = {
          ['\\'] = 'close_window',
          ['<leader>e'] = 'close_window',
          ['o'] = 'open',
          ['Oc'] = 'order_by_created',
          ['Od'] = 'order_by_diagnostics',
          ['Og'] = 'order_by_git_status',
          ['Om'] = 'order_by_modified',
          ['On'] = 'order_by_name',
          ['Os'] = 'order_by_size',
          ['Ot'] = 'order_by_type',

          ['<space>'] = false,
          ['oc'] = false,
          ['od'] = false,
          ['og'] = false,
          ['om'] = false,
          ['on'] = false,
          ['os'] = false,
          ['ot'] = false,
        },
      },
    },
  },
}
