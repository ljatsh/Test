
// Learning JavaScript, 3rd Edition.
// Chapter 4. Asynchronous Programming

//var assert = require('assert');
//var fs = require('fs');

describe('Asynchronous Programming', function() {
    it('Promise', function() {

        // var promise = new Promise(function(resolve, reject) {
        //     console.log(resolve);
        //     console.log(reject);
        //     //setTimeout(resolve, 1, 'foo');
        //     resolve('foo');
        // });

        // setTimeout(()=>promise.then((msg)=>{console.log('done...', msg);}),
        //            10);

        // promise.then((msg)=>{ console.log('done', msg); })
        //        .then((msg)=>{ console.log('done2', msg); })
        //        .catch((error)=>{console.log(error);});

        // console.log('Promise ended');
    });

    it('Mocha', function(done) {
        console.log(done);
        setImmediate(done);
        setImmediate(done);
    });
});
