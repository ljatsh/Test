
require "skynet.manager"	-- import skynet.register
local skynet = require('skynet')
local handlers = require('test_handler')

local handle = ...

skynet.start(function()
  skynet.register('.test_' .. handle)

  local handler = handlers[handle]
  assert (handler ~= nil)

  skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
    local f = handler[cmd]
    if f ~= nil then
      skynet.ret(skynet.pack(f(subcmd, ...)))
    end
  end)
end)
