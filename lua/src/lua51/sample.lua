
local luv = require('luv')
local hreq = require('http.request')
local http_client = require('http.client')

local get = luv.fiber.create(function()
  local req = hreq.new()
  local response, body = http_client.do_http(req, 'www.google.com')
  if response ~= nil then
    print('headers:\r\n', response)

    if body then
      print('body:\r\n', body)
    end
  else
    print(response, body)
  end
end)

print('---------------------------- GET www.google.com --------------------------')
--get:join()

local download = luv.fiber.create(function()
  local ret, err = http_client.download_file('http://www.monogame.net/releases/v3.6/MonoGame.pkg', '/opt/dev/MonoGame.pkg')
  print(ret, err)
end)

print('---------------------------- Download http://www.monogame.net/releases/v3.6/MonoGame.pkg --------------------------')
download:join()

-- local download = luv.fiber.create(function()
--   local req = hreq.new()
--   --req.path = '/releases/v3.6/MonoGame.pkg'
--   --req.path = '/ac/v/dikVn1'
--   req.path = '/1.0.0/mg_hmzl_56_1.0.0_1808_2487_435.apk?click_uuid=3242E5C8-DBAF-4FDF-AEB6-0CB506FBF922'
--   req:set_method('HEAD')
--   req.headers['User-Agent'] = 'curl/7.47.0'
--   req.headers['Accept'] = '*/*'
--   req.headers['Host'] = 'tg2cdn.mg3721.com'
--   req.version_minor = 1

--   print(req)

--   --local response, err = http_client.request(req, 'www.monogame.net')
--   --local response, err = http_client.request(req, 'tg2.mg3721.com')
--   local response, err = http_client.request(req, 'tg2cdn.mg3721.com')
--   print(response, err)
-- end)

-- download:join()
