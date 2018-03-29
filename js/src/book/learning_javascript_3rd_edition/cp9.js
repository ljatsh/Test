
// Learning JavaScript, 3rd Edition.
// Chapter 9. Objects and Object-Oriented Programming.

var assert = require('assert');

describe('OOP', function() {
    it('Test', function() {
        var symbol = Symbol('test')
        console.log({1:2, [symbol]:4});
    });
});
