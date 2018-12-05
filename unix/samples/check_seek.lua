
local pu = require('posix.unistd')

local offset, str_err, str_no = pu.lseek(pu.STDIN_FILENO, 0, pu.SEEK_CUR)

if offset == nil then
  print(string.format('failed to seek:%s', str_err))
  return
end

print('seek successfully')
