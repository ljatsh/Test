
local tree = require('tree')

describe('tree test', function()
  it('very simple', function()
    ---           1
    ---           |
    ---          2,3
    local node = tree.new(1, tree.new(2), tree.new(3))

    for v in coroutine.wrap(node.visit_generator), node do
      print(v)
    end
  end)

  it('simple', function()
    ---           1
    ---           |
    ---        2,    3
    ---        |     |
    ---      4,5,6  7,8,9
    local node2 = tree.new(2, tree.new(4), tree.new(5), tree.new(6))
    local node3 = tree.new(3, tree.new(7), tree.new(8), tree.new(9))
    local root = tree.new(1, node2, node3)

    for v in coroutine.wrap(root.visit_generator), root do
      print(v)
    end
  end)

  it('complex', function()
    ---                 1
    ---                 |
    ---        2,       3       4
    ---        |        |       |
    ---      5,  6     7,8     9,10
    ---      |   |     |          |
    ---    11,12 13,14 15,16     17,18
    local node5 = tree.new(5, tree.new(11), tree.new(12))
    local node6 = tree.new(6, tree.new(13), tree.new(14))
    local node7 = tree.new(7, tree.new(15), tree.new(16))
    local node10 = tree.new(10, tree.new(17), tree.new(18))
    
    local node2 = tree.new(2, node5, node6)
    local node3 = tree.new(3, node7, tree.new(8))
    local node4 = tree.new(4, tree.new(9), node10)

    local root = tree.new(1, node2, node3, node4)

    for v in coroutine.wrap(root.visit_generator), root do
      print(v)
    end
  end)
end)
