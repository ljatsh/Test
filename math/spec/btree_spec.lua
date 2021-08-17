
local stack = require('stack')
local queue = require('queue')
local btree = require('btree')

describe('base', function()
  it('stack', function()
    local s = stack.new()
    assert.is.truthy(s:is_empty())
    s:push(1)
    s:push(2)
    s:push(3)
    assert.is.falsy(s:is_empty())

    assert.are.same(3, s:pop())
    assert.are.same(2, s:pop())
    assert.are.same(1, s:pop())
    assert.is_nil(s:pop())
    assert.is.truthy(s:is_empty())
  end)

  it('queue', function()
    local q = queue.new()
    assert.is.truthy(q:is_empty())
    q:push(1)
    q:push(2)
    q:push(3)
    assert.is.falsy(q:is_empty())

    assert.are.same(1, q:pop())
    assert.are.same(2, q:pop())
    assert.are.same(3, q:pop())
    assert.is_nil(q:pop())
    assert.is.truthy(q:is_empty())
  end)
end)

describe('btree', function()
  local self = {}
  ---              1
  ---           /      \
  ---         2         3
  ---          \       /  \
  ---           4     5    6
  ---          /
  ---         10

  setup(function()
    local node4 = btree.new(4, btree.new(10))
    local node2 = btree.new(2, nil, node4)
    local node3 = btree.new(3, btree.new(5), btree.new(6))

    self._tree = btree.new(1, node2, node3)
  end)

  it('preorder traversal', function()
    local results = {}
    for v in coroutine.wrap(self._tree.preorder_generator), self._tree do
      results[#results + 1] = v
    end
    assert.are.same({1, 2, 4, 10, 3, 5, 6}, results)
  end)

  it('inorder traversal', function()
    local results = {}
    for v in coroutine.wrap(self._tree.inorder_generator), self._tree do
      results[#results + 1] = v
    end
    assert.are.same({2, 10, 4, 1, 5, 3, 6}, results)
  end)

  it('levelorder traversal', function()
    local results = {}
    for v in coroutine.wrap(self._tree.levelorder_generator), self._tree do
      results[#results + 1] = v
    end
    assert.are.same({1, 2, 3, 4, 5, 6, 10}, results)
  end)
end)
