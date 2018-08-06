

// Learning JavaScript, 3rd Edition.
// Chapter 3. Literals and Variables

var chai = require('chai');
var expect = chai.expect;

describe('Primitive types and Objects', function () {
  // 1. Number.isNaN is different from global isNan. Number.isNaN determines whether the passed value is NaN and its type is Number. While global isNaN converts the passed value to Number.
  // 2. Both equality operators, == and ===, evaluating to false when checking NaN is Nan. This is why Number.isNaN() becomes necessary.
  describe('Number', function () {
    it('NaN', function () {
      expect(Number.isNan, 'global isNan is different from Number.isNaN').to.be.not.equal(isNaN);

      // 'NaN', undefined, {}, 'blabla' should be true with global isNaN
      expect(Number.isNaN('NaN')).to.be.false;        // jshint ignore: line
      expect(Number.isNaN(undefined)).to.be.false;    // jshint ignore: line
      expect(Number.isNaN({})).to.be.false;           // jshint ignore: line
      expect(Number.isNaN('blabla')).to.be.false;     // jshint ignore: line

      expect(isNaN('NaN')).to.be.true;                // jshint ignore: line
      expect(isNaN(undefined)).to.be.true;            // jshint ignore: line
      expect(isNaN({})).to.be.true;                   // jshint ignore: line
      expect(isNaN('blabla')).to.be.true;             // jshint ignore: line

      expect(NaN == NaN, 'Nan == Nan is false').to.be.false;        // jshint ignore: line
      expect(NaN, 'Nan === Nan is false').to.be.not.equal(NaN);     // jshint ignore: line

      expect(Number.isNaN(NaN)).to.be.true;                         // jshint ignore: line
      expect(Number.isNaN(Number.NaN)).to.be.true;                  // jshint ignore: line
      expect(Number.isNaN(0 / 0)).to.be.true;                       // jshint ignore: line
    });

    it('Infinity', function () {
      expect(Number.isFinite(1 / 0)).to.be.false;     // jshint ignore: line
    });

    it('Convered from string', function () {
      expect(Number.parseInt('5.6'), 'numbers after dot are omitted').to.be.equal(5);
      expect(Number.parseInt(' 5 '), 'leading spaces are ignored').to.be.equal(5);
      expect(Number.parseInt('ab', 16), 'hexdecimal parsing').to.be.equal(0xab);
      expect(Number.parseInt('ab')).to.be.NaN;        // jshint ignore: line
      expect(Number.parseInt, 'global parseInt is alias of Number.parseInt').to.be.equal(parseInt);

      expect(Number.parseFloat('1.5')).to.be.equal(1.5);
      expect(Number.parseFloat('1.5a'), 'first non digit character and remain ones are omitted').to.be.equal(1.5);
      expect(Number.parseFloat, 'global parseFloat is alias of Number.parseFloat').to.be.equal(parseFloat);
    });

    it('Converts to string', function () {
      expect((16.7).toString(), 'default radix is 10').to.be.equal('16.7');
      expect((16).toString(16), 'hexdecimal format').to.be.equal('10');
      expect((-16).toString(2), 'binary format').to.be.equal('-10000');
    });

    it('The valueOf', function () {
      var numObj = new Number(11); // jshint ignore: line
      var num = numObj.valueOf();
      expect(num).to.be.equal(11);
      // expect(numObj).to.be.an('number');
      // expect(num).to.be.a('number');
      // TODO typeof(numObj) == 'object'; typeof constructor and https://github.com/chaijs/type-detect
    });
  });

  // 1. undefined, null, NaN, 0, '', false is falsy. Anything else is truthy
  describe('Boolean', function () {
    it('The falsy and truthy', function () {
      var falsy_vars = [undefined, null, NaN, 0, '', false];

      falsy_vars.forEach(function(value) {
        expect(value).to.be.not.ok;           // jshint ignore: line
      });

      expect(new Boolean(false), 'any object is truthy, including objects whose valueOf returns false').to.be.ok; // jshint ignore: line
      expect([], 'array is truthy, event it is empty').to.be.ok;       // jshint ignore: line
      expect(' ', 'non empty string is truthy').to.be.ok;              // jshint ignore: line
      expect('false').to.be.ok;                                        // jshint ignore: line
    });
  });

  // 1. searchValue in lastIndexOf has special meaning
  describe('String', function () {
    it('Normal Operations', function () {
      var s = 'Hello, JavaScript!';
      expect(s.charAt(4), 'index begins from 0').to.be.equal('o');
      expect(s.charAt(100), 'empty string is returned if index is invalid').to.be.empty;     // jshint ignore: line
      expect(s.indexOf('o,')).to.be.equal(4);
      expect(s.indexOf('ss')).to.be.equal(-1);
      expect(s.lastIndexOf('a')).to.be.equal(10);
      expect(s.lastIndexOf('', 3), 'if searchValue is empty string, the fromIndex is returned').to.be.equal(3);
    });

    it('Split and Join', function () {
      // TODO RegExp
    });

    it('Slice', function () {
      var s = 'Hello, JavaScript!';
      expect(s.substr(2, 3)).to.be.equal('llo');
      expect(s.substr(-5), 'negative index starts counting from the end of the string').to.be.equal('ript!');
      expect(s.substring(2, 5), 'indexEnd is exlcuded').to.be.equal('llo');
      expect(s.substring(5, 2), 'if indexStart is greater than indexEnd, two indexes were swapped').to.be.equal('llo');
      expect(s.substring(2, 2)).to.be.empty;        // jshint ignore: line
      expect(s.slice(), 'a simple copy method').to.be.equal('Hello, JavaScript!');
    });

    // 1. null is object while undefined id undefined
    // 2. prefer null when unsure
    it('The null and undefined', function () {
      expect(typeof (null)).to.be.equal('object');
      expect(typeof (undefined)).to.be.equal('undefined');
    });

    it('Template String(ES6 feature)', function () {
      var a = 1, b = 1.2, c = 'ljatsh';
      expect(`${a}_${b}_${c}`).to.be.equal('1_1.2_ljatsh');
    });

    it('Unicode', function () {
      var s = '\u4e2d\u534e\u4eba\u6c11\u5171\u548c\u56fd';
      expect(s).to.be.equal('中华人民共和国');

      expect(String.fromCharCode(0x4e2d, 0x534e, 0x4eba, 0x6c11, 0x5171, 0x548c, 0x56fd)).to.be.equal('中华人民共和国');
      expect(String.fromCodePoint(0x4e2d, 0x534e, 0x4eba, 0x6c11, 0x5171, 0x548c, 0x56fd)).to.be.equal('中华人民共和国');
    });
  });
});
