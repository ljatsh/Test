
local M_ = {}

--- Provide default value of the missing key in a table.
-- The performance challenge is how to avoid very much clousure/metatables creation.
--[[ not preferred ways
local function set_default1(t, v)
  local mt = {
    __index = function() return v end
  }
  setmetatable(t, mt)
  return t
end
]]

local key_default = {}

local next_func_default = function(t, index)
  local next_index, v = next(t, index)

  -- skip key_default
  if next_index == key_default then return next(t, next_index) end

  return next_index, v
end

local mt_default = {
  __index = function(t, k)
    return t[key_default]
  end,

  __pairs = function(t)
    return next_func_default, t
  end
}

function M_.set_default(t, v)
  t[key_default] = v
  setmetatable(t, mt_default)
  return t
end

--- Proxy
-- Proxy object is useful to trace table access
-- Proxy can be used to create Read-Only tables
local key_proxy = {}

local next_func_proxy = function(t, index)
  local next_index, v = next(t, index)

  -- skip key_proxy
  if next_index == key_proxy then return next(t, next_index) end

  if next_index ~= nil then
    print(string.format('traversing %s of %s', tostring(next_index), tostring(t)))
  end

  return next_index, v
end

local mt_proxy = {
  __index = function(t, k)
    print(string.format('%s of %s was indexed', k, tostring(t)))
    return t[key_proxy][k]
  end,

  __newindex = function(t, k, v)
    print(string.format('%s was assigned to %s of %s', tostring(v), k, tostring(t)))
    t[key_proxy][k] = v
  end,

  __pairs = function(t)
    return next_func_proxy, t[key_proxy]
  end,

  __len = function(t)
    return #t[key_proxy]
  end
}

function M_.proxy(t)
  local o = {}
  o[key_proxy] = t

  return setmetatable(o, mt_proxy)
end

local function trim_left(s)
  return (string.gsub(s, '^%s*', ''))
end

local function trim_right(s)
  return (string.gsub(s, '%s*$', ''))
end

local function trim(s)
  -- pattern ^%s*(.*)%s*$ is bad
  return (string.gsub(s, '^%s*(.-)%s*$', '%1'))
end

-- elment count == count of delimiters + 1
function M_.split(s, delimiter)

  local function next_delimiter(s, n)
    local x, y = string.find(s, delimiter, n, true)
    local ni = nil
    if x ~= nil then
      ni = y + 1
    end

    return ni, x, y
  end

  local r = {}
  local i = 1
  for _, x, y in next_delimiter, s, 1 do
    r[#r + 1] = trim(string.sub(s, i, x-1))
    i = y + 1
  end
  r[#r + 1] = trim(string.sub(s, i))

  return r
end

-- exports
M_.trim_left = trim_left
M_.trim_right = trim_right
M_.trim = trim

return M_
