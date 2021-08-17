
local mt = {}

function mt.push(self, v)
  self._array[#self._array + 1] = assert(v)
end

function mt.pop(self)
  local size = #self._array
  if size == 0 then return end

  local v = self._array[size]
  self._array[size] = nil

  return v
end

function mt.is_empty(self)
  return #self._array == 0
end

local stack = {}
function stack.new()
  return setmetatable({
    _array = {}
  },
  {__index = mt})
end

return stack


