
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
