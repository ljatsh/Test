
JavaScript Specification
========================

1. [Destructuring Assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
2. [Hoisting](https://developer.mozilla.org/en-US/docs/Glossary/Hoisting)
    * Function hoisting only works with function declarations — not with function expressions. The code below will not work.

    ``` javascript
    console.log(square); // ReferenceError: Cannot access 'square' before initialization
    const square = function (n) {
      return n * n;
    };
    ```

3. [globalThis](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/globalThis)
4. [Iterators and Generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_generators)
5. [Spread Syntax(...)](http://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax)
6. Function(https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Functions)
    * [Creation]
        * [declaration](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function)
        * [expression](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/function)
        * [Function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/Function)
    * [Parameters]
        * [default](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Default_parameters)
        * [rest](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters)
    * [Closure](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures)
      * [LexicialEnvironment](https://amnsingh.medium.com/lexical-environment-the-hidden-part-to-understand-closures-71d60efac0e0)
      * [ExecutionContext](https://medium.com/dailyjs/javascript-basics-the-execution-context-and-the-lexical-environment-3505d4fe1be2)
    * [Arrow Function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)

Reference
=========

1. [Mocha](https://mochajs.org/)

TODO
====

1. chai undefined assertion -> cp5.js
2. iterator的return函数是怎么被调用的?
3. async iterator
4. symbol类型
