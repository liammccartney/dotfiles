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

      require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')

      require('nvim-dap-virtual-text').setup()

      dap.adapters.coreclr = {
        type = 'executable',
        command = '/Users/liam/netcoredbg/netcoredbg',
        args = { '--interpreter=vscode' }
      }

      dap.configurations.cs = {
        {
          type = 'coreclr',
          name = 'launch - netcoredbg',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
          end
        }
      }

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
