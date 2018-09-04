
require('pack')
local lhp = require('http.parser')
local hurl = require('http.url')
local hp = require('helper')

-- copied from Lua5.3
describe('lpack', function()
  it('pack endian', function()
    -- big endian
    local s = string.pack('>i', 0x01020304)
    assert.are.same('\x01\x02\x03\x04', s)

    s = string.pack('>h', 0x0304)
    assert.are.same('\x03\x04', s)

    -- little endian
    s = string.pack('<i', 0x01020304)
    assert.are.same('\x04\x03\x02\x01', s)

    s = string.pack('<H', 0x0304)
    assert.are.same('\x04\x03', s)

    -- endian has no meaning to string and byte
    s = string.pack('>zb', 'hello', 0x01)
    assert.are.same('hello\0\x01', s)
    s = string.pack('<zb', 'hello', 0x01)
    assert.are.same('hello\0\x01', s)
  end)

  it('pack integer', function()
    -- byte
    local s = string.pack('b', 0x7f)
    assert.are.same({2, 0x7f, n=2}, table.pack(string.unpack(s, 'b')))

    -- short
    s = string.pack('h', 0x7fff)
    assert.are.same({3, 0x7fff, n=2}, table.pack(string.unpack(s, 'h')))

    -- long (8 bytes on 64-bit machine and 4 bytes on 32-bit machine)
    s = string.pack('l', 0x7fffffff)
    assert.are.same({9, 0x7fffffff, n=2}, table.pack(string.unpack(s, 'l')))

    -- integer with variable width
    s = string.pack('i4', 0x7f, 0x7fff, 0x7fffff, 0x7fffffff)
    assert.are.same({17, 0x7f, 0x7fff, 0x7fffff, 0x7fffffff, n=5}, table.pack(string.unpack(s, 'i4')))
  end)

  it('pack string', function()
    -- zero-terminaled strings
    local s = string.pack('z', 'hello\0lua')
    assert.are.same({7, 'hello', n=2}, table.pack(string.unpack(s, 'z')))

    -- strings
    s = string.pack('AA', 'hello\0lua', 'ljatsh')
    assert.are.same({16, 'hello\0lua', 'ljatsh', n=3}, table.pack(string.unpack(s, 'A9A6')))

    -- varialbe length string
    s = string.pack('p', 'hello, lua')
    assert.are.same({12, 'hello, lua', n=2}, table.pack(string.unpack(s, 'p')))
  end)
end)

describe('url', function()
  -- schema://www.host:port[path][query][fragment]
  it('parse', function()
    local url = hurl.parse('http://www.google.com:8080/a/b/c?key=value&hisname=ljatsh#chapter1')
    assert.are.same('http', url.scheme)
    assert.are.same('www.google.com', url.host)
    assert.are.same(8080, url.port)
    assert.are.same('/a/b/c', url.path)
    assert.are.same('chapter1', url.fragment)
    local query = url.query
    assert.are.same('value', query.key)
    assert.are.same('ljatsh', query.hisname)
  end)

  it('build', function()
    local url = hurl.parse()
    url.scheme = 'ftp'
    url.host = 'www.google.com'
    url.port = 8080
    url.path = '/x/y/z'
    url.query.name = 'ljatsh+'
    url.query.age = 34
    url.query['his sex'] = 'M'

    local url2 = hurl.parse(url:build())
    assert.are.same('ftp', url2.scheme)
    assert.are.same('www.google.com', url2.host)
    assert.are.same(8080, url2.port)
    assert.are.same('/x/y/z', url2.path)
    assert.are.same('ljatsh+', url2.query.name)
    assert.are.same('34', url2.query.age)
    --assert.are.same('M', url2.query['his sex']) -- TODO url encoding specification
  end)
end)

--- HTTP Message:
-- start-line(always a single line)
-- an optional set of headers
-- a blank line indicating all meta-information for the message have been completed
-- an optional body

