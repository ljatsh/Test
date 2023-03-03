
// https://www.geeksforgeeks.org/array-data-structure/

// 数组是连续的布局, O(1)按照索引、地址访问

// ---------------------------------
// Basic Operations

// https://www.geeksforgeeks.org/searching-algorithms//
// 数组的查找, 一个线性
function linear_search(array, v) {
  for (let i=0; i<array.length-1; i++) {
    if (array[i] == v) {
      return i;
    }
  }

  return -1;
}

function binary_search_recursive(array, v, from, to) {
  let m = from + Math.floor((to - from) / 2);
  if (m < from) {
    return -1;
  }

  if (v < array[m]) {
    return binary_search_recursive(array, v, from, m - 1);
  }
  else if (v > array[m]) {
    return binary_search_recursive(array, v, m + 1, to);
  }
  else {
    return m;
  }
}

function binary_search_iterative(array, v) {
  let from = 0;
  let to = array.length - 1;
  let m;
  while (from <= to) {
    m = from + Math.floor((to - from) / 2);

    if (v < array[m]) {
      to = m - 1;
    }
    else if (v > array[m]) {
      from = m + 1;
    }
    else {
      return m;
    }
  }

  return - 1;
}

let array = [1, 4, 7, 10, 30, 40];
console.log(`linear locate 30 at ${array}: ${linear_search(array, 30)}`);
array = [1, 3, 4, 9, 10, 20, 50, 51, 60];
console.log(`binary locate 3 recursively at ${array}: ${binary_search_recursive(array, 3, 0, array.length)}`);
console.log(`binary locate 3 iteratively at ${array}: ${binary_search_iterative(array, 3, 0, array.length)}`);

// https://www.geeksforgeeks.org/write-a-program-to-reverse-an-array-or-string/
// 反转数组
function reverse(array) {
  let from = 0;
  let to = array.length - 1;
  let v;
  while (from < to) {
    v = array[to];
    array[to] = array[from];
    array[from] = v;

    from++;
    to--;
  }

  return array;
}

array = 'Hello, Longjun!';
console.log(`翻转"${array}": ${reverse(array.split('')).join('')}`);

// https://www.geeksforgeeks.org/array-rotation/
// 左侧旋转

// 精巧思路
function rotate_left(array, d) {
  let v;
  for (let t=1; t<=d; t++) {
    v = array[0];
    for (let i=1; i<array.length; i++) {
      array[i-1] = array[i];
    }
    array[array.length - 1] = v;
  }

  return array;
}

array = [1, 2, 3, 4, 5, 6, 7];
console.log(`左旋转[${array}]2次:[${rotate_left(array, 2)}]`);

// TODO 还有其他的算法

// https://www.geeksforgeeks.org/search-insert-and-delete-in-a-sorted-array/
// 插入到有序数组

function insert_sorted_linear(array, element) {
  let index = array.length; // 默认插到最后
  for (let i=0; i<array.length; i++) {
    if (element == array[i]) {
      index = -1;
      break;
    }

    if (element < array[i]) {
      index = i;
      break;
    }
  }

  if (index == -1) { return index; }
  
  for (i=array.length-1; i>=index; i--) {
    array[i+1] = array[i];
  }
  array[index] = element;
  return index;
}

function insert_sorted_binary(array, element) {
  let left = 0, right = array.length - 1;
  let m;
  let index = 0;
  while (left <= right) {
    m = left + Math.floor((right - left) / 2);
    if (element < array[m]) {
      if (m == 0 || element > array[m - 1]) {
        index = m;
        break;
      }

      right = m - 1;
    }
    else if (element > array[m]) {
      if (m == (array.length - 1) || element < array[m + 1]) {
        index = m + 1;
        break;
      }

      left = m + 1;
    }
    else {
      index = -1;
      break;
    }
  }

  if (index == -1) { return index; }

  for (let i=array.length-1; i>=index; i--) {
    array[i + 1] = array[i];
  }
  array[index] = element;
  return index;
}

let index_array_1 = [];
let index_array_2 = [];
let random;
for (let i=0; i<30; i++) {
  random = Math.floor(Math.random() * 100);
  insert_sorted_linear(index_array_1, random);
  insert_sorted_binary(index_array_2, random);
}
console.log(`线性有序随机插入30个数字到[]:[${index_array_1}]`);
console.log(`折半有序随机插入30个数字到[]:[${index_array_2}]`);

// TODO 标准答案虽然精巧, 可是没有考虑重复; 比较的次数也不理想

// https://www.geeksforgeeks.org/sorting-algorithms/
// TODO 用专门的章节来复习排序

// https://www.geeksforgeeks.org/generating-subarrays-using-recursion/
// 生成所有子数组

// 组合递归的逻辑有逻辑判断, 明显不好 TODO
// function *generate_sub_arrays_recursively(array, from, to) {
//   if (from > to) {
//     yield;
//     return;
//   }
 
//   if (from === to) {
//     yield {value: Array.of(array[from]), from: from, to: to};
//     return;
//   }

//   yield {value: Array.of(array[from]), from: from, to: from};
//   for (let v of generate_sub_arrays_recursively(array, from + 1, to)) {
//     yield v;
//     // 不能跨索引合并
//     if (v.from == from + 1) {
//       yield {value: Array.of(array[from]).concat(v.value), from: from, to: v.to};
//     }
//   }
// }

function *generate_sub_arrays_iteratively(array) {
  for (let from=0; from<array.length; from++) {
    for (let to=from; to<array.length; to++) {
      yield array.slice(from, to+1);
    }
  }
}

for (let array of [[1, 2], [1, 2, 3], [1, 2, 3, 4]]) {
  console.log(`迭代生成[${array}]的所有子数组:`);
  for (let sub_array of generate_sub_arrays_iteratively(array)) {
    console.log(sub_array);
  }
}

// ---------------------------------
// Standard problem on Array

// https://www.geeksforgeeks.org/find-the-largest-three-elements-in-an-array/
// 搜寻k个最大的值, 和第k个最大值

// O(N * (k-1)); 如果k变大, 先排序, 再取值, O(N * logN)
function search_largest_three(array, k) {
  let largest = new Array(k);
  largest.fill(-Infinity);
  let swap;
  for (let v of array) {
    if (v > largest[0]) {
      largest[0] = v;

      // bubble to the top
      for (let i=1; i<largest.length; i++) {
        if (largest[i - 1] > largest[i]) {
          swap = largest[i - 1];
          largest[i - 1] = largest[i];
          largest[i] = swap;
        }
      }
    }
  }
  
  return largest;
}

array = [];
for (let i=1; i<=100; i++) {
  array.push(i);
}
array.sort(()=> Math.random() - 0.5);
console.log(`在100个随机数中找最大3个值: [${search_largest_three(array, 3)}]`);

// TODO 用heap等结构

// https://www.geeksforgeeks.org/move-zeroes-end-array/
// 所有0移动到末尾

// O(N)
function move_zeroes_to_end(array) {
  let offset = 0;
  for (let i=0; i<array.length; i++) {
    if (array[i] == 0) {
      offset++;
    }
    else if (array[i] != 0 && offset > 0) {
      array[i-offset] = array[i];
      array[i] = 0;
    }
  }
}

for (let array of [[1, 2, 0, 4, 3, 0, 5, 0], [1, 2, 0, 0, 0, 3, 6]]) {
  let array2 = Array.from(array);
  move_zeroes_to_end(array2);
  console.log(`移动[${array}]所有的0到末尾:[${array2}]`);
}

// https://ide.geeksforgeeks.org
