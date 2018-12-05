
local test = require('test')
local hp = require('helper')

describe('test', function()
  it('tmpnam', function()
    assert.has.error.match(function() test.tmpnam(1) end, 'invalid parameters were passed to get_tmpfile_name')
    assert.is.string(test.tmpnam())
    assert.are.no.same(test.tmpnam(), test.tmpnam())
  end)
end)

describe('helper', function()
  -- TODO
  it('create_tmp_file', function()
    local path, fd, err_str, err_no = hp.create_tmp_file()
    assert.is.string(path)
    assert.is.no_nil(fd)
  end)
end)
