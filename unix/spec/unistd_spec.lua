
local pu = require('posix.unistd')
local pe = require('posix.errno')
local pf = require('posix.fcntl')
local hp = require('helper')

describe('unistd', function()
  -- -1 error
  -- 0 end of file is encountered
  -- there are several cases in which returned number of bytes actually read is less than the amount requested:
  -- 1) no more available bytes in regular file
  -- 2) When reading from a terminal, normally, up to 1 line is read at a time.
  -- 3) When reading from network, buferring can affect the returned bytes.
  -- 4) Signal can interrupt the system call, then a partial amount of data will be read.
  it('read', function()
    local path, fd = hp.create_tmp_file()
    local content = string.rep('0123456789', 100, ';')
    assert.are.same(#content, pu.write(fd, content))

    -- normal operation
    pu.lseek(fd, -10, pu.SEEK_END)
    local s, err_str, err_no = pu.read(fd, 20)
    assert.are.same('0123456789', s, 'only 10 bytes should be read')
    assert.is_nil(err_str)
    assert.is_nil(err_no)
    assert.are.same('', (pu.read(fd, 100)), 'zero bytes should be read')

    -- read from an invalid fd
    local _, _, err_no = pu.read(2000, 100)
    assert.are.same(pe.EBADF, err_no)

    -- read from a read only file
    -- TODO fd2 is nil, why?
    -- local fd2 = pf.open(path, pf.O_WRONLY)
    -- assert.is.not_nil(fd2)
    -- assert.is_nil(pu.read(fd2, 1))

    assert.are.same(0, pu.close(fd))
  end)

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

    assert.are.same(0, pu.close(fd))

    -- we can test lseek result to check whether the fd is capabale of seeking
    -- @see samples/check_seek.lua
  end)
end)
