
--- http response parser
-- 

local class = require('class')
local parser = require('parser.parser')
local hresp = require('parser.http.response')
local lhp = require('http.parser')

local parser_response = class(parser)

function parser_response:ctor()
  self.response = hresp.new()
  self.parser = lhp.response {
    on_header = function(hkey, hval)
      self.resonse.headers.set(hkey, hval)
    end,

    on_headers_complete = function()
      self.response.status = self.parser:status_code()
      self.response.version_major, self.response.version_minor = parser:version()

      -- if req:method() == 'HEAD' then
      --   finished = true
      -- end
    end,

    on_body = function(body)
      if body ~= nil then
        bodies[#bodies + 1] = body
      end
    end,

    on_message_complete = function()
      finished = true
    end
  }
end

function parser_response:reset()
end

function parser_response:execute(data)
  return 0, 'error', nil
end

return parser_response
