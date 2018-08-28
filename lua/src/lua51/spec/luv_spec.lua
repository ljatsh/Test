
local app = require('app')
local luv = require('luv')

describe('luv under other loop', function()
  local function placeholder() end
  local self = {}

  local function run()
    self.update_durations = {}
    app.run(function(dt)
      self.update_durations[#self.update_durations + 1] = dt
      local f = luv.fiber.create(placeholder)
      f:join()
    end, 0.016667)
  end

  local function dump_run()
    print(table.concat(self.update_durations, ', '))
  end

  it('fiber', function()
    print('sample fiber ---------------------------------------')
    local boss = luv.fiber.create(function()
      print("boss enter")
   
      local work = function(a, b)
         print("work:", a, b)
         for i=1, 10 do
            print(a, "tick:", i, a)
            luv.fiber.yield()
         end
         return b, "cheese"
      end
   
      local f1 = luv.fiber.create(work, "a1", "b1")
      local f2 = luv.fiber.create(work, "a2", "b2")
   
      f1:ready()
      f2:ready()
   
      print("join f1:", f1:join())
      print("join f2:", f2:join())

      app.stop()
    end)
    print("BOSS: ", boss)
    boss:ready()

    --print("join boss:", boss:join())
    run()
    dump_run()
  end)

  it('timer', function()
    print('sample timer ---------------------------------------')
    local f1 = luv.fiber.create(function()
      print("ENTER")
      local t1 = luv.timer.create()
      t1:start(1000, 100)
      for i=1, 10 do
         print("tick:", i)
         print(t1:wait())
      end
      t1:stop()
      app.stop()
    end)

    f1:ready()

    run()
    dump_run()
  end)

  it('tcp', function()
    print('sample tcp ---------------------------------------')

    local client = luv.fiber.create(function()
      local host = luv.net.getaddrinfo("www.google.com")
      local sock = luv.net.tcp()
      print("conn:", sock:connect(host, 80))
      print("write:", sock:write("GET / HTTP/1.0\r\nHost: www.google.com\r\n\r\n"))
      print("read:", sock:read())

      app.stop()
    end)

    client:ready()
    run()
    dump_run()
  end)

  it('fs', function()
    print('sample fs ------------------------------------------')

    local test = luv.fiber.create(function()
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

      app.stop()
    end)

    test:ready()
    run()
    dump_run()
  end)
end)
