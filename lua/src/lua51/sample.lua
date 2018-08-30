
local luv = require('luv')
local http_client = require('http.client')

local get = luv.fiber.create(function()
  local response, parser = http_client.get()
  print(response, parser)
end)

get:join()
