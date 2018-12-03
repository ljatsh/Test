
local posix_error = require('posix.errno')

-- error description

local errors = {}
for name, value in pairs (require 'posix.errno') do
  if type (value) == 'number' then
    errors[#errors + 1] = {name, value}
  end
end

table.sort(errors, function(a, b)
  return a[2] < b[2]
end)

print('------------------------------- unix errors(posix.errno) --------------------------------')
print(string.format('%-20s%-60s%5s', 'error', 'description', 'error no'))
for _, v in ipairs(errors) do
  print(string.format('%-20s%-60s%-5d', v[1], posix_error.errno(v[2])))
end

-- 