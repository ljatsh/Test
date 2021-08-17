
local mt = {}

function mt.push(self, v)
  self._array[#self._array + 1] = assert(v)
end

function mt.pop(self)
  return table.remove(self._array, 1)
end

function mt.is_empty(self)
  return #self._array == 0
end

local queue = {}
function queue.new()
  return setmetatable({
    _array = {}
  },
  {__index = mt})
end

return queue
