
local pu = require('posix.unistd')
local hp = require('helper')

describe('unistd', function()
  it('lseek', function()
    local _, fd = hp.create_tmp_file()

    -- we can get current file offset by lseek
    assert.are.same(0, pu.lseek(fd, 0, pu.SEEK_CUR))
    assert.are.same(10, pu.write(fd, '0123456789'))
    assert.are.same(10, pu.lseek(fd, 0, pu.SEEK_CUR))

    -- lseek use scenarios. lseek does not cause any I/O to take place.
    assert.are.same(5, pu.lseek(fd, 5, pu.SEEK_SET))
    assert.are.same('567', pu.read(fd, 3))
    assert.are.same(7, pu.lseek(fd, -3, pu.SEEK_END))
    assert.are.same('789', pu.read(fd, 4), 'reached the end')

    pu.lseek(fd, 5, pu.SEEK_SET)
    pu.write(fd, 'abc')
    pu.lseek(fd, 0, pu.SEEK_SET)
    assert.are.same('01234abc89', pu.read(fd, 10), 'content was overwritten')

    -- we can test lseek result to check whether the fd is capabale of seeking
    -- @see samples/check_seek.lua
  end)
end)
