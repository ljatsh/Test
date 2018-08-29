
local app = require('app')
local luv = require('luv')

local with_app = true
local max_dt = 0.0
local dts = {}

function __G__TRACKBACK__(msg)
  print('__G__TRACKBACK__', msg)
end

local test = luv.fiber.create(function()
  --arg = {'--list'}
  arg = { '--filter=socket*'}
  require 'busted.runner'({ standalone = false })

  if with_app then
    app.stop()
    print(string.format('\nmax_dt %f', max_dt))
    --print(table.concat(dts, ', '))
  end
end)

if with_app then
  local update = function(dt)
    if dt > max_dt then max_dt = dt end
    --dts[#dts + 1] = dt
  end
  test:ready()

  app.run(function(dt)
    local fiber = luv.fiber.create(update, dt)
    fiber:join()
    end, 0.016667)
else
  test:join()
end
