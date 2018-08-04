
local skynet = require('skynet')

describe('skynet', function()
  it('t1', function()
    assert.are.same(1, 100 - 99)

    print('hello, skynet-->', skynet.time())
    skynet.sleep(100)
    print('hello, i was back-->', skynet.time())

    print('t1 ended')
  end)
end)