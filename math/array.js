
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
// https://ide.geeksforgeeks.org
