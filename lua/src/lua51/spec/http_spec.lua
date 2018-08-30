
local hh = require('http.header')
local hreq = require('http.request')
local hresp = require('http.response')
local lhp = require('http.parser')
local hp = require('helper')
local hurl = require('http.url')

describe('http', function()
  it('header', function()
    local header = hh.new({Host = 'developer.mozilla.org',
                           Connection = 'Keep-Alive'})

    -- read from key is case-insensitive
    assert.are.same('Keep-Alive', header.Connection)
    assert.are.same('Keep-Alive', header.connection)
    assert.is_nil(header['Content-Length'])

    -- write
    header['Content-Length'] = '100'
    assert.are.same('100', header['content-lengTH'])

    header['Content-Length'] = nil
    assert.is_nil(header['Content-Length'])
  end)

  -- schema://www.host:port[path][query][fragment]
  it('url - parse', function()
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

  it('url - build', function()
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

  it('request', function()
    local req = hreq.new()
    assert.are.same('GET', req:method())
    assert.are.same('/', req.path)
    assert.are.same({}, req.query)

    -- set data
    assert.has.error(function() req:set_data('') end)
    req:set_method('post')
    assert.are.equal('POST', req:method())
    req:set_data('0123456789')
    assert.are.same('10', req.headers['Content-Length'])
    assert.are.same('application/x-www-form-urlencoded', req.headers['Content-Type'])
    assert.are.same('0123456789', req:data())

    req:set_method('HEAD')
    assert.are.equal('HEAD', req:method())
    assert.is_nil(req.headers['Content-Length'])
    assert.is_nil(req.headers['Content-Type'])
    assert.is_nil(req:data())
  end)

  it('request - parse', function()
    local req = hreq.new('/x/y/z', {name='ljatsh', age=31, sex='x y'})
    req.version_minor = 1
    local headers = hh.new()
    local finished = false
    local req_body = ''
    local req_url = ''
    local parser = lhp.request {
      on_url = function(url) req_url = url end,
      on_header = function(hkey, hval) headers[hkey] = hval end,
      on_message_complete = function() finished = true end,
      on_body = function(body)
        if body ~= nil then
          req_body = req_body .. body
        end
      end
    }

    local data = tostring(req)
    parser:execute(data)
    assert.is.truthy(finished)
    assert.are.same('GET', parser:method())
    local version_major, version_minor = parser:version()
    assert.are.same(1, version_major)
    assert.are.same(1, version_minor)
    assert.is.match('/x/y/z%?[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+', req_url)

    -- head
    req:set_method('HEAD')
    headers = hh.new()
    finished = false
    req_body = ''
    req_url = ''
    parser:reset()
    data = tostring(req)
    parser:execute(data)
    assert.is.truthy(finished)
    assert.are.same('HEAD', parser:method())
    local version_major, version_minor = parser:version()
    assert.are.same(1, version_major)
    assert.are.same(1, version_minor)
    assert.is.match('/x/y/z%?[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+', req_url)

    -- post
    req:set_method('POST')
    req:set_data('0123456789')
    headers = hh.new()
    finished = false
    req_body = ''
    req_url = ''
    parser:reset()
    data = tostring(req)
    parser:execute(data)
    assert.is.truthy(finished)
    assert.are.same('POST', parser:method())
    local version_major, version_minor = parser:version()
    assert.are.same(1, version_major)
    assert.are.same(1, version_minor)
    assert.is.match('/x/y/z%?[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+&[%w]+=[%w%d%+]+', req_url)
    assert.are.same('10', headers['Content-Length'])
    assert.are.same('application/x-www-form-urlencoded', headers['Content-Type'])
    assert.are.same('0123456789', req_body)
  end)

  it('response', function()
    local resp = hresp.new()
    resp.version_major = 1
    resp.version_minor = 1
    resp.status = 404
    resp.headers['Connection'] = 'Keep-Alive'
    assert.are.same('Not Found', resp:status_msg())
    assert.is_nil(resp:data())
    assert.is_nil(resp.headers['Content-Length'])

    resp:set_data('0123456789')
    assert.are.same('0123456789', resp:data())
    assert.are.same('10', resp.headers['Content-Length'])
  end)

  it('response - parse', function()
    local resp = hresp.new()
    resp.version_major = 1
    resp.version_minor = 1
    resp.status = 200
    resp.headers['Connection'] = 'Keep-Alive'
    resp:set_data('Hello, Lua!')

    local data = tostring(resp)
    local headers = hh.new()
    local finished = false
    local resp_data = ''
    local parser = lhp.response {
      on_header = function(hkey, hval) headers[hkey] = hval end,
      on_message_complete = function() finished = true end,
      on_body = function(body)
        if body ~= nil then
          resp_data = resp_data .. body
        end
      end
    }

    local parsed_length = parser:execute(data)
    assert.are.same(#data, parsed_length)
    assert.is.truthy(true)
    assert.are.same(tostring(string.len('Hello, Lua!')), headers['Content-Length'])
    assert.are.same('Hello, Lua!', resp_data)
  end)
end)