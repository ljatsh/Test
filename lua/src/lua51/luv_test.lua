
local app = require('app')
local luv = require('luv')

local with_app = false

local test = luv.fiber.create(function()
  --arg = {'--list'}
  --arg = { '--filter=app now*'}
  require 'busted.runner'({ standalone = false })

  luv.sleep(1)

  if with_app then
    app.stop()
  end
end)

if with_app then
  local update = function(dt) end
  test:ready()

  app.run(function(dt)
  local fiber = luv.fiber.create(update, dt)
    fiber:join()
  end, 0.016667)
else
  test:join()
end
