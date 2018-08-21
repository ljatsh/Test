
describe('function', function()
  -- syntax sugar:
  -- 1. if the function has only 1 single parameter, and this argument is either a literal string
  --    or a table constructor, then the parentheses are optional.
  -- 2. local function f() end ==> local f; f = function() end;
  -- 3. function f() end ==> f = function() end;
  it('syntax sugar', function()
    -- 1.
    local s = spy.new(function() end)

    s'hello'
    assert.spy(s).was.called(1)
    assert.spy(s).was.called_with('hello')

    s:clear()
    s 'hello'   -- preferred way
    assert.spy(s).was.called(1)
    assert.spy(s).was.called_with('hello')

    s:clear()
    s{1, nil, 2}
    assert.spy(s).was.called(1)
    assert.spy(s).was.called_with({1, nil, 2})

    -- 2.
    local f1 = function(n)
      if n == 0 then
        return 1
      else
        return n * f1(n - 1) -- f1 is upvalue <-- nil
      end
    end

    local function f2(n)
      if n == 0 then
        return 1
      else
        return n * f2(n - 1) -- f2 is upvalue <-- f2
      end
    end

    assert.has.error.match(function() return f1(3) end, "attempt to call a nil value")
    assert.has.no.error(function() f2(3) end)
  end)

  -- 1. function results are all discarded in statement.
  -- 2. only the first result is picked up in expression.
  -- 3. we get results only when the call was the last(or the only) expression in a list of expressions:
  --    a) multiple assignments
  --    b) arguments to function calls
  --    c) table constructors
  --    d) return statements
  -- 4. we can force a call to return exactly one result by enclosing it in an extra pair of parenthese

  it('multiple results - expression', function()
    local t = {}
    function t.g() return 1 end
    function t.h() return 2 end
    function t.f() return t.g(), t.h() end    -- clousure, not a good style.

    spy.on(t, 'g')
    spy.on(t, 'h')
    assert.are.same(2, 1 + t.f())
    assert.spy(t.g).was.called(1)
    assert.spy(t.h).was.called(1)
  end)

  it('multiple results - multiple assignments', function()
    local function f() return nil, 2, 3 end

    -- only the 1st returned values was picked up
    local a, b = f(), 'a'
    assert.is_nil(a)
    assert.are.same('a', b)

    local a, b = f()
    assert.is_nil(a)
    assert.are.same(2, b)

    local a, b, c = f()
    assert.is_nil(a)
    assert.are.same(2, b)
    assert.are.same(3, c)

    local a, b, c, d = f()
    assert.is_nil(a)
    assert.are.same(2, b)
    assert.are.same(3, c)
    assert.is_nil(d)
  end)

  it('multiple results - function calls', function()
    local function g() end
    local s = spy.new(g)
    local function f() return 1, 2, 3 end

    -- not last one
    s(f(), 10)
    assert.spy(s).was.called_with(1, 10)

    -- last one
    s:clear()
    s(f())
    assert.spy(s).was.called_with(1, 2, 3)
    
    s:clear()
    s(10, f())
    assert.spy(s).was.called_with(10, 1, 2, 3)
  end)

  it('multiple results - table constructors', function()
    local function f() return 1, 2, 3 end
    local function g() return 1, nil, 3 end
    local function h() return 1, nil, 2, nil end

    -- not last one
    assert.are.same({1, 10}, {f(), 10})

    -- last one
    assert.are.same({1, 2, 3}, {f()})
    
    assert.are.same({10, 1, 2, 3}, {10, f()})

    -- !Caution
    -- sparse table is created with nil elements discared
    assert.are.same({[1] = 1, [3] = 3}, {g()})
    assert.are.same({[1] = 1, [3] = 2}, {h()})
  end)

  it('multiple results - force to return only 1 result', function()
    local s = spy.new(function() end)
    local f = function() return 1, 2, 3 end

    s(10, f())
    assert.spy(s).was.called_with(10, 1, 2, 3)

    s:clear()
    s(10, (f()))
    assert.spy(s).was.called_with(10, 1)
  end)

  -- the safer way to traverse variable parameters is table.pack or select(index, ...)
  -- {...} is much more convenient
  it('variadic function', function()
    
  end)

  -- it seems the anoymous function, and all the upvalues determines a closure.
  -- upvalues: https://www.lua.org/pil/27.3.3.html
  it('closure - general', function()
    local v
    local f1 = function()
      return function() return v end
    end
    local f2 = function(test)
      return function() return test end
    end
    local f3 = function()
      local t = {}
      return function() return t end
    end

    -- TODO not stable (research lua implementation)
    --assert.are.equal(f1(), f1(), 'both are determined by f1, v')
    assert.are.equal(f1()(), f1()())

    assert.are.no.equal(f2(v), f2(v), 'upvalues in higher-function parameters are different, event if they refer the same value')
    assert.are.equal(f2(v)(), f2(v)())

    assert.are.no.equal(f3(), f3(), 'upvalues are different')
    assert.are.no.equal(f3()(), f3()())
  end)

  it('closure - non-global functions with nested calling', function()
    do
      local g

      local function f1()
        h()
      end
      local function f2()
        g()
      end

      function g() end
      local function h() end

      assert.has.error.match(function() f1() end, 'attempt to call a nil value')
      assert.has.no.error(function() f2() end)
    end

    assert.is_nil(g, 'g is local')
  end)
end)
