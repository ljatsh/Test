local luv = require("luv")
local parser_header = require("parser.parser_header")

local server = luv.net.tcp()

print("SERVER:", server)
print("BIND:", server:bind("127.0.0.1", 8080))
print("LISTEN:", server:listen())

local function command(msg)
  local cmd = string.gsub(msg, '(%w+)%s*.*', '%1')
  print('handle cmd ', cmd)

  if cmd == 'GET' then
    return string.format('GET /index.html')
  end

  if cmd == 'POST' then
    return string.format('POST /request.py name=ljatsh')
  end

  if cmd == 'HEAD' then
    return string.format('HEAD /hello.py')
  end

  if cmd == 'DELETE' then
    return string.format('DELETE /check.py')
  end
end

while true do
  local client = luv.net.tcp()
  print("ACCEPT:", server:accept(client)) -- block here

  local fib =
    luv.fiber.create(
    function()
      local id
      local parser = parser_header.new(5)
      local err
      local msg

      while true do
        local got, str = client:read(1024)
        if not got then
          print("network closing ", id)
          client:close()
          break
        end

        for i = 1, got do
          err, msg = parser:execute(str:sub(i, i))

          if err ~= nil then
            break
          end

          if msg ~= nil then
            local resp = command(msg)
            if resp == nil then
              err = 'invalid command'
              break
            end
            client:write(parser:pack(resp))
          end
        end

        if err ~= nil then
          print('close ', id, ' due to ', err)
          client:close()
          break
        end
      end
    end
  )
  fib:ready()
end
