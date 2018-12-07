
local pf = require('posix.fcntl')
local hp = require('helper')
local test = require('test')

-- TODO why O_EXEC and O_SEARCH are not exported in posix.lua?
describe('fcntl', function()
  -- 1. One of O_RDONLY O_WRONLY O_RDWR O_EXEC O_SEARCH must be set.
  --    This five flags cannot be oring together.
  it('open', function()
    
  end)

  it('fcntl', function()
    local _, fd = hp.create_tmp_file()

    local flag = pf.fcntl(fd, pf.F_GETFL)
    assert.are.same(pf.O_RDWR, flag & test.O_ACCMODE)

    -- flag = flag & (~test.O_ACCMODE)
    -- flag = flag | pf.O_WRONLY

    -- pf.fcntl(fd, pf.F_SETFL)

  end)
end)