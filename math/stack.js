
// https://www.geeksforgeeks.org/stack-data-structure/?ref=lbp

// 栈只能在栈顶操作；本质上提供先接触后访问的有序过程

function stack_new() { return []; }
function stack_empty(s) { return s.length == 0; }
function stack_top(s) { return s[s.length - 1]; }
function stack_push(s, v) { s.push(v); }
function stack_pop(s) { return s.pop(); }

// https://www.geeksforgeeks.org/convert-infix-expression-to-postfix-expression/
// infix表达值转为postfix表达式
// postfix表达式, 操作数维持了原始顺序
function priority(c, push) {
  if (c == '(') {
    // 入栈优先级最高, 出栈优先级最低
    if (push) return 100;
    return 0;
  };

  if (c == '*' || c == '/') {
    return 2;
  }

  if (c == '+' || c == '-') {
    return 1;
  }

  if (c == ')') return 0;

  return -1; // 操作数
}

function infix_postfix(expr) {
  let out = [];
  let s = stack_new();
  let p_in, p_out;
  let top;
  for (let c of expr) {
    p_in = priority(c, true);
    if (p_in == -1) {
      out.push(c);
    } else {
      while (!stack_empty(s) && ((p_out = priority(stack_top(s), false)) >= p_in)) {
        top = stack_pop(s);
        if (p_out > 0)
          out.push(top);
      }
      if (p_in > 0)
        stack_push(s, c);
    }
  }
  while (!stack_empty(s)) {
    out.push(stack_pop(s));
  }
  
  return out;
}

let expr = 'A + B * C + D';
let expr2 = expr.replace(/\s/g, '').split('');
console.log(`${expr}转换为postExpression: ${infix_postfix(expr2).join('')}`);
expr = '(A + B) * (C + D)';
expr2 = expr.replace(/\s/g, '').split('');
console.log(`${expr}转换为postExpression: ${infix_postfix(expr2).join('')}`);
expr = '((A + B) / (E - F)) * (C + D)';
expr2 = expr.replace(/\s/g, '').split('');
console.log(`${expr}转换为postExpression: ${infix_postfix(expr2).join('')}`);
