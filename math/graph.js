
// https://www.geeksforgeeks.org/introduction-to-graphs-data-structure-and-algorithm-tutorials/
// 图

// https://www.geeksforgeeks.org/graph-and-its-representations/
// 图的表示:
// 1. 邻接矩阵(adjacency matrix) 一般用于dense图
// 2. 邻接表(adjacency list) 常见的结构, 尤其适合稀疏图

// https://www.geeksforgeeks.org/difference-between-graph-and-tree/
// 图 vs 树

function node_new(v, ...adj) {
  return {
    label: v,
    adjacency: [...adj]
  }
}
function node_label(n) { return n.label; }
function node_adjacency(n) { return n.adjacency; }
function node_adjacency_reverse(n) { return Array.from(n.adjacency).reverse(); }
function graph_new(...nodes) {
  return Object.fromEntries(nodes.map(n => [node_label(n), n]));
}
function graph_node(g, k) { return g[k]; }

function stack_new() { return []; }
function stack_empty(s) { return s.length == 0; }
function stack_top(s) { return s[s.length - 1]; }
function stack_push(s, v) { s.push(v); }
function stack_pop(s) { return s.pop(); }
function stack_dump(s, visit) { return s.map(x => `T(${visit(x)})`); }

function queue_new() { return []; }
function queue_empty(q) { return q.length == 0; }
function queue_top(q) { return q[0]; }
function queue_enqueue(q, v) { q.push(v); }
function queue_dequeue(q) { return q.shift(); }

// https://www.geeksforgeeks.org/breadth-first-search-or-bfs-for-a-graph/
// 广度优先遍历
// 进队列前, 先查询; 进队列后要保存

function *visit_graph_breadth(g, k) {
  let visited = {};
  let n = graph_node(g, k);
  let q = queue_new();
  if (!n) return;

  queue_enqueue(q, n);
  visited[node_label(n)] = true;

  while (!queue_empty(q)) {
    n = queue_dequeue(q);
    yield node_label(n);

    for (let adj of node_adjacency(n)) {
      if (!visited[adj]) {
        visited[adj] = true;
        queue_enqueue(q, graph_node(g, adj));
      }
    }
  }
}

//                       1 ------- 3
//                    /  |         |
//                  /    |         |
//                0      |         |
//                  \    |         |
//                    \  |         |
//                       2---------4

let g = graph_new(node_new(0, 1, 2),
                  node_new(1, 0, 2, 3),
                  node_new(2, 0, 1, 4),
                  node_new(3, 1, 4),
                  node_new(4, 2, 3));
let result = [...visit_graph_breadth(g, 2)];
console.log(`广度优先遍历图:${result}`);

// https://www.geeksforgeeks.org/depth-first-search-or-dfs-for-a-graph/
// 深度优先递归遍历

// O(V+E)
function *visit_graph_depth_recursively(g, k, visit) {
  let n = graph_node(g, k);
  if (!n) return;

  visit = visit || {}
  visit[node_label(n)] = true;
  yield node_label(n);

  for (let adj of node_adjacency(n)) {
    if (!visit[adj]) {
      for (let k_adj of visit_graph_depth_recursively(g, adj, visit)) {
        yield k_adj;
      }
    }
  }
}


// https://www.geeksforgeeks.org/iterative-depth-first-traversal/
// 深度优先迭代遍历

// 进栈前先查询; 进栈后立即保存 O(V+E)
function *visit_graph_depth_iteratively(g, k) {
  let n = graph_node(g, k);
  if (!n) return;
  
  let s = stack_new();
  let visited = {};
  visited[k] = true;
  stack_push(s, n);

  while (!stack_empty(s)) {
    n = stack_pop(s);
    yield node_label(n);

    for (let adj of node_adjacency_reverse(n)) {
      if (!visited[adj]) {
        visited[adj] = true;
        stack_push(s, graph_node(g, adj));
      }
    }
  }
}

result = [...visit_graph_depth_recursively(g, 2)];
console.log(`深度优先递归遍历图:${result}`);
result = [...visit_graph_depth_iteratively(g, 2)];
console.log(`深度优先迭代遍历图:${result}`);

// https://www.geeksforgeeks.org/difference-between-bfs-and-dfs/
// DFS vs BFS

// https://www.geeksforgeeks.org/topological-sorting/
// 拓补排序

// TODO 递归算法反而不容易理解，需要反向查找precedent

function *visit_graph_topologically(g) {
  let indegrees = {}

  for (const [k, n] of Object.entries(g)) {
    indegrees[k] = indegrees[k] || 0; // 处理一开始就没有indgree的节点

    for (const adj of node_adjacency(n)) {
      indegrees[adj] = (indegrees[adj] || 0) + 1;
    }
  }
  
  let q = queue_new();
  for (const [k, indgree] of Object.entries(indegrees)) {
    if (indgree == 0) {
      queue_enqueue(q, k);
    }
  }
  
  let k, n
  while (!queue_empty(q)) {
    k = queue_dequeue(q);
    yield k;

    n = graph_node(g, k)
    for (let adj of node_adjacency(n)) {
      indegrees[adj]--;
      if (indegrees[adj] == 0) {
        queue_enqueue(q, adj);
      }
    }
  }
}

//              5          4
//             / \       /  \
//           /.    \.  /.    \.
//         2        0         1
//           \             /.
//             \         /
//               \.    /
//                  3

g = graph_new(node_new(0),
              node_new(1),
              node_new(2, 3),
              node_new(3, 1),
              node_new(4, 0, 1),
              node_new(5, 0, 2))
result = [...visit_graph_topologically(g)]
console.log(`拓补遍历图:${result}`);
