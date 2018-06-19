var http = require('http');
var parse = require('url').parse;
var join = require('path').join;
var querystring = require('querystring');

var gitlab_ip = '192.168.0.130';
var gitlab_port = 81;
var private_key = 'iWE9x7kSQcFNSa-zidH7'; // 从个人资料设置拿到
var project_id = 4;

function get(path) {
  return new Promise((resolve, reject) => {
    var options = {
      host: gitlab_ip,
      port: gitlab_port,
      path: path,
      method: 'GET'
    };

    var req = http.request(options, function(res) {
      var _data = '';
      res.on('data', function(chunk) {
        _data += chunk;
      });
      res.on('end', function() {
        resolve(_data);
      });
    });
    req.on('error', function(err) {
      reject(err);
    } );
    req.end();
  });
}

function fetch_tree() {
  return new Promise((resolve, reject) => {
    var options = {
      host: gitlab_ip,
      port: gitlab_port,
      path: `/api/v3/projects/${project_id}/repository/tree?private_token=${private_key}`,
      method: 'GET'
    };

    var req = http.request(options, function(res) {
      var _data='';
      res.on('data', function(chunk){
        _data += chunk;
      });
      res.on('end', function(){
        console.log("\n--->>\nresult:",_data);
        });
      res.on('error', function() {

      });
    });
    req.end();
  });
}

get(`/api/v3/projects/${project_id}/repository/tree?private_token=${private_key}`)
.then((data) => { console.log(data); })
.catch((err) => { console.log(err); });

// https://nodejs.org/api/http.html#http_class_http_clientrequest
// https://blog.csdn.net/tiramisu_ljh/article/details/78749926

// function post_to_git(path, data, callback) {
//   var content=querystring.stringify(data);

//   var options = {
//       host: git_ip,
//       port: 80,
//       path: path,
//       method: 'POST',
//       headers:{
//       'Content-Type':'application/x-www-form-urlencoded',
//       'Content-Length':content.length
//       }
//     };

//     var req = http.request(options, function(res) {
//       console.log("statusCode: ", res.statusCode);
//       console.log("headers: ", res.headers);
//       var _data='';
//       res.on('data', function(chunk){
//          _data += chunk;
//       });
//       res.on('end', function(){
//          console.log("\n--->>\nresult:",_data)
//          callback(_data);
//        });
//     });

//     req.write(content);
//     req.end();
// }

// function get_from_git(path) {
//   var options = {
//       host: git_ip,
//       port: 80,
//       path: path,
//       method: 'GET'
//     };

//     var req = http.request(options, function(res) {
//       var _data='';
//       res.on('data', function(chunk){
//         _data += chunk;
//       });
//       res.on('end', function(){
//          console.log("\n--->>\nresult:",_data);
//         });
//     });
//     req.end();
// }

// var server = http.createServer(handler);
// server.listen(8000);

// post_to_git('/api/v3/session', {email:email, password:password}, function(data) {
//   console.log('...ok...');
//   //get_from_git('/api/v3/projects/xgame/repository/doc/design/demo/index.html?private_token=iWE9x7kSQcFNSa-zidH7');
//   //get_from_git('/api/v3/projects?private_token=iWE9x7kSQcFNSa-zidH7');
//   //get_from_git('/api/v3/projects/4/repository/tree?private_token=iWE9x7kSQcFNSa-zidH7');
//   get_from_git('/api/v3/projects/4/repository/files?private_token=iWE9x7kSQcFNSa-zidH7&file_path=doc/design/demo/index.html&ref=master');
// });
