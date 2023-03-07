
// https://www.geeksforgeeks.org/geometric-algorithms/
// 常见的几何问题
// TODO These algorithms are designed to solve Geometric Problems. They require in-depth knowledge of different mathematical subjects like combinatorics, topology, algebra, differential geometry, etc.

function point_new(x, y) {
  return {x: x || 0, y: y || 0}
}

// https://www.geeksforgeeks.org/geometric-algorithms/
// https://docs.unity3d.com/ScriptReference/Vector3.Lerp.html
// 两点(p1, p2)之间的线上的点坐标 p1 + t(p2 - p1)

function lerp(a, b, t) {
  return point_new(a.x + t * (b.x - a.x), a.y + t * (b.y - a.y));
}

// https://www.geeksforgeeks.org/program-find-slope-line/
// 斜率计算
function slop(a, b) {
  if (b.x - a.x === 0 ) {
    return Number.MAX_VALUE;
  }
  
  return (b.y - a.y) / (b.x - a.x);
}

// https://www.geeksforgeeks.org/program-find-line-passing-2-points/
// 根据给定的两点, 得到直线的方程
// 直线方程为ax + by = c
// 已知 1) ax^2 + by^2 = c
//      2) ax^1 + by^1 = c
// 得到 a(x^2 - x^1) + b(y^2 - y^1) = 0
// 令a = y^2 - y^1, 则b = -(x^2 - x^1), c = ax^2 + by^2

// https://www.geeksforgeeks.org/program-for-point-of-intersection-of-two-lines/
// 给定两个线段或者直线, 求交点
// 1. 先得到两条直线的方程
// 2. 求二元二次方程(TODO 用Matrix来解)
// 3. 如果determinant为0, 表示直线平行;
// 4. 如果是线段, 要分别判定点是否在线段范围内:
//    min(x^1, x^2) <= x <= max(x^1, x^2)
//    min(y^1, y^2) <= y <= max(y^1, y^2)

// https://www.geeksforgeeks.org/given-a-set-of-line-segments-find-if-any-two-segments-intersect/
// https://eecs.wsu.edu/~cook/aa/lectures/l25/node10.html
// 给N个线段, 搜索是否有线段相交
// 扫描线算法:
// 1. 2N个点按照x轴从小到大排列
// 2. 想象一个垂直的扫描线从左往右扫描
// 3. 线段左侧点碰到扫描线, 进入一个检测区(按照线段左侧点的Y轴排列); 检查新进线段的邻居是否相交
// 4. 线段右侧检点碰到扫描线, 删除这个线段, 检测新生成的邻居是否相交
// 5. 算法核心是:
//    * 如果线段相交, 扫描过程中它们必然是邻居; 否则没有必要检测
//    * 线段成为邻居有3、4两个机会
// 6. 可能有重复检测
// 时间复杂度

// http://courses.csail.mit.edu/6.006/spring11/lectures/lec24.pdf
// 给N个点, 搜索最近的两个点的距离
// 分而治之, 递归
// 1. N个点按照x坐标排序
// 2. 从中间分为2个集合, 中间相邻两个点的中间, 想象插入了垂直线
// 3. 递归计算左侧集合和右侧集合的最小两点距离
// 4. 计算左侧点到右侧点的两点最小距离。取三个当中的最小值就好
// 5. 第4步计算, 假设第3步的最小值为w; 则只需考虑以垂直分割线为中心, 宽度为2w的这么一个分隔带; 只计算分割带中左右点的最小距离就好
// 6. 第5步还能进一步提升效率: 进入分割带的点, 按照y坐标排序, 只计算y坐标距离<w的点

