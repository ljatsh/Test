
// https://www.geeksforgeeks.org/binary-tree-data-structure/?ref=lbp
// 二叉树

function tree_new(label, left, right) {
  return {
    label: label,
    left: left,
    right: right
  }
}

function tree_label(r) {
  return r.label;
}

function queue_new() { return []; }
function queue_empty(q) { return q.length == 0; }
function queue_top(q) { return q[0]; }
function queue_enqueue(q, v) { q.push(v); }
function queue_dequeue(q) { return q.shift(); }

function stack_new() { return []; }
function stack_empty(s) { return s.length == 0; }
function stack_top(s) { return s[s.length - 1]; }
function stack_push(s, v) { s.push(v); }
function stack_pop(s) { return s.pop(); }
function stack_dump(s, visit) { return s.map(x => `T(${visit(x)})`); }

// -----------------------------------------------------------------
// Basic Operations on Binary Tree:

// tree traversal

// in-order
function *visit_tree_inorder_recursilve(r) {
  if (!r) return;

  for (let v of visit_tree_inorder_recursilve(r.left))
    yield v;
  yield tree_label(r);
  for (let v of visit_tree_inorder_recursilve(r.right))
    yield v;
}

function *visit_tree_inorder_iterative(r) {
  let n = r;
  let s = stack_new();

  while (n || !stack_empty(s)) {
    while (n) {
      stack_push(s, n);
      n = n.left;
    }

    n = stack_pop(s);
    yield tree_label(n);

    n = n.right;
  }
}

// pre-order
function *visit_tree_preorder_recursilve(r) {
  if (!r) return;

  yield tree_label(r);
  for (let v of visit_tree_preorder_recursilve(r.left))
    yield v;
  for (let v of visit_tree_preorder_recursilve(r.right))
    yield v;
}

function *visit_tree_preorder_iterative(r) {
  let n = r;
  let s = stack_new();
  
  while (n) {
    yield tree_label(n);

    if (n.right)
      stack_push(s, n.right);
    if (n.left)
      stack_push(s, n.left);
      
    n = stack_pop(s);
  }
}

// post-order
function *visit_tree_postorder_recursilve(r) {
  if (!r) return;

  for (let v of visit_tree_postorder_recursilve(r.left))
    yield v;
  for (let v of visit_tree_postorder_recursilve(r.right))
    yield v;
  yield tree_label(r);
}

// https://www.geeksforgeeks.org/iterative-postorder-traversal/
// TODO Tail Call Recursion https://en.wikipedia.org/wiki/Tail_call
// 直接遍历困难
function *visit_tree_postorder_itervative(r) {
  let s_outer = stack_new(), s_inner = stack_new();
  let n = r;

  while (n) {
    stack_push(s_outer, n);

    if (n.left)
      stack_push(s_inner, n.left);
    if (n.right)
      stack_push(s_inner, n.right);
    
    n = stack_pop(s_inner);
  }
  
  while (!stack_empty(s_outer))
    yield tree_label(stack_pop(s_outer));
}

// level-order
function *visit_tree_levelorder(r) {
  let q = queue_new();
  let n = r;
  while (n) {
    yield tree_label(n);
    if (n.left)
      queue_enqueue(q, n.left);
    if (n.right)
      queue_enqueue(q, n.right);

    n = queue_dequeue(q);
  }
}

// TODO Morris traversal

// https://www.geeksforgeeks.org/reverse-level-order-traversal/
// reverse level-order
function *visit_tree_reverse_levelorder(r) {
  let s = stack_new(), q = queue_new();
  let n = r;
  while (n) {
    stack_push(s, n);
    if (n.right)
      queue_enqueue(q, n.right);
    if (n.left)
      queue_enqueue(q, n.left);
      
    n = queue_dequeue(q);
  }

  while (!stack_empty(s))
    yield tree_label(stack_pop(s));
}

// https://www.geeksforgeeks.org/find-the-maximum-depth-or-height-of-a-tree/
// 树的高度
function tree_height_recursively(r) {
  if (!r) return 0;

  let h1 = tree_height_recursively(r.left);
  let h2 = tree_height_recursively(r.right);
  return 1 + Math.max(h1, h2);
}

function tree_height(r) {
  let h = 0;
  
  if (!r) return h;
  let q = queue_new();
  queue_enqueue(q, r);
  queue_enqueue(q, null);
  
  let n;
  while (!queue_empty()) {
    n = queue_dequeue(q);
    if (n) {
      if (n.left)
        queue_enqueue(q, n.left);
      if (n.right)
        queue_enqueue(q, n.right);
    } else {
      h++;
      queue_enqueue(q, null); // 一层访问完毕, 下一层的节点必然都进入队列了
    }
  }
  
  return h;
}

// https://www.geeksforgeeks.org/deletion-binary-tree/
// 事实上是删除最底层的最右侧节点

function tree_remove_key(r, key) {
  let node_key;
  let parent_replace, replace, left;
  let q = queue_new();
  queue_enqueue(q, r);

  let n;
  while (!queue_empty(q)) {
    n = queue_dequeue(q);
    if (tree_label(n) == key)
      node_key = n;

    if (n.left) {
      queue_enqueue(q, n.left);

      parent_replace = n;
      replace = n.left;
      left = true;
    }
    if (n.right) {
      queue_enqueue(q, n.right);

      parent_replace = n;
      replace = n.right;
      left = false;
    }
  }

  if (!node_key) return;

  node_key.label = replace.label;
  if (left)
    parent_replace.left = null;
  else
    parent_replace.right = null;
}

