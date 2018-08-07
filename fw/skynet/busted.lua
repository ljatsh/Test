
local skynet = require('skynet')

skynet.start(function()
  skynet.newservice("debug_console",8000)
  require 'busted.runner'({ standalone = false })
end)
