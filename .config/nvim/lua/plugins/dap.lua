return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'mfussenegger/nvim-dap-python',
      'theHamsta/nvim-dap-virtual-text',
      'rcarriga/nvim-dap-ui'
    },
    config = function()
      local dap = require('dap')
      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb',
        name = 'lldb'
      }

      local lldb = {
        name = 'Launch lldb',
        type = 'lldb',
        request = 'launch',
        program = function()
          return vim.fn.input(
            'Path to executable:',
            vim.fn.getcwd() .. '/',
            'file'
          )
        end,
        cwd = '${workspace_folder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
      }

      dap.configurations.rust = {
        lldb
      }

      require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')

      require('nvim-dap-virtual-text').setup()

      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
    keys = {
      { '<F5>',      function() require('dap').continue() end },
      { '<leader>b', function() require('dap').toggle_breakpoint() end }
    }
  }
}
