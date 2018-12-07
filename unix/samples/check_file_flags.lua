
local pf = require('posix.fcntl')
local pu = require('posix.unistd')
local test = require('test')

--[[
  $ check 0 < /dev/tty
    read only
  $ check 1 > temp.foo
  $ cat temp.foo
    write only
  $ check 2 2>>temp.foo
    write only, append
  $ check 5 5<>temp.foo
    read write
]]

local fd = tonumber(...)
if fd == nil then
  fd = pu.STDIN_FILENO
end

local flags, err_str = pf.fcntl(fd, pf.F_GETFL)
if flags == nil then
  print(err_str)
  return 1
end

local acc_value = flags & test.O_ACCMODE

if acc_value == pf.O_RDONLY then
  io.write('read only')
elseif acc_value == pf.O_WRONLY then
  io.write('write only')
elseif acc_value == pf.O_RDWR then
  io.write('read and write')
end

if (flags & pf.O_APPEND) > 0 then
  io.write(', append')
end
if (flags & pf.O_NONBLOCK) > 0 then
  io.write(', nonblocking')
end
if (flags & pf.O_SYNC) > 0 then
  io.write(', synchronous writes')
end

io.write('\n')

return 0
