
local session = require('session')
local session_event_sink = require('session_event_sink')
local parser_header = require('parser.parser_header')
local class = require('class')
local luv = require('luv')

local test_sink = class(session_event_sink)

function test_sink:on_session_connecting_failure(session, reason)
  print('on_session_connecting_failure:', session, reason)
end

function test_sink:on_session_connected(session)
  print('on_session_connected:', session)
end

function test_sink:on_session_authentication(session)
  print('on_session_authentication:', session)

  print('request GET')
  session:send(session.parser:pack('GET'))

  return true
end

function test_sink:on_session_disconnected(session, reason)
  print('on_session_disconnected:', session, reason)

  luv.fiber.create(function()
    luv.sleep(1)
    print('try reconnecting')

    session:start()
  end):ready()
end

function test_sink:on_session_message(session, msg)
  print(string.format('<--- response %s', msg))

  luv.fiber.create(function()
    luv.sleep(math.random())

    local requests = {'GET', 'POST', 'HEAD', 'DELETE', 'BAD'}
    local req = requests[math.random(1, #requests)]

    print(string.format('---> reqeust %s', req))
    session:send(session.parser:pack(req))
  end):ready()
end

local client = luv.fiber.create(function(host, port)
  local sink = test_sink.new()
  local parser = parser_header.new(5)
  local s = session.new(host, port, parser, sink)

  s:start()
end, '127.0.0.1', 8080)

client:ready()

luv.sleep(1000)
