local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'suketa/nvim-dap-ruby',
})

-- [[ Configuration DAP ]]
local dap = require 'dap'
local dapui = require 'dapui'
dapui.setup()

local ruby_dap_adapter_name = "rdbg"

-- .vscode/launch.json に書かれた remote debug の設定を nvim-dap で使える形に変更する
local function vscode_config_to_nvim_config()
  -- [[ ruby ]]
  if dap.configurations.ruby ~= nil then
    for i, config in ipairs(dap.configurations.ruby) do
      if config.mode == "remote" or (config.debugAdapter == "rdbg" and config.mode == "remote") or config.debugPort ~= nil then
        config.type = ruby_dap_adapter_name
        dap.configurations.ruby[i] = config
      end
    end
  end
  if dap.configurations.rdbg ~= nil then
    for _, config in ipairs(dap.configurations.rdbg) do
      table.insert(dap.configurations.ruby, config)
    end
  end
end


dap.listeners.after.event_initialized['dapui_config'] = dapui.open
-- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

require('dap-ruby').setup()
require('dap.ext.vscode').load_launchjs() -- .vscode/launch.json を読み込む
vscode_config_to_nvim_config()            -- すべての config が読み込まれたあとに実行する

-- remote debug 用の adapter を作る
-- 個別の config は .vscode/launch.json に書くとプロジェクトごとの設定にできる
-- 書き方の例は後述
local function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

dap.adapters[ruby_dap_adapter_name] = function(callback, config)
  if config.port ~= nil then
    callback({ type = 'server', host = config.host, port = config.port })
  elseif config.debugPort ~= nil then
    local t = split(config.debugPort, ':')
    local host = t[1]
    local port = t[2]
    callback({ type = 'server', host = host, port = port })
  else
    callback({ type = 'server', host = 'localhost', port = 12345 })
  end
end

