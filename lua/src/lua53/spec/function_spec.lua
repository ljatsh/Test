
describe('function', function()
  -- syntax sugar:
  -- 1. if the function has only 1 single parameter, and this argument is either a literal string
  --    or a table constructor, then the parentheses are optional.
  it('syntax sugar', function()
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

  -- the safer way to traverse variable parameters is table.pack
  it('variadic function', function()
    
  end)
end)

-- Programming in Lua-->Functions
-- http://www.lua.org/pil/5.html

-- module ("cp5", lunit.testcase, package.seeall)

--     function testVariableFunction()
--         local function func_test(...)
--             return select('#', ...), select(1, ...)
--         end

--         local count = func_test()
--         assert_equal(0, count, 'zero arguments')

--         count, p1 = func_test(1)
--         assert_equal(1, count, '1 arguments')
--         assert_equal(1, p1)

--         count, p1, p2 = func_test(1, 'a', 'b')
--         assert_equal(3, count, '3 arguments')
--         assert_equal(1, p1)
--         assert_equal('a', p2)
--     end