// Must solve Standard Problems on Binary Tree Data Structure

// https://www.geeksforgeeks.org/construct-tree-from-given-inorder-and-preorder-traversal/
// 根据前序和中序的访问序列, 唯一确定树的结构

function build_tree_from_preorder_inorder_sequence(preorder, inorder) {
  if (preorder.length == 0) return;

  let key = preorder[0];
  let n = tree_new(key);
  let i = inorder.indexOf(key);
  let inorder_left = inorder.slice(0, i);
  let inorder_right = inorder.slice(i+1);
  let preorder_left = preorder.slice(1, 1+inorder_left.length);
  let preorder_right = preorder.slice(1+inorder_left.length);

  n.left = build_tree_from_preorder_inorder_sequence(preorder_left, inorder_left);
  n.right = build_tree_from_preorder_inorder_sequence(preorder_right, inorder_right);

  return n;
}

// TODO 迭代的方法

// https://www.geeksforgeeks.org/construct-tree-inorder-level-order-traversals/
// 根据中序、层级的访问序列, 唯一确定树的结构

function build_tree_from_inorder_level_sequence(inorder, level) {
  if (level.length == 0) return;

  let key = level[0];
  let n = tree_new(key);
  let i = inorder.indexOf(key);
  let inorder_left = inorder.slice(0, i);
  let inorder_right = inorder.slice(i+1);
  let level_left = [], level_right = [];
  for (let j=1; j<level.length; j++) {
    if (inorder_left.indexOf(level[j]) != -1)
      level_left.push(level[j]);
    else
      level_right.push(level[j]);
  }
  
  n.left = build_tree_from_inorder_level_sequence(inorder_left, level_left.join(''));
  n.right = build_tree_from_inorder_level_sequence(inorder_right, level_right.join(''));

  return n;
}

// TODO 迭代的方法

let root = tree_new(25,
                    tree_new(15,
                             tree_new(10,
                                      tree_new(4),
                                      tree_new(12)
                                     ),
                             tree_new(22,
                                      tree_new(18),
                                      tree_new(24)
                                      )
                             ),
                    tree_new(50,
                             tree_new(35,
                                      tree_new(31),
                                      tree_new(44)
                                      ),
                             tree_new(70,
                                      tree_new(66),
                                      tree_new(90)
                                      )
                             )
                    );

let result = [...visit_tree_inorder_recursilve(root)];
console.log(`中序递归遍历:${result}`);
result = [...visit_tree_inorder_iterative(root)];
console.log(`中序迭代遍历:${result}`);
result = [...visit_tree_preorder_recursilve(root)];
console.log(`前序递归遍历:${result}`);
result = [...visit_tree_preorder_iterative(root)];
console.log(`前序迭代遍历:${result}`);
result = [...visit_tree_postorder_recursilve(root)];
console.log(`后序递归遍历:${result}`);
result = [...visit_tree_postorder_itervative(root)];
console.log(`后序迭代遍历:${result}`);
result = [...visit_tree_levelorder(root)];
console.log(`层级遍历:${result}`);

root = tree_new(1,
                tree_new(2,
                        tree_new(4),
                        tree_new(5)
                        ),
                tree_new(3));
result = [...visit_tree_reverse_levelorder(root)];
console.log(`层级逆序遍历:${result}\n`);

root = tree_new(1,
                tree_new(2,
                         tree_new(4),
                         tree_new(5)
                         ),
                tree_new(3)
                );
console.log(`递归计算树高${tree_height_recursively(root)}`);
console.log(`层级计算树高${tree_height_recursively(root)}`);

root = tree_new(10,
                tree_new(11,
                        tree_new(7),
                        tree_new(12)
                        ),
                tree_new(9,
                         tree_new(15),
                         tree_new(8)
                         )
                );
result = [...visit_tree_inorder_recursilve(root)];
console.log(`删除前:${result}`);
tree_remove_key(root, 11);
result = [...visit_tree_inorder_recursilve(root)];
console.log(`删除11, 按照层级缩减后: ${result}`);

root = tree_new(9,
                tree_new(2,
                        tree_new(4),
                        tree_new(7)
                        ),
                tree_new(8)
                );
result = [...visit_tree_inorder_recursilve(root)];
console.log(`删除前:${result}`);
tree_remove_key(root, 7);
result = [...visit_tree_inorder_recursilve(root)];
console.log(`删除7, 按照层级缩减后: ${result}\n`);

root = build_tree_from_preorder_inorder_sequence('ABDECF', 'DBEAFC');
result = [...visit_tree_preorder_iterative(root)];
console.log(`根据前序、中序访问序列, 重构后的树前序为:${result}`);
result = [...visit_tree_inorder_iterative(root)];
console.log(`根据前序、中序访问序列, 重构后的树中序为:${result}`);

root = build_tree_from_inorder_level_sequence('DBFEGAC', 'ABCDEFG');
result = [...visit_tree_inorder_iterative(root)];
console.log(`根据中序、层级访问序列, 重构后的树中序为:${result}`);
result = [...visit_tree_levelorder(root)];
console.log(`根据中序、层级访问序列, 重构后的树层级为:${result}`);