
local posix_errno = require('posix.errno')

describe('errno', function()
  it('api_errno', function()
    local err_str, err_no = posix_errno.errno(posix_errno.EPIPE)
    assert.are.same('Broken pipe', err_str)
    assert.is.number(err_no)
    assert.are.same(posix_errno.EPIPE, err_no)
  end)

  it('api_set_errno', function()
    local err_str, err_no = posix_errno.errno()
    assert.are.no.same(posix_errno.ECANCELED, err_str)
    posix_errno.set_errno(posix_errno.ECANCELED)
    err_str, err_no = posix_errno.errno()
    assert.are.same('Operation canceled', err_str)
    assert.are.same(posix_errno.ECANCELED, err_no)
  end)
end)
