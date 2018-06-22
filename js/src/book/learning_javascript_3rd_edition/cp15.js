
// Learning JavaScript, 3rd Edition.
// Chapter 15. Date and Time

var chai = require('chai');
var chaiAsPromised = require('chai-as-promised');

chai.use(chaiAsPromised);

var assert = chai.assert;

describe('Date and Time', function() {
    it('Test', function() {
        var date = new Date(2018, 3, 16, 23, 29, 5, 100);

        assert.equal(date.getFullYear(), 2018);
        assert.equal(date.getMonth(), 3);
        assert.equal(date.getDate(), 16);
        assert.equal(date.getHours(), 23);
        assert.equal(date.getMinutes(), 29);
        assert.equal(date.getSeconds(), 5);
        assert.equal(date.getMilliseconds(), 100);

        var date2 = new Date(date.getTime());
        // TODO. Equal vs DeepEuqal
        assert.deepEqual(date2, date);

        date2.setSeconds(date.getSeconds() + 120);

        assert.equal(date2 - date, 120000, 'TODO');
    });
});
