
function stack_new() { return []; }
function stack_empty(s) { return s.length == 0; }
function stack_top(s) { return s[s.length - 1]; }
function stack_push(s, v) { s.push(v); }
function stack_pop(s) { return s.pop(); }

function is_prime(n) {
  let max = Math.floor(Math.sqrt(n));
  let array = new Array(max);
  for (let i=0; i<max; i++) {
    array[i] = {n: i+1, p: true};
  }

  let v1, v2;
  for (let i=1; i<max; i++) {
    v1 = array[i];
    // 只判断质数
    if (!v1.p) continue;

    if ((n % v1.n) == 0) return false;

    // 剔除这个质数的倍数
    for (let j=i+v1.n; j<max; j+=v1.n) {
      v2 = array[i];
      v2.p = false;
    }
  }

  return true;
}

// https://www.calculatorsoup.com/calculators/math/prime-number-calculator.php
// https://www.calculatorsoup.com/calculators/math/prime-numbers.php
for (let i=4139; i<=4229; i++) {
  if (is_prime(i)) {
    console.log(`数字${i}是质数`);
  }
}

// 寻找n以内的所有质数
function prime_n(n) {
  let array = new Array(n);
  for (let i=0; i<n; i++) {
    array[i] = {n: i+1, p:true};
  }
  array[0].p = false;

  let v1, v2;
  for (let i=1; i<n; i++) {
    v1 = array[i];

    // 剔除质数的倍数
    if (v1.p) {
      for (let j=i+v1.n; j<n; j+=v1.n) {
        v2 = array[j];
        v2.p = false;
      }
    }
  }

  return array.filter(x => x.p).map(x => x.n);
}

// https://www.calculatorsoup.com/calculators/math/prime-numbers.php
let numbers = prime_n(8012);
let from = 0, to = 9;
while (from < numbers.length) {
  console.log(numbers.slice(from, to).join(' '));
  from = to;
  to += 10;
}

function *prime_factorization(n) {
  let max = Math.floor(Math.sqrt(n));
  let array = new Array(max);
  for (let i=0; i<max; i++) {
    array[i] = {n: i+1, p: true}
  }

  let v1, v2;
  let d = n;
  let facorized = false;
  for (let i=1; i<max; i++) {
    v1 = array[i];

    // 只检查质数
    if (!v1.p) continue;

    // 如果分解顺利, 跳出
    if (v1.n > d) break;

    while ((d % v1.n) == 0) {
      facorized = true;
      yield v1.n;

      d = d / v1.n;
    }

    // 剔除质数的倍数
    for (let j=i+v1.n; j<max; j+=v1.n) {
      v2 = array[j];
      v2.p = false;
    }
  }
  
  if (!facorized) yield n;
}

// https://www.calculatorsoup.com/calculators/math/prime-factors.php
for (let v of [1, 2, 8009, 8112, 1000]) {
  numbers = [...prime_factorization(v)].join(', ');
  console.log(`${v}的质因数分解:[${numbers}]`);
}

// https://www.geeksforgeeks.org/program-to-find-gcd-or-hcf-of-two-numbers/
// 最大公因数 Greatest Common Divisor
// a > b => a = b * x + y => a - b*x = y
// b、y的任意公因数是a的公因数; a、b的任意公因数，是y的因数; 因此gcd(a, b) = gcd(b, y)

function gcd_recursive(a, b) {
  let l = Math.max(a, b), s = Math.min(a, b);
  let r = l % s;

  if (r == 0) return s;

  return gcd_recursive(s, r);
}

function gcd(a, b) {
  let l = Math.max(a, b), s = Math.min(a, b);
  let r = l % s;
  
  while (r > 0) {
    l = s;
    s = r;
    r = l % s;
  };

  return s;
}

console.log(`gcd_recursive(98, 56)=${gcd_recursive(98, 56)}`);
console.log(`gcd(98, 56)=${gcd(98, 56)}`);

// 给一个十进制整数, 计算base的扩展
let char = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
function expansion(n, base=10) {
  let q = n, r;

  let s = stack_new();
  do {
    r = q % base;
    q = (q - r) / base;
    stack_push(s, char[r]);
  } while (q > 0);

  let ret = [];
  while (!stack_empty(s))
    ret.push(stack_pop(s));
  return ret.join('');
}

for (let v of [1000, 1234]) {
  console.log(`${v}: 10进制${expansion(v)}; 2进制${expansion(v, 2)}; 8进制${expansion(v, 8)}; 16进制${expansion(v, 16)}`);
}