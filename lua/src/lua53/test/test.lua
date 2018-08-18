
gName = 'lj@sh'

function getName() return gName end

function callC(v)
  assert(type(simpleTest1) == "function")

  return simpleTest1(v)
end

function getFunc(v)
  local function f() return v * 2 end

  return f
end
