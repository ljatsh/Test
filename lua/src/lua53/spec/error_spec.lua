
-- describe('error', function()
--   it('error level', function()
--     local f1 = function(str)
--       if type(str) ~= 'string' then error('string expected') end
--     end
--     local f2 = function(str)
--       if type(str) ~= 'string' then error('string expected', 2) end
--     end

--     --f1({x=1})
--     f2({x=1})
--   end)
-- end)

local f1 = function(str)
  if type(str) ~= 'string' then error('string expected') end
end
local f2 = function(str)
  if type(str) ~= 'string' then error('string expected', 2) end
end

--f1({x=1})
--f2({x=1})

function f()
  f4()
end

function f1() error('f1 error') end

function f2()
  local c = 1
  f1()
end

function f3()
  local b = 1
  f2()
end

function f4()
  local a = 1
  f3()
end

-- test = coroutine.wrap(f)
-- test()

-- co = coroutine.create(f)
-- local _, err = coroutine.resume(co)
-- print(debug.traceback(co, err))