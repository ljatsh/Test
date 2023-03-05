
// https://www.geeksforgeeks.org/binary-search-tree-data-structure/?ref=shm
// binary search tree

// 二叉树的操作不超过树的高度, 因此如果控制高度成为了关键. AVL和RB tree需要大概了解下

function tree_new(label, left = null, right = null) {
  return {
    label: label,
    left: left,
    right: right
  }
}

function tree_label(r) {
  return r.label;
}

function tree_search(r, k) {
  let n = r;
  while (n) {
    if (k < tree_label(n)) {
      n = n.left;
    }
    else if (k > tree_label(n)) {
      n = n.right;
    }
    else {
      return n;
    }
  }
}

function tree_insert(r, k) {
  if (!r) {
    return tree_new(k);
  }

  let n = r;
  while (n) {
    if (k < tree_label(n)) {
      if (!n.left) {
        n.left = tree_new(k);
        return r;
      }
      
      n = n.left;
    }
    else if (k > tree_label(n)) {
      if (!n.right) {
        n.right = tree_new(k);
        return r;
      }

      n = n.right;
    }
    else {
      return r;
    }
  }
}

function tree_min(r) {
  let n = r;
  while (n) {
    if (!n.left)
      return n;

    n = n.left;
  }
}

function tree_search_parent(r, k) {
  let parent, is_left_child;
  let n = r;
  while (n) {
    if (k < tree_label(n)) {
      parent = n;
      is_left_child = true;
      n = n.left;
    } else if (k > tree_label(n)) {
      parent = n;
      is_left_child = false;
      n = n.right;
    } else {
      break;
    }
  }

  if (n) return [parent, is_left_child];
}

