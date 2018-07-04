
gName = 'lj@sh'

function getName() return gName end

function callC(v)
  assert(type(simpleTest1) == "function")
  print(simpleTest1)
  print(v)

  return simpleTest1(v)
end
