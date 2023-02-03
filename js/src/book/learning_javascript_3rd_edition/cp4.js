// Learning JavaScript, 3rd Edition.
// Chapter 4. Control Flow

const { assert } = require('chai');
var chai = require('chai');
var expect = chai.expect;

describe('Control Flow', function() {
  let makeRankIterator;
  let rankGenerator;

  before(function() {
    makeRankIterator = function(start = 0, end = Infinity, step = 1) {
      let index = start;
      let iterates = 0;
      let next = function() {
        if (index < end) {
          let value = index;
          index += step;
          iterates++;
          return {value: value, done: false};
        }

        return {value: iterates, done: true};
      };

      let ret = function(value) {
        console.log(`return called ${value}`);
        index = start;
        iterates = 0;
        return {value: value, done: true};
      };

      return {
        next: next,
        return: ret,
        [Symbol.iterator]() {
          return this;
        }
      };
    };

    rankGenerator = function* (start = 0, end = Infinity, step = 1) {
      let iterates = 0;
      for (let index = start; index < end; index += step) {
        iterates++;
        yield index;
      }

      return iterates;
    };
  });

  // 迭代器是有枚举行为的对象, 有next函数, 可选return函数和throw函数
  it('Iterator', function() {
    let out = [];
    let iterator = makeRankIterator(1, 10, 2);
    let result = iterator.next();
    while (!result.done) {
      out.push(result.value);
      result = iterator.next();
    }
    expect(out).be.deep.equal([1, 3, 5, 7, 9]);

    // cleanup
    iterator.return();
    out.splice(0, out.length);

    result = iterator.next();
    while (!result.done) {
      out.push(result.value);
      result = iterator.next();
    }
    expect(out).be.deep.equal([1, 3, 5, 7, 9]);
  });

  // Generator函数, 返回一个只迭代1次的迭代器; 语法较迭代器简单许多
  it('Generator', function(){
    let out = [];
    let iterator = rankGenerator(1, 10, 2);
    // TODO expect sytle
    assert.isFunction(iterator.next, 'next method');
    assert.isFunction(iterator[Symbol.iterator], '@@iterator method');
    expect(iterator[Symbol.iterator]()).to.be.equal(iterator, '@@iterator return the iterator itself');

    let result = iterator.next();
    while (!result.done) {
      out.push(result.value);
      result = iterator.next();
    }
    expect(out).be.deep.equal([1, 3, 5, 7, 9]);
  });

  // for ... of
  it('Iterable', function() {
    let out = [];
    let iterator = makeRankIterator(1, 10, 2);
    for (let value of iterator) {
      out.push(value);
    }
    expect(out).be.deep.equal([1, 3, 5, 7, 9]);
  });
});
