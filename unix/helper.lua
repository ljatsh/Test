
local test = require('test')
local pf = require('posix.fcntl')
local pu = require('posix.unistd')

local M_ = {}

function M_.create_tmp_file()
  local path = test.tmpnam()
  if path == nil then
    return nil, 'faled to call tmpnam'
  end

  local flags = pf.O_RDWR | pf.O_CLOEXEC | pf.O_CREAT | pf.O_EXCL
  local fd, err_str, err_no = pf.open(path, flags)

  if fd ~= nil then
    -- TODO error check?
    pu.unlink(path)
  end

  return path, fd, err_str, err_no
end

return M_
