return {
  -- Automatically closes pairs '' "" () [] {}
  require 'plugins.autopairs',

  -- Autocompletion for when you type
  require 'plugins.blink',

  -- zes the colorscheme
  require 'plugins.colorscheme',

  -- Used for buffer formatting
  require 'plugins.conform',

  -- Add debugging capabilities
  require 'plugins.debug',

  -- Git signs inside the buffer
  require 'plugins.gitsigns',

  -- Guesses the correct indentation when you add new lines
  require 'plugins.indent-line',

  -- LSP Plugin for lua inside Neovim
  require 'plugins.lazydev',

  -- Linters for analyzing code errors or bad practices
  require 'plugins.lint',

  -- LSP Configuration, where all the magic happens
  require 'plugins.lspconfig',

  -- Collection of small but useful plugins
  require 'plugins.mini',

  -- File explorer
  require 'plugins.neo-tree',

  -- Replacement for Telescope
  require 'plugins.snacks',

  -- Fuzzy Finder (files, lsp, etc)
  -- require 'plugins.telescope',

  -- Highlight todo, notes, etc in comments
  require 'plugins.todo-comments',

  -- Highlighting for specific languages
  require 'plugins.treesitter',

  -- Improves undodir for lenghty filepaths
  require 'plugins.undodir-tree',

  -- Detect tabstop and shiftwidth automatically
  require 'plugins.vim-sleuth',

  -- Shows a preview of the available keybinds
  require 'plugins.which-key',
}
