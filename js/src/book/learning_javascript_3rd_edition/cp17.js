
// Learning JavaScript, 3rd Edition.
// Chapter 17. Regular Expressions

// 1. There are following meta characters:
//    ^ $ . * + ? = ! : | \ / ( ) [ ] { }
// 2. Unlike Python, \r is also newline character.
// 3. ? can be appended to repetition metacharacter to change greedy matches.
// 4. Be careful with the format of repetition {m,n}. You cannot write {m, n}:)
// 5. \b is zero width. \w\b\w cannot match anything because a word can never be followed both a word an non-word character.

var chai = require('chai');
var assert = chai.assert;

describe('Regular Expressions', function() {
    describe('Meta Characters', function() {
        it('\\ --> use it as a escape character', function() {
            assert.match('hello...', /\w+\.{3}/);
            assert.match('c:\\data\\file.txt', /[a-zA-Z]:\\\w+\\\w+\.\w+/);
        });

        it('^ --> match from the beginning of the string', function() {
            assert.match('lj@sh', /@/);
            assert.notMatch('lj@sh', /^@/);
            assert.match('@home', /^@/);
            assert.notMatch('lj@sh\n@home', /^@/);
            assert.match('lj@sh\n@home', /^@/m,
                         'a new line is the beginning if m flag is given');
            assert.match('lj@sh\r@home', /^@/m,
                         '\\r is also new line character');
        });

        it('$ --> match at the end of string and any location before newline character', function() {
            assert.match('www.baidu.com/', /\.com/);
            assert.notMatch('www.baidu.com/', /\.com$/);
            assert.match('1:www.baidu.com/\n2:www.163.com', /\.com$/, 'matches at the end');
            assert.notMatch('1:www.baidu.com\n2:www.163.com/', /\.com$/, 'matches at the end');
            assert.match('1:www.baidu.com\n2:www.163.com/', /\.com$/m, 'matches before the new line');
            assert.match('1:www.baidu.com\n\n2:www.163.com/', /\.com$/m, 'matches before the new line');
            assert.match('1:www.baidu.com\r2:www.163.com/', /\.com$/m, '\\r is also newline character');
            assert.match('1:www.baidu.com\r\n2:www.163.com/', /\.com$/m, '\\r is also newline character');
        });

        it('. --> match any signle character except for the newline character', function() {
            assert.match('hello, a', /.a/);
            assert.notMatch('hello,\ra', /.a/);
            assert.notMatch('hello,\na', /.a/);
        });

        it('\\w --> match alphanumeric and underscore', function() {
            // \w is short of [a-zA-Z0-9_]
            assert.deepEqual('hello, world! 23'.match(/\w+/g), ['hello', 'world', '23']);
            assert.deepEqual('helli, world! 23'.match(/\W+/g), [', ', '! ']);
        });

        it('\\b --> match a word boundary', function() {
            assert.match('moon', /\bm/);
            assert.notMatch('moon', /oo\b/);
            assert.match('moon', /oo\B/);
            assert.notMatch('moon', /\w\b\w/,
                            'this pattern cannot match anything');
        });

        it('\\d --> match a digit character', function() {
            // \d is short of [0-9]
            assert.match('0', /\d/);
            assert.notMatch('_', /\d/);
        });

        it('\\s --> match blank character', function() {
            assert.match('foo bar', /\s\w+/);
            assert.notMatch('foobar', /\s\w+/);
            assert.match('foo-bar', /\S\w+/);
        });
    });

    describe('Repetition', function() {
        it('* --> match the preceding expression 0 or more times', function() {
            assert.match('abbc', /ab*c/);
            assert.match('ac', /ab*c/);
            assert.deepEqual('one|two|three|four'.match(/\|.*\|/g), ['|two|three|'],
                             'match is greedy by default');
            assert.deepEqual('one|two|three|four'.match(/\|.*?\|/g), ['|two|'],
                             'you can append ? to * to change greedy matches');
        });

        it('+ --> match the preceding expression 1 or more times', function() {
            assert.match('abbc', /ab+c/);
            assert.notMatch('ac', /ab+c/);
        });

        it('? --> match the preceding expressing 0 ore 1 time.', function() {
            assert.match('abc', /ab?c/);
            assert.match('ac', /ab?c/);
            assert.notMatch('abbc', /ab?c/);
        });

        it('{m[, n]} --> match at least m and at most n occurrences of the preceding expression', function() {
            assert.match('abc', /ab{1}c/);
            assert.notMatch('abbc', /ab{1}c/);

            assert.match('abc', /ab{1,}c/);
            assert.notMatch('ac', /ab{1,}c/);

            assert.match('abbc', /ab{1,3}c/);
            assert.notMatch('abbbbc', /ab{1,3}c/);
        });
    });
});
