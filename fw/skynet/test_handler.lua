
local h1 = {}

function h1.dup(...)
  return ...
end

function h1.exit()
  --print('exiting...', skynet.self())
end

return {h1=h1}
