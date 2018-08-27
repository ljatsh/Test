
describe('coroutine', function()
  -- resume-yield pair can exchange data between caller and the callee
  it('basics', function()
    local t = {}
    function t.visit(...) end
    function t.f(x, y)
      local a, b, c =  coroutine.yield(1, 'a', {})
      t.visit(a, b, c)

      a, b, c = coroutine.yield(2, 'b', false)
      t.visit(a, b, c)

      return 3, 'c'
    end

    spy.on(t, 'visit')
    spy.on(t, 'f')

    local co = coroutine.create(function(...) return t.f(...) end)
    assert.are.same('thread', type(co))
    assert.spy(t.f).was.called(0)

    local r = table.pack(coroutine.resume(co, 10, 20))
    assert.are.same({true, 1, 'a', {}, n=4}, r)
    assert.spy(t.f).was.called(1)
    assert.spy(t.f).was.called_with(10, 20)
    -- yield test
    assert.spy(t.visit).was.called(0)

    r = table.pack(coroutine.resume(co, 'x', 'y', 'z'))
    assert.are.same({true, 2, 'b', false, n=4}, r)
    -- function entered only once
    assert.spy(t.f).was.called(1)
    assert.spy(t.visit).was.called(1)
    assert.spy(t.visit).was.called_with('x', 'y', 'z')

    r = table.pack(coroutine.resume(co, 'z', 'y', 'x'))
    assert.are.same({true, 3, 'c', n=3}, r)
    assert.spy(t.f).was.called(1)
    assert.spy(t.visit).was.called(2)
    assert.spy(t.visit).was.called_with('z', 'y', 'x')
  end)

  -- suspended: initial state or yield
  -- running: top stack was inside the thread
  -- normal: top statck was inside other thread
  -- dead: end
  it('status', function()
    local co = coroutine.create(function()
      coroutine.yield(coroutine.status(coroutine.running()))

      local co2 = coroutine.wrap(function(old) return coroutine.status(old) end)
      return co2(coroutine.running())
    end)

    assert.are.same('suspended', coroutine.status(co))
    local _, s = coroutine.resume(co)
    assert.are.same('running', s)
    assert.are.same('suspended', coroutine.status(co))

    _, s = coroutine.resume(co)
    assert.are.same('dead', coroutine.status(co))
    assert.are.same('normal', s)
  end)

  -- resume runs under protection mode
  -- wrap does not
  it('error', function()
    local co = coroutine.create(function() assert(false) end)
    local r, error = coroutine.resume(co)
    assert.is_false(r)
    assert.has.match('assertion failed!', error)

    co = coroutine.wrap(function() assert(false) end)
    assert.has.error.match(function() co() end, 'assertion failed!')
  end)

  -- consumer runs on main loop
  it('scenario - producer and consumer 1', function()
    local producer = coroutine.wrap(function()
      repeat
        local data = io.read()
        if data == '' then break end
        coroutine.yield(data)
      until false
    end)

    local function consumer(prod)
      local t = {}

      for data in prod do
        t[#t + 1] = data
      end

      return t
    end

    local s = stub.new(io, 'read')
    local i = 0
    s.by_default.invokes(function()
      i = i + 1
      if i <= 3 then return tostring(i) end
      return ''
    end)
    assert.are.same({'1', '2', '3'}, consumer(producer))

    s:revert() -- TODO stub affets other test case
  end)

  -- producer runs on main loop
  it('scenario - producer and consumer 2', function()
    local function producer(cons)
      local s = stub.new(io, 'read')

      local i = 1
      while true do
        if i <= 3 then
          s.returns(i)
        else
          s.returns('quit')
        end

        if not cons(io.read()) then
          s:revert()
          break
        end

        i = i + 1
      end
    end

    local t = {}
    local consumer = coroutine.wrap(function(data)
      while data ~= 'quit' do
        t[#t + 1] = data
        data = coroutine.yield(true)
      end

      -- notify that I'm dead
      return false
    end)

    producer(consumer)
    assert.are.same({1, 2, 3}, t)
  end)

  it('scenario - producer and consumer pattern', function()
    local producer = coroutine.wrap(function()
      repeat
        local data = io.read()
        if data == '' then break end
        coroutine.yield(data)
      until false
    end)

    local function filter(prod)
      return coroutine.wrap(function()
        local i = 1
        for data in prod do
          coroutine.yield(string.format('line %d:%s', i, data))
          i = i + 1
        end
      end)
    end

    local function consumer(prod)
      for data in prod do
        io.write(data, '\n')
      end
    end

    local s = stub.new(io, 'read')
    local i = 0
    s.by_default.invokes(function()
      i = i + 1
      if i <= 3 then return tostring(i) end
      return ''
    end)
    local s2 = stub.new(io, 'write')

    consumer(filter(producer))
    assert.stub(s2).was.called(3)
    assert.stub(s2).was.called_with('line 1:1', '\n')
    assert.stub(s2).was.called_with('line 2:2', '\n')
    assert.stub(s2).was.called_with('line 3:3', '\n')
    s2:revert()
    s:revert()
  end)

  -- Perfer generator iteration style(likes Python). Coroutine is a great tool for this concept.
  it('iterator - generator', function()
    local function generator(n)
      for i=1, n do coroutine.yield(i * 2) end
    end

    local r = {}
    for i in coroutine.wrap(generator), 3 do r[#r + 1] = i end
    assert.are.same({2, 4, 6}, r)
  end)
end)
