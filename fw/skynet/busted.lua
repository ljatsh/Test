
local skynet = require('skynet')

skynet.start(function()
  require 'busted.runner'({ standalone = false })
end)
