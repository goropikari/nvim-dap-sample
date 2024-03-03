-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
require('lazy').setup({
    {
      'mfussenegger/nvim-dap',
      dependencies = {
        -- Creates a beautiful debugger UI
        'rcarriga/nvim-dap-ui',

        -- Add your own debuggers here
        'leoluz/nvim-dap-go',
      },

      config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'
        local go_dap_adapter_name = "delve"

        -- .vscode/launch.json に書かれた remote debug の設定を nvim-dap で使える形に変更する
        local function vscode_config_to_nvim_config()
          if dap.configurations.go == nil then
            return
          end

          for i, config in ipairs(dap.configurations.go) do
            if (config.type == "go" and config.mode == "remote") or (config.debugAdapter == "dlv-dap" and config.mode == "remote") then
              config.type = go_dap_adapter_name
              dap.configurations.go[i] = config
            end
          end
        end

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup()

        -- Install golang specific config
        require('dap-go').setup({
          dap_configurations = {
          },
          -- delve configurations
          delve = {
            path = "dlv",
            initialize_timeout_sec = 20,
            port = "${port}",
            args = {},
            build_flags = "",
          }
        })
        require('dap.ext.vscode').load_launchjs() -- .vscode/launch.json を読み込む
        vscode_config_to_nvim_config() -- 個別の config は .vscode/launch.json に書くとプロジェクトごとの設定にできる

        -- remote debug 用の adapter を動的に作る
        -- 書き方の例は後述
        dap.adapters[go_dap_adapter_name] = function(callback, config)
          callback({ type = 'server', host = config.host, port = config.port })
        end
        -- dap.adapters.delve = { -- ベタ書きする方法もある
        --   type = 'server',
        --   host = '127.0.0.1',
        --   port = 8081
        -- }
      end, -- nvim-dap config function end
    },
  },

  {
    performance = {
      rtp = {
        disabled_plugins = {
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          -- "netrwFileHandlers",
        },
      },
    },
  }
)
