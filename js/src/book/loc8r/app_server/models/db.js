
var mongoose = require('mongoose');

var dbUrl = 'mongodb://localhost/Loc85';
mongoose.connect(dbUrl);

mongoose.connection.on('connected', function() {
    console.log('Mongoose connected to ' + dbUrl);
});

mongoose.connection.on('error', function(err) {
    console.log('Mongoose error ' + err);
});

mongoose.connection.on('disconnected', function() {
    console.log('Mongoose disconnected from ' + dbUrl);
});

// graceful shutdown
var gracefulShutdown = function(msg, callback) {
    mongoose.connection.close(function() {
        console.log('close connection from ' + dbUrl + ' through msg:' + msg);
        callback();
    });
};

process.once('SIGUSR2', function() {
    gracefulShutdown('nodemon restart', function() {
        process.kill(process.pid, 'SIGUSR2');
    });
});

process.on('SIGINT', function() {
    gracefulShutdown('app termination', function() {
        process.exit(0);
    });
});

process.on('SIGTERM', function() {
    gracefulShutdown('app shutdown', function() {
        process.exit(0);
    });
});
