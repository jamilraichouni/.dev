local dap = require("dap")
dap.adapters.python = {
  type = "executable";
  command = "/usr/local/bin/python3";
  args = { "-m", "debugpy.adapter" };
}
