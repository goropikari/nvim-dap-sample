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

require('lazy').setup({
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
})

-- -- [[ Configuration DAP ]]
local dap = require 'dap'
local dapui = require 'dapui'

local function vscode_config_to_nvim_config()
  -- [[ c++ ]]
  if dap.configurations.cppdbg ~= nil then
    for _, config in ipairs(dap.configurations.cppdbg) do
      if config.request == 'launch' then
        config.prehook = function()
          vim.fn.system({ 'g++', '-g', '-O0', vim.fn.expand('%'), '-o', vim.fn.expand('%:r') })
        end
      end
    end
  end
end

require('dap.ext.vscode').load_launchjs() -- .vscode/launch.json を読み込む
vscode_config_to_nvim_config()            -- すべての config が読み込まれたあとに実行する

dapui.setup()
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
-- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- [[  cpp debug ]]
local cpptools_path = vim.fn.stdpath('data') .. '/cpptools'
if not vim.loop.fs_stat(cpptools_path) then
  -- vscode 用の dap adapter だが preLaunchTask までは扱ってくれないもよう
  vim.fn.system { 'wget', 'https://github.com/microsoft/vscode-cpptools/releases/download/v.1.19.4/cpptools-linux.vsix', '-O', vim.fn.stdpath('data') .. '/cpptools-linux.vsix' }
  vim.fn.system { 'unzip', vim.fn.stdpath('data') .. '/cpptools-linux.vsix', '-d', cpptools_path }
  vim.fn.system { 'chmod', '+x', cpptools_path .. '/extension/debugAdapters/bin/OpenDebugAD7' }
end
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = cpptools_path .. '/extension/debugAdapters/bin/OpenDebugAD7',
}
dap.configurations.cpp = dap.configurations.cppdbg

dap.adapters.gdbdap = {
    type = 'executable',
    command = 'gdb',
    args = {'-i', 'dap'}
}

if dap.configurations.cpp == nil then
  dap.configurations.cpp = {}
end
table.insert(dap.configurations.cpp, {
    -- 実行前にコンパイルする
    prehook = function()
        vim.fn.system({'g++', '-g', '-O0', vim.fn.expand('%'), '-o', vim.fn.expand('%:r')})
    end,
    name = 'gdb dap Launch',
    type = 'gdbdap',
    request = 'launch',
    program = '${workspaceFolder}/${fileBasenameNoExtension}',
    cwd = '${workspaceFolder}',
    stopAtBeginningOfMainSubprogram = false
})
