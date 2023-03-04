
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
  let p, p_top;
  let top;
  for (let c of expr) {
    p = priority(c, true);
    if (p == -1) {
      out.push(c);
    } else {
      if (c == ')') {
        while (!stack_empty(s)) {
          top = stack_pop(s);
          if (top == '(') {
            break;
          }

          out.push(top);
        }
      }
      else {
        while (!stack_empty(s) && ((p_top = priority(stack_top(s), false)) >= p)) {
          out.push(stack_pop(s));
        }
        stack_push(s, c);
      }
    }
  }
  while (!stack_empty(s)) {
    out.push(stack_pop(s));
  }

  return out;
}

for (let expr of ['A + B * C + D', '(A + B) * (C + D)', '((A + B) - C * (D / E)) + F']) {
  let expr2 = expr.replace(/\s/g, '').split('');
  console.log(`${expr}转换为postExpression: ${infix_postfix(expr2).join('')}`);
}

// https://www.geeksforgeeks.org/arithmetic-expression-evalution/
// 后缀表达式计算

function postfix_expr_eval(expr) {
  let s = stack_new();
  let postfix = infix_postfix(expr);
  let left, right;
  for (let v of postfix) {
    if (priority(v) == -1) {
      stack_push(s, v);
    }
    else {
      right = Number.parseFloat(stack_pop(s));
      left = Number.parseFloat(stack_pop(s));

      if (v == '+') {
        stack_push(s, left + right);
      } else if (v == '-') {
        stack_push(s, left - right);
      } else if (v == '*') {
        stack_push(s, left * right);
      } else if (v == '/') {
        stack_push(s, left / right);
      }
    }
  }

  return stack_pop(s);
}

for (let expr of ['(2 + 4) * (4 + 6)', '2 + (3 * 1) - 9']) {
  let expr2 = expr.replace(/\s/g, '').split('');
  console.log(`${expr}计算结果: ${postfix_expr_eval(expr2)}`);
}

// https://www.geeksforgeeks.org/reverse-individual-words/
// 给定字符串, 按照单词翻转

function reverse_word(str) {
  let out = [];
  let s = stack_new();
  for (let c of str) {
    if (c == ' ' || c == '\t') {
      while (!stack_empty(s))
        out.push(stack_pop(s));
      out.push(c);
    }
    else {
      stack_push(s, c);
    }
  }
  
  while (!stack_empty(s))
    out.push(stack_pop(s));
    
  return out.join('');
}

for (let str of ['Hello World', 'Geeks for Geeks']) {
  console.log(`按照单词翻转'${str}': '${reverse_word(str)}'\n`);
}

// https://www.geeksforgeeks.org/iterative-tower-of-hanoi/
// 汉诺塔游戏

function move_recursively(count, from, to, other) {
  if (count == 0) {
    return;
  }
  
  move_recursively(count - 1, from, other, to);
  console.log(`(${count} ${from} -> ${to});`);
  move_recursively(count - 1, other, to, from);
}

console.log("递归汉诺塔:");
move_recursively(3, 'S', 'D', 'A');

// https://www.geeksforgeeks.org/iterative-tower-of-hanoi/
// TODO 总的移动次数2^n - 1, 如果解f(n) = 2f(n-1) + 1的方程; 怎么理解这个迭代算法？
