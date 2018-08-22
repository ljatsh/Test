
describe('iterator', function()
  -- 1. iterator was a function
  -- 2. for semantics: one iterator with 2 parameters, invariant state and control value
  -- 3. prefer stateless iterator in '''for''' statement (see snippets.split)
  it('for semantics', function()
    local t = {}
    function t.f() end

    local s = stub.new(t, 'f')

    s.on_call_with(nil, nil).returns(1)
    s.on_call_with(nil, 1).returns(5)
    s.on_call_with(nil, 5).returns(nil)

    s.on_call_with(10, 3).returns(4)
    s.on_call_with(10, 4).returns(5)
    s.on_call_with(10, 5).returns(nil)

    local r = {}
    for v in s do r[#r + 1] = v end

    assert.stub(s).was.called(3)
    assert.stub(s).was.called_with(nil, nil)
    assert.stub(s).was.called_with(nil, 1)
    assert.stub(s).was.called_with(nil, 5)
    assert.are.same({1, 5}, r)

    s:clear()
    r = {}
    for v in t.f, 10, 3 do r[#r + 1] = v end

    assert.stub(s).was.called(3)
    assert.stub(s).was.called_with(10, 3)
    assert.stub(s).was.called_with(10, 4)
    assert.stub(s).was.called_with(10, 5)
    assert.are.same({4, 5}, r)
  end)
end)
