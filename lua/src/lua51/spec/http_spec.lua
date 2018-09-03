
local hh = require('parser.http.header')
-- local hreq = require('http.request')
local hresp = require('parser.http.response')
local lhp = require('http.parser')
local hp = require('helper')

describe('http', function()
  it('header', function()
    local header = hh.new()
    assert.is.truthy(header:is_empty())

    header = hh.new({Host = 'developer.mozilla.org',
                     Connection = 'Keep-Alive'})

    -- read from key is case-insensitive
    assert.are.same('Keep-Alive', header:get('Connection'))
    assert.are.same('Keep-Alive', header:get('connection'))
    assert.is_nil(header:get('Content-Length'))

    -- write
    header:set('Content-Length', '100')
    assert.are.same('100', header:get('content-lengTH'))

    header:clear('Content-Length')
    assert.is_nil(header:get('Content-Length'))

    -- format
    local str = tostring(header)
    assert.is.match('Host: developer.mozilla.org', str)
    assert.is.match('Connection: Keep%-Alive', str)

    -- empty
    assert.is.falsy(header:is_empty())
  end)
end)

describe('http response', function()
  local headers
  local finish_header = false
  local finish_message = false
  local resp_data = ''
  local parser = lhp.response {
    on_header = function(hkey, hval) headers:set(hkey, hval) end,
    on_headers_complete = function() finish_header = true end,
    on_message_complete = function() finish_message = true end,
    on_body = function(body)
      if body ~= nil then
        resp_data = resp_data .. body
      end
    end
  }

  before_each(function()
    headers = hh.new()
    finish_header = false
    finish_message = false
    resp_data = ''
    parser:reset()
  end)

  it('construction1', function()
    local resp = hresp.new()
    assert.are.same(1, resp.version_major)
    assert.are.same(0, resp.version_minor)
    assert.are.same(200, resp.status)
    assert.are.same('', tostring(resp.headers))
    assert.is_nil(resp:get_body())
  end)

  it('construction2', function()
    local resp = hresp.new(404, {Connection = 'Keep-Alive'}, 'hello')
    assert.are.same(1, resp.version_major)
    assert.are.same(0, resp.version_minor)
    assert.are.same(404, resp.status)
    assert.are.same('hello', resp:get_body())
    local str = tostring(resp.headers)

    assert.is.match('Connection: Keep%-Alive', str)
    assert.is.match('Content%-Length: 5', str)
  end)

  it('body', function()
    local resp = hresp.new()
    resp.status = 404
    resp.headers['Connection'] = 'Keep-Alive'
    assert.are.same('Not Found', resp:status_string())
    assert.is_nil(resp:get_body())
    assert.is_nil(resp.headers:get('Content-Length'))

    resp:set_body('0123456789')
    assert.are.same('0123456789', resp:get_body())
    assert.are.same('10', resp.headers:get('Content-Length'))
  end)

  it('parse - no header, no body', function()
    local resp = hresp.new()
    local data = tostring(resp)
    assert.are.same(#data, parser:execute(data))
    assert.are.same(0, (parser:error()))
    assert.is.truthy(headers:is_empty())
    assert.are.same('', resp_data)
  end)

  it('parse - header, no body', function()
    local resp = hresp.new(302, {Connection = 'close', location= 'http://www.baidu.com'})
    local data = tostring(resp)
    assert.are.same(#data, parser:execute(data))
    assert.are.same(0, (parser:error()))
    assert.are.same('close', headers:get('Connection'))
    assert.are.same('http://www.baidu.com', headers:get('Location'))
    assert.are.same('', resp_data)
  end)

  it('response - header, body', function()
    local resp = hresp.new(302, {Connection = 'close', location= 'http://www.baidu.com'}, '0123456789')
    local data = tostring(resp)
    assert.are.same(#data, parser:execute(data))
    assert.are.same(0, (parser:error()))
    assert.are.same('close', headers:get('Connection'))
    assert.are.same('http://www.baidu.com', headers:get('Location'))
    assert.are.same('10', headers:get('Content-Length'))
    assert.are.same('0123456789', resp_data)
  end)

  -- it('request', function()
  --   local req = hreq.new()
  --   assert.are.same('GET', req:method())
  --   assert.are.same('/', req.path)
  --   assert.are.same({}, req.query)

  --   -- set data
  --   assert.has.error(function() req:set_data('') end)
  --   req:set_method('post')
  --   assert.are.equal('POST', req:method())
  --   req:set_data('0123456789')
  --   assert.are.same('10', req.headers['Content-Length'])
  --   assert.are.same('application/x-www-form-urlencoded', req.headers['Content-Type'])
  --   assert.are.same('0123456789', req:data())

  --   req:set_method('HEAD')
  --   assert.are.equal('HEAD', req:method())
  --   assert.is_nil(req.headers['Content-Length'])
  --   assert.is_nil(req.headers['Content-Type'])
  --   assert.is_nil(req:data())
  -- end)

  -- it('request - parse', function()
  --   local req = hreq.new('/x/y/z', {name='ljatsh', age=31, sex='x y'})
  --   req.version_minor = 1
  --   local headers = hh.new()
  --   local finished = false
  --   local req_body = ''
  --   local req_url = ''
  --   local parser = lhp.request {
  --     on_url = function(url) req_url = url end,
  --     on_header = function(hkey, hval) headers[hkey] = hval end,
  --     on_message_complete = function() finished = true end,
  --     on_body = function(body)
  --       if body ~= nil then
  --         req_body = req_body .. body
  --       end
  --     end
  --   }

  --   local data = tostring(req)
  --   parser:execute(data)
  --   assert.is.truthy(finished)
  --   assert.are.same('GET', parser:method())
  --   local version_major, version_minor = parser:version()
  --   assert.are.same(1, version_major)
  --   assert.are.same(1, version_minor)
  --   assert.is.match('/x/y/z%?[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+', req_url)

  --   -- head
  --   req:set_method('HEAD')
  --   headers = hh.new()
  --   finished = false
  --   req_body = ''
  --   req_url = ''
  --   parser:reset()
  --   data = tostring(req)
  --   parser:execute(data)
  --   assert.is.truthy(finished)
  --   assert.are.same('HEAD', parser:method())
  --   local version_major, version_minor = parser:version()
  --   assert.are.same(1, version_major)
  --   assert.are.same(1, version_minor)
  --   assert.is.match('/x/y/z%?[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+', req_url)

  --   -- post
  --   req:set_method('POST')
  --   req:set_data('0123456789')
  --   headers = hh.new()
  --   finished = false
  --   req_body = ''
  --   req_url = ''
  --   parser:reset()
  --   data = tostring(req)
  --   parser:execute(data)
  --   assert.is.truthy(finished)
  --   assert.are.same('POST', parser:method())
  --   local version_major, version_minor = parser:version()
  --   assert.are.same(1, version_major)
  --   assert.are.same(1, version_minor)
  --   assert.is.match('/x/y/z%?[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+', req_url)
  --   assert.are.same('10', headers['Content-Length'])
  --   assert.are.same('application/x-www-form-urlencoded', headers['Content-Type'])
  --   assert.are.same('0123456789', req_body)
  -- end)
end)