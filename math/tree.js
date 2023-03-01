
// TODO
// 1. 非递归的中序遍历; https://www.geeksforgeeks.org/inorder-tree-traversal-without-recursion/?ref=lbp的算法不容易处理3-arr树
// 2. 非递归的后序遍历
// 3. 查找离散数学中, 转换递归为非递归的通用算法

function tree_new(v, ...children) {
  return {
    label: v,
    children: [...children]
  };
}

function tree_label(r) {
  return r.label;
}

function tree_children(r) {
  return r.children;
}

function *tree_reverse_children(r) {
  for (let i=r.children.length-1; i>=0; i--) {
    yield r.children[i];
  }
}

function tree_left_child(r) {
  return r.children[0];
}

function *tree_children_except_left_child(r) {
  for (let i=1; i<r.children.length; i++) {
    yield r.children[i];
  }
}

function *tree_reverse_children_except_left_child(r) {
  for (let i=r.children.length-1; i>0; i--) {
    yield r.children[i];
  }
}

function tree_leaf(r) {
  return r.children.length == 0;
}

function *tree_pre_order_visit_recursively(r) {
  yield tree_label(r);

  for (children of tree_children(r)) {
    for (let v of tree_pre_order_visit_recursively(children)) {
      yield v;
    }
  }
}

function *tree_pre_order_visit(r) {
  let s = stack_new();
  let step = 0;

  let n = r;
  while (n) {
    step++;

    yield tree_label(n);

    for (let child of tree_reverse_children(n)) {
      stack_push(s, child);
    }

    console.log(`[${step}]: ${tree_label(n)}; ${dump_stack_tree(s)}`);

    n = stack_pop(s);
  }
}

function *tree_in_order_visit_recursively(r) {
  if (!r) return;

  for (v of tree_in_order_visit_recursively(tree_left_child(r))) {
    yield v;
  }

  yield tree_label(r);

  for (let child of tree_children_except_left_child(r)) {
    for (v of tree_in_order_visit_recursively(child)) {
      yield v;
    }
  }
}

function *tree_in_order_visit(r) {
  // TODO...
}

function *tree_post_order_visit_recursively(r) {
  for (child of tree_children(r)) {
    for (let v of tree_post_order_visit_recursively(child)) {
      yield v;
    }
  }

  yield tree_label(r);
}

function *tree_post_order_visit(r) {
  // let s = stack_new();
  // stack_push(s, r);
  // let touched = {};

  // let step = 0;
  // console.log(`[${step}]: ${dump_stack_tree(s)}`);

  // let v;
  // while (!stack_empty(s)) {
  //   step++;

  //   v = stack_top(s);
  //   let visit;
  //   if (tree_leaf(v) || touched[tree_label(v)]) {
  //     stack_pop(s);
  //     visit = tree_label(v);
  //     yield visit;
  //   }
  //   else {
  //     for (let child of tree_reverse_children(v)) {
  //       stack_push(s, child);
  //     }
  //     touched[tree_label(v)] = true;

  //     visit = '-';
  //   }

  //   console.log(`[${step}]: ${visit}; ${dump_stack_tree(s)}`);
  // }

  // TODO
}

function *tree_level_visit(r) {
  let q = queue_new();
  let n = r;
  let step = 0;
  while (n) {
    step++;

    yield tree_label(n);

    for (let child of tree_children(n)) {
      queue_push(q, child);
    }

    console.log(`[${step}]: ${tree_label(n)}; ${dump_queue_tree(q)}`);

    n = queue_pop(q);
  }
}

function stack_new() {
  return [];
}

function stack_empty(s) {
  return s.length == 0;
}

function stack_push(s, v) {
  s.push(v);
}

function stack_top(s) {
  return s[s.length - 1];
}

function stack_pop(s) {
  return s.pop();
}

function dump_stack_tree(s) {
  let s1 = Array.from(s);
  return s1.reverse()
           .map(n => `T(${tree_label(n)})`)
          .join(', ');
}

function queue_new() {
  return [];
}

function queue_empty(s) {
  return s.length == 0;
}

function queue_push(s, v) {
  s.push(v);
}

function queue_top(s) {
  return s[0];
}

function queue_pop(s) {
  return s.shift();
}

function dump_queue_tree(s) {
  return s.map(n => `T(${tree_label(n)})`)
          .join(', ');
}

// 参考离散数学
t = tree_new('a',
             tree_new('b',
                      tree_new('e', tree_new('j'),
                                    tree_new('k',
                                             tree_new('n'),
                                             tree_new('o'),
                                             tree_new('p'))),
                      tree_new('f')),
             tree_new('c'),
             tree_new('d',
                      tree_new('g',
                               tree_new('l'),
                               tree_new('m')),
                      tree_new('h'),
                      tree_new('i')));

let v = [...tree_pre_order_visit_recursively(t)];
console.log(`递归前序遍历: ${v.join(', ')}`);
v = [...tree_pre_order_visit(t)];
console.log(`循环前序遍历: ${v.join(', ')}\n`);

v = [...tree_in_order_visit_recursively(t)];
console.log(`递归中序遍历: ${v.join(', ')}`);
// v = [...tree_in_order_visit(t)];
// console.log(`循环中序遍历: ${v.join(', ')}\n`);

v = [...tree_post_order_visit_recursively(t)];
console.log(`递归后序遍历: ${v.join(', ')}\n`);

v = [...tree_level_visit(t)];
console.log(`层级遍历: ${v.join(', ')}`);
