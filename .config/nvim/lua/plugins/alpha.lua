return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.startify")

    dashboard.section.header.val = {
"                                                                ___ ___        .__       .___                   __                                        ___.           __    __          ",
"                                                               /   |   \\  ____ |  |    __| _/   ____   ____   _/  |_  ____    ___.__. ____  __ _________  \\_ |__  __ ___/  |__/  |_  ______",
"                                                              /    ~    \\/  _ \\|  |   / __ |   /  _ \\ /    \\  \\   __\\/  _ \\  <   |  |/  _ \\|  |  \\_  __ \\  | __ \\|  |  \\   __\\   __\\/  ___/",
"                                                              \\    Y    (  <_> )  |__/ /_/ |  (  <_> )   |  \\  |  | (  <_> )  \\___  (  <_> )  |  /|  | \\/  | \\_\\ \\  |  /|  |  |  |  \\___ \\ ",
"                                                               \\___|_  / \\____/|____/\\____ |   \\____/|___|  /  |__|  \\____/   / ____|\\____/|____/ |__|     |___  /____/ |__|  |__| /____  >",
"                                                                     \\/                   \\/              \\/                  \\/                               \\/                       \\/ ",
    }

    alpha.setup(dashboard.opts)
  end,
}
