
--- parser.lua
-- consume binary data and generates message

local class = require('class')
local parser = class()

function parser:ctor()
end

--- reset the parser so that it is can be used again
function parser:reset()
end

--- consume binary data and generates message if the message is alreay.
-- If message is completed, execute should return.
-- @param data the binary data
-- @return error: parse error
-- @return consumed length
-- @return message: if message was completed, execute should return at once.
-- @usage
-- while true do
--   local err, len, m
--   repeat
--     err, len, m = parser:execute(data)
--     if err ~= nil then break end
--     if m ~= nil then
--       print(m)
--     end
--     
--     if len == #data then break end
--     data = data:sub(len + 1)
--   until false
--   if err ~= nil then break end
-- end
function parser:execute(data)
  return 'error', 0, nil
end

return parser
