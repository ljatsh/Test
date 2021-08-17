
-- https://www.geeksforgeeks.org/binary-tree-data-structure/

local stack = require('stack')
local queue = require('queue')

local mt = {}

-- https://www.geeksforgeeks.org/iterative-preorder-traversal/
-- Following is a simple stack based iterative process to print Preorder traversal.
-- 1) Create an empty stack nodeStack and push root node to stack. 
-- 2) Do the following while nodeStack is not empty. 
--    ….a) Pop an item from the stack and print it. 
--    ….b) Push right child of a popped item to stack 
--    ….c) Push left child of a popped item to stack
-- The right child is pushed before the left child to make sure that the left subtree is processed first.

function mt.preorder_generator(self)
  local s = stack.new()
  s:push(self)

  local tree
  while not s:is_empty() do
    tree = s:pop()
    coroutine.yield(tree.value)

    if tree.right then
      s:push(tree.right)
    end
    if tree.left then
      s:push(tree.left)
    end
  end
end

-- https://www.geeksforgeeks.org/inorder-tree-traversal-without-recursion/
-- 1) Create an empty stack S.
-- 2) Initialize current node as root
-- 3) Push the current node to S and set current = current->left until current is NULL
-- 4) If current is NULL and stack is not empty then 
--    a) Pop the top item from stack.
--    b) Print the popped item, set current = popped_item->right 
--    c) Go to step 3.
-- 5) If current is NULL and stack is empty then we are done.

function mt.inorder_generator(self)
  local s = stack.new()

  local tree = self

  while not (tree == nil and s:is_empty()) do
    while tree ~= nil do
      s:push(tree)
      tree = tree.left
    end
  
    if not s:is_empty() then
      tree = s:pop()
      coroutine.yield(tree.value)
  
      tree = tree.right
    end
  end
end

-- https://www.geeksforgeeks.org/level-order-tree-traversal/
-- For each node, first the node is visited and then it’s child nodes are put in a FIFO queue. 
-- 1) Create an empty queue q
-- 2) temp_node = root /*start from root*/
-- 3) Loop while temp_node is not NULL
--     a) print temp_node->data.
--     b) Enqueue temp_node’s children 
--       (first left then right children) to q
--     c) Dequeue a node from q.

function mt.levelorder_generator(self)
  local q = queue.new()
  local tree = self
  q:push(tree)

  while not q:is_empty() do
    tree = q:pop()
    coroutine.yield(tree.value)

    if tree.left then
      q:push(tree.left)
    end
    if tree.right then
      q:push(tree.right)
    end
  end
end


local btree = {}

function btree.new(value, left, right)
  return setmetatable({value = value, left = left, right = right}, {__index = mt})
end

return btree
