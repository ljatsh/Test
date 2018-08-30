
local luv = require('luv')
local hreq = require('http.request')
local http_client = require('http.client')

local get = luv.fiber.create(function()
  local req = hreq.new()
  local response, err = http_client.request(req, 'www.google.com')
  print(response, err)
end)

get:join()
