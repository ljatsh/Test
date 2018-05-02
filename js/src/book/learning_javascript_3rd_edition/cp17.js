
// Learning JavaScript, 3rd Edition.
// Chapter 17. Regular Expressions

// 1. There are following meta characters:
//    ^ $ . * + ? = ! : | \ / ( ) [ ] { }
// 2. Unlike Python, \r is also newline character.
// 3. ? can be appended to repetition metacharacter to change greedy matches.

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
    });
});