-- HTTP Response:
-- body is determed by following order
-- 1. Connection: close
--    Read EOF is the body end flag  body->(body, body, ..., nil)
--    if body is nil, message is completed
-- 2. Transfer-Encoding: chunked
--    every chunk was formatted: %len\r\nbody\r\n...0\r\n\r\n  body->(body, body ..., nil)
--    if body is nil, message is completed
-- 3. Content-Length
--    GET: body size is expected to be equal to Content-Length body->(body, body ..., nil)
--    HEAD: no body, message is completed if header is completed
-- 4. No content length header:
--    status 100: message is completed
--    other status: message is completed if header is completed
describe('http.parser', function()
  local code, text
  local headers = {}
  local finish_header = false
  local finish_message = false
  local content_length
  local last_body
  local body
  -- TODO callback cannot be spied
  local parser = lhp.response {
    on_status = function(a, b) code, text = a, b end,
    on_headers_complete = function() finish_header = true end,
    on_message_complete = function() finish_message = true end,
    on_chunk_header = function(a) content_length = a end,
    on_body = function(b)
      last_body = body
      body = b
    end
  }

  before_each(function()
    code = 0
    text = ''
    finish_header = false
    finish_message = false
    content_length = nil
    last_body = nil
    body = nil
    parser:reset()
  end)

  it('status code', function()
    local response = { "HTTP/1.1 404 Not found", "", ""}
    local data = table.concat(response, '\r\n')

    -- execute return value
    assert.are.same(#data, parser:execute(data))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.are.is.truthy(finish_header)
    assert.are.is.falsy(finish_message)               -- We should finish parser now due to missing header Content-Length

    -- content
    assert.are.same(404, code)
    assert.are.same('Not found', text)
  end)

  it('connection close', function()
    local response = [[
HTTP/1.1 200 OK
Date: Wed, 02 Feb 2011 00:50:50 GMT
Connection: close

0123456789]]
    local data = response:gsub('\n', '\r\n')

    --- 1
    -- execute return value
    assert.are.same(#data, parser:execute(data))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.are.is.truthy(finish_header)
    assert.are.is.falsy(finish_message)
    assert.are.same('0123456789', body)

    -- content
    assert.are.same(200, code)
    assert.are.same('OK', text)

    --- 2
    -- execute return value
    assert.are.same(8, parser:execute('\r\ntest\r\n'))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.are.is.truthy(finish_header)
    assert.are.is.falsy(finish_message)
    assert.are.same('\r\ntest\r\n', body)

    -- content
    assert.are.same(200, code)
    assert.are.same('OK', text)

    --- 3
    -- execute return value
    assert.are.same(0, parser:execute(''))                   -- Connection: close ---> execute parser:execute('') to finish parsing

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.are.is.truthy(finish_header)
    assert.are.is.truthy(finish_message)
    assert.is_nil(body)                                     -- the last body is nil

    -- content
    assert.are.same(200, code)
    assert.are.same('OK', text)
  end)

  -- https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/100
  it('continue', function()
    local response = [[
HTTP/1.1 200 OK
Date: Wed, 02 Feb 2011 00:50:50 GMT
Connection: close

0123456789]]
    --- 1
    -- execute return value
    local data = 'HTTP/1.1 100 Please continue mate.\r\n\r\n'
    assert.are.same(#data, parser:execute(data))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.are.is.truthy(finish_header)
    assert.are.is.truthy(finish_message)                                  -- 100 Continue is a valid message
    assert.is_nil(body)

    -- content
    assert.are.same(100, code)
    assert.are.same('Please continue mate.', text)

    --- 2
    local data = response:gsub('\n', '\r\n')
    -- execute return value
    assert.are.same(#data, parser:execute(data))
    assert.are.same(0, parser:execute(''))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.are.is.truthy(finish_header)
    assert.are.is.truthy(finish_message)

    -- content
    assert.are.same(200, code)
    assert.are.same('OK', text)
  end)
  
  -- https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Transfer-Encoding
  it('chunk header', function()
    local response = {
      "HTTP/1.1 200 OK";
      "Transfer-Encoding: chunked";
      "";
      "";
    }
    local data = table.concat(response, '\r\n')

    --- 1
    -- execute return value
    assert.are.same(#data, parser:execute(data))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.is.truthy(finish_header)
    assert.is.falsy(finish_message)                  -- We should not finish parser, there is 'Transfer-Encoding: chunked'.
    assert.is_nil(content_length)

    -- content
    assert.are.same(200, code)
    assert.are.same('OK', text)

    --- 2
    local extra_content = 'This is the data in the first chunk\r\n'
    local extra_chunk = string.format('%x\r\n', #extra_content - 2)       -- \r\n should be ommited
    
    -- execute return value
    assert.are.same(#extra_chunk, parser:execute(extra_chunk))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.is.truthy(finish_header)
    assert.is.falsy(finish_message)
    assert.are.same(#extra_content - 2, content_length)                  -- \r\n should be ommited

    -- content
    assert.are.same(200, code)
    assert.are.same('OK', text)

    --- 3
    -- execute return value
    assert.are.same(#extra_content, parser:execute(extra_content))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.is.truthy(finish_header)
    assert.is.falsy(finish_message)
    assert.are.same(extra_content:sub(1, -3), body)

    -- content
    assert.are.same(200, code)
    assert.are.same('OK', text)

    --- 4
    extra_content = 'This is the data in the second chunk\r\n'
    extra_chunk = string.format('%x\r\n', #extra_content - 2)

    -- execute return value
    assert.are.same(#extra_chunk, parser:execute(extra_chunk))
    assert.are.same(#extra_content, parser:execute(extra_content))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.is.truthy(finish_header)
    assert.is.falsy(finish_message)
    assert.are.same(#extra_content - 2, content_length)
    assert.are.same(extra_content:sub(1, -3), body)

    -- content
    assert.are.same(200, code)
    assert.are.same('OK', text)

    --- 5
    -- execute return value
    assert.are.same(5, parser:execute('0\r\n\r\n'))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.is.truthy(finish_header)
    assert.is.truthy(finish_message)                        -- message is finished
    assert.are.same(0, content_length)
    assert.is_nil(body)                                     -- the last body is nil

    -- content
    assert.are.same(200, code)
    assert.are.same('OK', text)
  end)

  -- curl -i http://127.0.0.1
  it('content - length', function()
    local response = [[
HTTP/1.1 302 Found
cache-control: no-cache
connection: keep-alive
content-length: 93
content-type: text/html; charset=utf-8
date: Mon, 03 Sep 2018 10:37:12 GMT
location: http://192.168.0.130/users/sign_in
server: nginx/1.14.0
strict-transport-security: max-age=31536000
x-content-type-options: nosniff
x-frame-options: DENY
x-request-id: cdb45335-8976-4628-afae-c1e71d4a2699
x-runtime: 0.008106
x-ua-compatible: IE=edge
x-xss-protection: 1; mode=block

<html><body>You are being <a href="http://gitlab/users/sign_in">redirected</a>.</body></html>]]
    --- 1
    -- execute return value
    local data = response:gsub('\n', '\r\n')
    assert.are.same(#data, parser:execute(data))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.are.is.truthy(finish_header)
    assert.are.is.truthy(finish_message)
    assert.are.same('<html><body>You are being <a href="http://gitlab/users/sign_in">redirected</a>.</body></html>', last_body)
    assert.is_nil(body)                                                             -- current body is nil

    -- content
    assert.are.same(302, code)
    assert.are.same('Found', text)
  end)

  -- curl -i -X HEAD http://www.monogame.net/releases/v3.6/MonoGame.pkg
  it('head', function()
    local response = [[
HTTP/1.1 200 OK
accept-ranges: bytes
connection: keep-alive
content-length: 122902451
content-type: application/octet-stream
date: Mon, 03 Sep 2018 10:33:21 GMT
etag: "58b7018a-75357b3"
last-modified: Wed, 01 Mar 2017 17:14:50 GMT
proxy-connection: keep-alive
server: nginx/1.4.6 (Ubuntu)

]]
    --- 1
    -- execute return value
    local data = response:gsub('\n', '\r\n')
    assert.are.same(#data, parser:execute(data))

    -- parser status
    assert.are.same(0, (parser:error()))

    -- callback
    assert.are.is.truthy(finish_header)
    assert.are.is.falsy(finish_message)                                     -- combine HEAD together to finish the parsing
    assert.is_nil(body)

    -- content
    assert.are.same(200, code)
    assert.are.same('OK', text)
  end)
end)