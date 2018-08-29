

local luv = require('luv')
local app = require('app')

describe('fiber', function()
  it('as coroutine', function()
    local t = {}
    function t.f() end
    spy.on(t, 'f')

    local f = luv.fiber.create(function(n)
      t.f(n)

      for i=1, n do
        --t.f(coroutine.yield(i * 2))
        t.f(luv.fiber.yield(i * 2))
      end

      t.f('done')
      return 'done'
    end, 3)

    local _, r = f:join()
    assert.are.same('done', r)

    assert.are.equal(coroutine.yield, luv.fiber.yield)
    assert.spy(t.f).was.called(5)
    assert.spy(t.f).was.called_with(3)
    assert.spy(t.f).was.called_with(2)
    assert.spy(t.f).was.called_with(4)
    assert.spy(t.f).was.called_with(6)
    assert.spy(t.f).was.called_with('done')
  end)
end)

describe('timer', function()
  it('scenario', function()
    local t = {}
    function t.f() end
    spy.on(t, 'f')

    local timer = luv.timer.create()
    timer:start(1, 1)

    for i=1, 3 do
      timer:wait()
      t.f(i)
    end

    timer:stop()

    assert.spy(t.f).was.called(3)
    assert.spy(t.f).was.called_with(1)
    assert.spy(t.f).was.called_with(2)
    assert.spy(t.f).was.called_with(3)
  end)
end)

describe('utility', function()
  -- current state description
  it('self', function()
    assert.is_function(luv.self)
    assert.is.match('luv%.%w+', luv.self())
  end)

  it('sleep', function()
    assert.is_function(luv.sleep)
    luv.sleep(0.01)
  end)
end)

describe('net', function()
  it('scenario', function()
    local host = luv.net.getaddrinfo("www.google.com")
    local sock = luv.net.tcp()
    print("conn:", sock:connect(host, 80))
    print("write:", sock:write("GET / HTTP/1.0\r\nHost: www.google.com\r\n\r\n"))
    print("read:", sock:read())
  end)
end)

describe('fs', function()
  it('scenario', function()
    local t = luv.fs.stat("/opt/dev")
    for k,v in pairs(t) do
      print(k, "=>", v)
    end

    local f1 = luv.fiber.create(function()
      print("enter")
      local file = luv.fs.open("/tmp/cheese.ric", "w+", "664")
        print("file:", file)
        print("write:", file:write("Hey Bro!"))
        print("close:", file:close())
    end)

    f1:ready()
    f1:join()

    local file = luv.fs.open("/tmp/cheese.ric", "r", "664")
    print("READ:", file:read())
    file:close()
    print("DELETE:", luv.fs.unlink("/tmp/cheese.ric"))
  end)
end)
