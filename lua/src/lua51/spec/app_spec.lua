
local app = require('app')

describe('app', function()
  it('now', function()
    local now = app.now()
    assert.is.number(now)
    app.sleep(0.001)
    local now2 = app.now()
    assert.is.truthy((now2 - now) >= 1)
  end)

  -- it('run', function()
  --   local t = {}
  --   function t.update() end

  --   local s = stub.new(t, 'update')
  --   local i = 0
  --   s.by_default.invokes(function(dt)
  --     i = i + 1

  --     if i == 3 then
  --       app.stop()
  --     end
  --   end)

  --   app.run(function(...) t.update(...) end, 0.016667)
  --   assert.stub(s).was.called(3)
  -- end)
end)