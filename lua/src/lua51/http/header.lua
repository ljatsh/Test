
local M_ = {}

--- useful headers https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers
-- general header
M_.Date                           = 'Date'
M_.Cache_Control                  = 'Cache-Control'
M_.Connection                     = 'Connection'

-- entity header
M_.Content_Length                 = 'Content-Length'
M_.Content_Language               = 'Content-Language'
M_.Content_Encoding               = 'Content-Encoding'
M_.Content_Type                   = 'Content-Type'

-- request header
M_.User_Agent                     = 'User-Agent'
M_.Host                           = 'Host'

-- response header
M_.Keep_Alive                     = 'Keep-Alive'

local m
local header_key = {}

function M_.new(headers)
  local h = {}
  for k, v in pairs(headers or {}) do
    h[string.lower(k)] = {k, v}
  end

  local t = {}
  t[header_key] = h
  return setmetatable(t, m)
end

local function format_header(headers)
  local t = {}
  for _, v in pairs(headers[header_key]) do
    t[#t + 1] = string.format('%s: %s', v[1], v[2])
  end

  return table.concat(t, '\r\n')
end

local function add_header(headers, hkey, hvalue)
  local h = rawget(headers, header_key)
  if hvalue == nil then
    h[string.lower(hkey)] = nil
  else
    h[string.lower(hkey)] = {hkey, hvalue}
  end
end

local function find_header(headers, hkey)
  local hp = require('helper')
  local h = rawget(headers, header_key)
  local v = h[string.lower(hkey)]
  if v == nil then return nil end
  
  return v[2]
end

m = {
  __index = find_header,
  __newindex = add_header,
  __tostring = format_header
}

return M_
