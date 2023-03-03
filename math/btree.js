
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

// pre-order
function *visit_tree_preorder_recursilve(r) {
  if (!r) return;

  yield tree_label(r);
  for (let v of visit_tree_preorder_recursilve(r.left))
    yield v;
  for (let v of visit_tree_preorder_recursilve(r.right))
    yield v;
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
result = [...visit_tree_preorder_recursilve(root)];
console.log(`前序递归遍历:${result}`);
result = [...visit_tree_postorder_recursilve(root)];
console.log(`后序递归遍历:${result}`);
result = [...visit_tree_levelorder(root)];
console.log(`层级遍历:${result}`);