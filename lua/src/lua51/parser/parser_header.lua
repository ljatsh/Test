
--- parser with header
-- 4 bytes len + 1 byte version + msg

local class = require('class')
local parser = require('parser.paresr')
require('pack')

local parser_header = class(parser)

local status = {
  HEAD = 1,
  BODY = 2
}

function parser_header:ctor()
  self.status = status.HEAD
  self.datas = {}
  self.size = 0
  self.body_size = 0
  self.off_set = 1
end

function parser_header:reset()
  self.status = status.HEAD
end

function parser_header:execute(data)
  self.datas[#self.datas + 1] = data
  self.size = #data

  if self.status == status.HEAD then
    if self.size >= 5 then
      self.status = status.BODY
      if #self.datas > 1 then
        self.datas = {table.concat(self.datas)}
      end

      off_set, self.body_size, version = string.unpack(self.datas[1], 'Ib', off_set)
      self.size -= 5
      -- TODO version check
    end
  end

  if self.status == status.BODY then
    if self.size >= self.body_size then
      self.status = self.HEAD

      if #self.datas > 1 then
        self.datas = {table.concat(self.datas)}
      end

      local msg
      off_set, msg = string.unpack(self.datas[1], string.format('%dA', self.body_size), off_set)
      self.size -= self.body_size
      return nil, off_set, msg
    end
  end

  return 'error', 0, nil
end

--- pack data
-- @param data the binary msg
-- @return the binary msg with header ahead
function parser_header:pack(data)
  return string.pack('IbA', #data, 1, data)
end

--- unpack data
-- @param the binary msg with header ahead
-- @return msg and version
function parser_header:unpack(data)
  local offset, size, version = string.unpack(data, 'Ib')
  assert (offset == 6)

  local msg = string.unpack(data, string.format('%dA', size), offset)

  return msg, version
end
