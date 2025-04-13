local function get_jdtls()
  local mason_registry = require 'mason-registry'
  local jdtls = mason_registry.get_package 'jdtls'
  local jdtls_path = jdtls:get_install_path()

  local launcher = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
  local lombok = jdtls_path .. '/lombok.jar'

  local platform_config

  if vim.fn.has 'unix' == 1 then
    platform_config = jdtls_path .. '/config_linux'
  elseif vim.fn.has 'win32' == 1 then
    platform_config = jdtls_path .. '/config_win'
  end

  return launcher, platform_config, lombok
end

local function get_bundles()
  local mason_registry = require 'mason-registry'
  local java_debug = mason_registry.get_package 'java-debug-adapter'
  local java_debug_path = java_debug:get_install_path()

  local bundles = {
    vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', true),
  }

  local java_test = mason_registry.get_package 'java-test'
  local java_test_path = java_test:get_install_path()
  vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. '/extension/server/*.jar', true), '\n'))

  return bundles
end

local function get_workspace()
  local platform_home

  if vim.fn.has 'unix' == 1 then
    platform_home = os.getenv 'HOME'
  elseif vim.fn.has 'win32' == 1 then
    platform_home = os.getenv 'USERPROFILE'
  end

  local workspace_path = platform_home .. '/code/workspace/'
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workspace_dir = workspace_path .. project_name

  return workspace_dir
end

local function java_keymaps()
  vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
  vim.cmd "command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()"
  vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"
  vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

  vim.keymap.set('n', '<leader>jo', "<Cmd> lua require('jdtls').organize_imports()<CR>", { desc = 'Organize imports' })
  vim.keymap.set('n', '<leader>ju', '<Cmd> JdtUpdateConfig<CR>', { desc = 'Update configurations' })
  vim.keymap.set('n', '<leader>jT', "<Cmd> lua require('jdtls').test_class()<CR>", { desc = 'Test class' })

  vim.keymap.set('n', '<leader>jv', "<Cmd> lua require('jdtls').extract_variable()<CR>", { desc = 'Extract variable' })
  vim.keymap.set('v', '<leader>jv', "<Esc><Cmd> lua require('jdtls').extract_variable(true)<CR>", { desc = 'Extract variable' })

  vim.keymap.set('n', '<leader>jC', "<Cmd> lua require('jdtls').extract_constant()<CR>", { desc = 'Extract constant' })
  vim.keymap.set('v', '<leader>jC', "<Esc><Cmd> lua require('jdtls').extract_constant(true)<CR>", { desc = 'Extract constant' })

  vim.keymap.set('n', '<leader>jt', "<Cmd> lua require('jdtls').test_nearest_method()<CR>", { desc = 'Test method' })
  vim.keymap.set('v', '<leader>jt', "<Esc><Cmd> lua require('jdtls').test_nearest_method(true)<CR>", { desc = 'Test method' })
end

local function setup_jdtls()
  local jdtls = require 'jdtls'

  local launcher, os_config, lombok = get_jdtls()
  local workspace_dir = get_workspace()
  local bundles = get_bundles()

  local root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew' }

  local capabilities = require('blink.cmp').get_lsp_capabilities()

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  local java_home

  if vim.fn.has 'unix' == 1 then
    java_home = 'replace here the java path on linux'
  elseif vim.fn.has 'win32' == 1 then
    java_home = 'C:/Program Files/Java/'
  end

  local cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',

    -- Use this for debugging issues instead of level=INFO
    -- "-Dlog.protocol=true",
    -- "-Dlog.level=ALL",
    '-Dlog.level=INFO',

    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    '-javaagent:' .. lombok,
    '-jar',
    launcher,
    '-configuration',
    os_config,
    '-data',
    workspace_dir,
  }

  local settings = {
    java = {
      jdt = {
        ls = {
          java = { home = 'C:/Program Files/Java/jdk-21/' },
          vmargs = '-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx3G -Xms256m',
        },
      },
      server = {
        launchMode = 'Hybrid',
      },
      format = {
        enabled = true,
      },
      eclipse = {
        downloadSource = true,
      },
      maven = {
        downloadSources = true,
      },
      signatureHelp = {
        enabled = true,
      },
      contentProvider = {
        preferred = 'fernflower',
      },
      saveActions = {
        organizeImports = false,
      },
      completion = {
        favoriteStaticMembers = {
          'org.hamcrest.MatcherAssert.assertThat',
          'org.hamcrest.Matchers.*',
          'org.hamcrest.CoreMatchers.*',
          'org.junit.jupiter.api.Assertions.*',
          'java.util.Objects.requireNonNull',
          'java.util.Objects.requireNonNullElse',
          'org.mockito.Mockito.*',
        },
        filteredTypes = {
          'com.sun.*',
          'io.micrometer.shaded.*',
          'java.awt.*',
          'jdk.*',
          'sun.*',
        },
        importOrder = {
          'java',
          'jakarta',
          'javax',
          'com',
          'org',
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = 'JavaSE-21',
            path = java_home .. 'jdk-21/',
          },
          -- {
          --   name = 'JavaSE-17',
          --   path = java_home .. 'jdk-17/',
          -- },
        },
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        enabled = true,
      },
    },
  }

  local init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  }

  local on_attach = function(client, bufnr)
    java_keymaps()

    -- Enable debugger
    require('jdtls.dap').setup_dap { hotcodereplace = 'auto' }
    require('jdtls.dap').setup_dap_main_class_configs()

    require('jdtls.setup').add_commands()

    -- Disable semantic tokens because it breaks colorschemes
    client.server_capabilities.semanticTokensProvider = nil

    pcall(vim.lsp.codelens.refresh)
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = { '*.java' },
      callback = function()
        pcall(vim.lsp.codelens.refresh)
      end,
    })
  end

  local config = {
    cmd = cmd,
    root_dir = root_dir,
    settings = settings,
    capabilities = capabilities,
    init_options = init_options,
    on_attach = on_attach,
  }

  require('jdtls').start_or_attach(config)
end

setup_jdtls()
