var http = require('http');
var parse = require('url').parse;
var join = require('path').join;
var querystring = require('querystring');
var jade = require('jade');

var gitlab_ip = 'gitlab';
var gitlab_port = 80;
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
      if (res.statusCode != 200) {
        reject(new Error('Invalid http response code: ' + res.statusCode));
        return;
      }

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

function parse_tree(data) {
  return new Promise((resolve, reject) => {
    try {
      var obj = JSON.parse(data);

      if ((obj instanceof Array) && obj.length == 0) {
        reject(new Error('Invalid folder path'));
      }

      resolve(obj);
    }
    catch(err) {
      reject(err);
    }
  });
}

function parse_file(data) {
  return new Promise((resolve, reject) => {
    try {
      var obj = JSON.parse(data);
      var content = Buffer.from(obj.content, 'base64');

      resolve(content);
    }
    catch(err) {
      reject(err);
    }
  });
}

function generate_tree_html(path, json, res) {
  var items = [];
  json.forEach((item) => {
    if (item.type == 'tree') {
      items.push({'tree': true, 'name': item.name});
    }
    else if (item.type == 'blob') {
      items.push({'tree': false, 'name': item.name});
    }
  });

  var fn = jade.compileFile('tree.jade');

  res.statusCode = 200;
  res.end(fn({
    tree: {
      name: path,
      items: items
    },
  }));
}

function handler(req, res) {
  var url = parse(req.url);
  var path = url.pathname.substring(1, url.pathname.length);

  get(`/api/v4/projects/${project_id}/repository/tree?private_token=${private_key}&path=${path}`)
    .then((data) => { return parse_tree(data); })
    .then((tree) => { generate_tree_html(path, tree, res); })
    .catch((err) => {
      //console.log(err);

      path = querystring.escape(path);

      get(`/api/v4/projects/${project_id}/repository/files/${path}?private_token=${private_key}&ref=master`)
        .then((data) => { return parse_file(data); })
        .then((content) => {
          res.statusCode = 200;
          res.end(content);
        })
        .catch((err) => {
          res.statusCode = 404;
          res.end('Not Found');
        });
    });
}

var server = http.createServer(handler);
server.listen(80);

// TODO jade template performance optimization
// error category
