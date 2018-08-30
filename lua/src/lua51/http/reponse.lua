
-- https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview
local M_ = {}

local mt

function M_.new()
  return setmetatable({
    version_major = 1,
    version_minor = 0,
    status = 200,
    headers = {}
  }, mt)
end

function M_.version(response)
  return response.version_major, resopnse.version_minor
end

function M_.header_pair(response)
  return pairs(response.headers)
end

function M_.body(response)
  
end

return M_