function tree_remove(r, k) {
  let n = tree_search(r, k);
  if (!n) return r;

  // leaf
  if (!n.left && !n.right) {
    let [parent, is_left_child] = tree_search_parent(r, k);
    if (!parent)
      return r;

    if (is_left_child)
      parent.left = null;
    else
      parent.right = null;
    return r;
  }

  // two child
  if (n.left && n.right) {
    let min = tree_min(n.right);

    tree_remove(n, tree_label(min));
    n.label = tree_label(min);

    return r;
  }

  // one child
  let [parent, is_left_child] = tree_search_parent(r, k);
  if (!parent) {
    return n.left || n.right;
  }

  if (is_left_child)
    parent.left = n.left || n.right;
  else
    parent.right = n.left || n.right;
  return r;
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

// https://www.geeksforgeeks.org/print-binary-tree-2-dimensions/?ref=gcse

function tree_height(r) {
  if (r === null) {
      return 0;
  }
  return Math.max(tree_height(r.left), tree_height(r.right)) + 1;
}

function get_col(h) {
  if (h === 1) {
      return 1;
  }
  return get_col(h - 1) + get_col(h - 1) + 1;
}

function print_tree_impl(M, r, col, row, height) {
  if (r === null) {
      return;
  }
  M[row][col] = tree_label(r);
  print_tree_impl(M, r.left, col - Math.pow(2, height - 2), row + 1, height - 1);
  print_tree_impl(M, r.right, col + Math.pow(2, height - 2), row + 1, height - 1);
}

function print_tree(r) {
  const h = tree_height(r);
  const col = get_col(h);
  const M = new Array(h).fill().map(() => new Array(col).fill(Infinity));
  print_tree_impl(M, r, Math.floor(col / 2), 0, h);

  for (let i = 0; i < M.length; i++) { let row="";
    for (let j = 0; j < M[i].length; j++) {
      if (M[i][j] === Infinity) {
        row = row +" ";
      } else {
        row= row +M[i][j] + " ";
      }
    }
    console.log(row);
  }
}

// -----------------------------------------------------------------
// Basic Operations on Binary Tree:

let root = tree_insert(null, 5);
root = tree_insert(root, 0);
root = tree_insert(root, 1);
root = tree_insert(root, 2);
root = tree_insert(root, 3);
root = tree_insert(root, 4);
root = tree_insert(root, 5);
root = tree_insert(root, 6);
root = tree_insert(root, 7);
root = tree_insert(root, 8);
root = tree_insert(root, 9);
console.log("二叉树1-10构建:");
print_tree(root);
console.log(`搜索7:${tree_search(root, 7)}; 搜索11:${tree_search(root, 11)}`);
console.log("删除4, 8, 5");
root = tree_remove(root, 4);
root = tree_remove(root, 8);
root = tree_remove(root, 5);
print_tree(root);

// https://www.geeksforgeeks.org/a-program-to-check-if-a-binary-tree-is-bst-or-not/
// https://www.geeksforgeeks.org/check-array-represents-inorder-binary-search-tree-not/
// 判断二叉树是否是BST

// 中序遍历的同时, 检查访问到的数列是否从小到大; 如果不是, 则不是BST; 不用搜索, O(N)

// ttps://www.geeksforgeeks.org/binary-tree-to-binary-search-tree-conversion/
// 树排序

function merge(arr1, arr2, out) {
  let i=0, j=0;
  out.splice(0, out.length);
  for (; i<arr1.length && j<arr2.length;) {
    if (arr1[i] < arr2[j]) {
      out.push(arr1[i++]);
    }
    else {
      out.push(arr2[j++]);
    }
  }

  for (; i<arr1.length; i++)
    out.push(arr1[i]);
  for (; j<arr2.length; j++)
    out.push(arr2[j]);
}

function merge_sort(array) {
  if (array.length <= 1) return;

  let m = Math.floor(array.length / 2);
  let left = array.slice(0, m);
  let right = array.slice(m);

  merge_sort(left);
  merge_sort(right);
  merge(left, right, array);
}

function quick_sort(array) {
  if (array.length <= 1)
    return;

  let pivot = array[Math.floor(array.length / 2)];
  let left = [], right = [];
  for (let v of array) {
    if (v < pivot)
      left.push(v);
    else if (v > pivot)
      right.push(v);
  }

  quick_sort(left);
  quick_sort(right);

  for (let i=0; i<left.length; i++)
    array[i] = left[i];
  array[left.length] = pivot;
  for (let i=0; i<right.length; i++)
    array[left.length + 1 + i] = right[i];
}

function tree_sort(r) {
  let result = [...visit_tree_inorder_recursilve(r)];
  //merge_sort(result);
  quick_sort(result);

  let s = stack_new();
  let n = r;
  let index = 0;
  while (n || !stack_empty(s)) {
    while (n) {
      stack_push(s, n);
      n = n.left;
    }

    n = stack_pop(s);
    n.label = result[index++];

    n = n.right;
  }
}

root = tree_new(3,
                tree_new(7,
                        tree_new(0)),
                tree_new(10,
                        tree_new(2),
                        tree_new(4)));
console.log("排序前的树:");
print_tree(root);
console.log("排序后的树:");
tree_sort(root);
print_tree(root);

// https://www.geeksforgeeks.org/how-to-determine-if-a-binary-tree-is-balanced/
// 判断是否为平衡二叉树; 可以适当优化递归算法, 使得时间复杂度为O(N)

// < 0 表示不平衡; 否则平衡, 而且返回值为树高
function is_banlanced_bst(r) {
  if (r == null) return 0;

  let lh = is_banlanced_bst(r.left);
  if (lh == -1)
    return -1;
    
  let rh = is_banlanced_bst(r.right);
  if (rh == -1)
    return -1;
    
  if (Math.abs(lh - rh) > 1)
    return -1;

  return Math.max(lh, rh) + 1;
}

root = tree_new('A',
                tree_new('B',
                         tree_new('D')
                        ),
                tree_new('C')
                );
result = is_banlanced_bst(root) !== -1;
console.log(`ABCD${result ? '是' : '不是'}平衡二叉树`);

root = tree_new('A',
                tree_new('B',
                         tree_new('D',
                                  tree_new('E'))
                        ),
                tree_new('C')
                );
result = is_banlanced_bst(root) !== -1;
console.log(`ABCDE${result ? '是' : '不是'}平衡二叉树`);