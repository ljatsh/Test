
local skynet = require('skynet')

local h1 = {}

function h1.dup(...)
  return ...
end

function h1.exit()
  --print('exiting...', skynet.self())
  skynet.exit()
end

local h2 = {}

h2.text_protocol = {
  name = 'text',
  id = skynet.PTYPE_TEXT,
  pack = function(...) end,
  unpack = skynet.tostring
}

return {h1=h1, h2=h2}
