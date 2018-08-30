
-- https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview
local header = require('http.header')

local M_ = {}

local http_status_msg = {
  [100] = "Continue",
  [101] = "Switching Protocols",
  [200] = "OK",
  [201] = "Created",
  [202] = "Accepted",
  [203] = "Non-Authoritative Information",
  [204] = "No Content",
  [205] = "Reset Content",
  [206] = "Partial Content",
  [300] = "Multiple Choices",
  [301] = "Moved Permanently",
  [302] = "Found",
  [303] = "See Other",
  [304] = "Not Modified",
  [305] = "Use Proxy",
  [307] = "Temporary Redirect",
  [400] = "Bad Request",
  [401] = "Unauthorized",
  [402] = "Payment Required",
  [403] = "Forbidden",
  [404] = "Not Found",
  [405] = "Method Not Allowed",
  [406] = "Not Acceptable",
  [407] = "Proxy Authentication Required",
  [408] = "Request Time-out",
  [409] = "Conflict",
  [410] = "Gone",
  [411] = "Length Required",
  [412] = "Precondition Failed",
  [413] = "Request Entity Too Large",
  [414] = "Request-URI Too Large",
  [415] = "Unsupported Media Type",
  [416] = "Requested range not satisfiable",
  [417] = "Expectation Failed",
  [500] = "Internal Server Error",
  [501] = "Not Implemented",
  [502] = "Bad Gateway",
  [503] = "Service Unavailable",
  [504] = "Gateway Time-out",
  [505] = "HTTP Version not supported",
}

local mt
local data_key = {}

function M_.new()
  return setmetatable({
    version_major = 1,
    version_minor = 0,
    status = 200,
    headers = header.new()
  }, mt)
end

local function status_string(status)
  return http_status_msg[status] or ''
end

local function get_data(resp)
  return rawget(resp, data_key)
end

local function set_data(resp, data)
  rawset(resp, data_key, data)
  local length = 0
  if data ~= nil then
    length = #data
  end
  resp.headers[header.Content_Length] = tostring(length)
end

local function format_response(resp)
  local status = string.format('HTTP/%d.%d %d %s',
                               resp.version_major,
                               resp.version_minor,
                               resp.status,
                               status_string(resp.status))

  local body = get_data(resp)
  if body == nil then
    return string.format('%s\r\n%s\r\n',
                         status,
                         resp.headers)
  else
    return string.format('%s\r\n%s\r\n\r\n%s',
                         status,
                         resp.headers,
                         body)
  end
end

mt = {
  __index = {
    status_msg = function(resp)
      return status_string(resp.status)
    end,
    data = get_data,
    set_data = set_data
  },
  __tostring = format_response
}

return M_
