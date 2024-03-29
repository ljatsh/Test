
// Learning JavaScript, 3rd Edition.
// Chapter 6, Functions

const { assert } = require('chai');
var expect = require('chai').expect;

// 1. Primptive values are passed as value, and Object value are passed as reference
// 2. Parameter destructuring can be mixed with normal parameters
// 3. Prefer ... operator in ES6 than arguments variable
// 4. This is a readonly variable bound to the caller. This also bounds to something(a global object in non-strict mode, while undefined in strict mode) even in a normal function.
// 5. Closure has its own this variable different from this of its parent
// 6. Array Notation binds this to the this of its caller
// 7. Spread operator ... can be used in call
// 8. function is a kind of object and contains prototype property. Function can be called as constructor, and this was bind to the new created object.
describe('Functions', function() {
  // function is a Function Object which is callable
  it('Function Object', function() {
    let f = (x) => x * 2;
    expect(typeof f).to.be.equal('function');
    let proto = f;
    assert.isFunction(proto.apply);
    expect(f.call(undefined, 2)).to.be.equal(4);
    expect(f.name).to.be.equal('f');
  });

  // function declaration
  // function expression
  // function creation; prefer eval to Function
  it('function create', function() {
    function f1(name) { return name; }
    let f2 = function f(name) { return name; }; // name f can be invoked recursivley
    let f3 = new Function('name', 'return name;');

    expect(f1('lj@sh')).to.be.equal('lj@sh');
    expect(f2('lj@sh')).to.be.equal('lj@sh');
    expect(f3('lj@sh')).to.be.equal('lj@sh');
  });

  // prefer to position default parameters at the right
  it('parameters - default', function() {
    function f(a = 1, b) {
      return [a, b];
    }

    expect(f()).be.deep.equal([1, undefined]);
    expect(f(2)).be.deep.equal([2, undefined]);
    expect(f.length).to.be.equal(0);
  });

  // prefer to use rest parameter instead of argument
  it('parameters - rest', function() {
    function multiply(multiplier, ...args) {
      return [args.map((x) => x * multiplier), Object.getPrototypeOf(args)];
    }

    function multiply2(multiplier) {
      let o = [];
      for (let i=1; i<arguments.length; i++) {
        o.push(arguments[i] * multiplier);
      }

      return o;
    }

    let [results, proto] = multiply(2, 1, 2, 3);
    expect(results).be.deep.equal([2, 4, 6]);
    expect(proto).to.be.equal(Object.getPrototypeOf([]));

    let results2 = multiply2(2, 1, 2, 3);
    expect(results2).be.deep.equal([2, 4, 6]);
  });

  it('parameters - Value and Reference passing', function() {
    var a = 1, b = 2, obj = {age : 10};

    function test(a, b, obj) {
      a += 1;
      b += 1;
      obj.age += 1;

      return [a, b, obj];
    }

    var [c, d, e] = test(a, b, obj);
    assert.equal(a, 1);
    assert.equal(b, 2);
    assert.equal(c, 2);
    assert.equal(d, 3);
    assert.equal(obj, e);
    assert.equal(obj.age, 11);
  });

  it('parameters - Parameter Destructuring', function() {
    function test1({a, b, c}) {
      return `${a}_${b}_${c}`;
    }

    function test2([a, b, c]) {
      return `${a}_${b}_${c}`;
    }

    function test3(x, {a, b, c}, [y, z]) {
      return `${x}_${a}_${b}_${c}_${y}_${z}`;
    }

    assert.equal(test1({a:1, b:3, c:2, d:'ljatsh'}), '1_3_2');
    assert.equal(test2([1, 3, 2, 4]), '1_3_2');
    assert.equal(test3(10, {a:1, b:3, c:2}, [1, 3, 2, 4]), '10_1_3_2_1_3');
  });

  // the key point to understand closure is the execution context
  // Execution context in ES5
  // ExecutionContext = {
  //   ThisBinding: <this value>,
  //   VariableEnvironment: { ... },
  //   LexicalEnvironment: { ... }
  // }
  it('closure', function() {
    function adder(age) {
      return function(v) {
        return age + v;
      }
    }

    let f = adder(10);
    expect(f(5)).to.be.equal(15);
  });

  // An arrow function does not have its own this; the this value of the enclosing execution context is used.
  it('Arrow Notation', function() {
    function test() {
      var f = ()=> this;
      return f();
    }
    var obj = {test : test};

    var f1 = () => 1;
    var f2 = x => x * 2;

    assert.equal(f1(), 1);
    assert.equal(f2(2), 4);
    assert.equal(obj.test(), obj);
  });

  it('Constructor', function() {
    function Test(out) {
      out.push(this);
    }

    var array = [];
    var obj = new Test(array);
    assert.equal(array[0], obj);
    assert.equal(Object.getPrototypeOf(obj), Test.prototype, 'Function is actually object and contains prototype object');

    var obj2 = {method:Test};
    array.splice(0);
    obj = new obj2.method(array);
    assert.equal(array[0], obj);
    assert.ok(obj !== obj2, 'this binds to the new created object event if constructor was called as method');
  });
});
