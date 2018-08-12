
local skynet = require('skynet')
local socket = require('skynet.socket') -- busted cleared package.loaded. however, sevaral files cannot be loaded again in skynet.
require "skynet.manager"

skynet.start(function()
  skynet.newservice("debug_console",8000)
  require 'busted.runner'({ standalone = false })
  skynet.sleep(1)
  skynet.abort()
end)
