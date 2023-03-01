
-- 模拟cocos2d-x的按照结构访问过程

local queue = require('queue')

local mt = {}

function mt.visit_generator(self)
  local q = queue.new()
  local silbings = {self}

  local i, child, found
  while next(silbings) do
    for _, node in ipairs(silbings) do
      coroutine.yield(node.value)
    end

    i = 1
    found = true
    while true do
      for _, node in ipairs(silbings) do
        child = node.children[i]
        if child then
          q:push(child)
          found = true
        end
      end

      if not found then
        break
      end

      i = i + 1
      found = false
    end

    silbings = {}
    while not q:is_empty() do
      silbings[#silbings + 1] = q:pop()
    end
  end
end

local tree = {}

function tree.new(value, ...)
  return setmetatable({value = value, children = {...}}, {__index = mt})
end

return tree
