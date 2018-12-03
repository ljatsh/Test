
local posix_fcntl = require('posix.fcntl')

-- TODO why O_EXEC and O_SEARCH are not exported in posix.lua?
describe('fcntl', function()
  -- 1. One of O_RDONLY O_WRONLY O_RDWR O_EXEC O_SEARCH must be set.
  --    This five flags cannot be oring together.
  it('api_open', function()
    
  end)
end)