
var http = require('http');
var parse = require('url').parse;
var join = require('path').join;
var fs = require('fs');
var querystring = require('querystring');

var root = __dirname;

function static_file_handler(stat, path, req, res) {
  res.setHeader('Content-Length', stat.size);

  var stream = fs.createReadStream(path);
  stream.pipe(res);
  stream.on('error', function() {
    res.statusCode = 500;
    res.end('Internal Server Error');
  });
}

function other_request_handler(req, res) {
  if (req.url === '/form') {
    if (req.method == 'POST') {
      console.log("[200] " + req.method + " to " + req.url);
      var fullBody = '';
      req.on('data', function(chunk) {
        fullBody += chunk.toString();
      });
      req.on('end', function() {
        res.writeHead(200, "OK", {'Content-Type': 'text/html'});
        res.write('<html><head><title>Post data</title></head><body>');
        res.write('<style>th, td {text-align:left; padding:5px; color:black}\n');
        res.write('th {background-color:grey; color:white; min-width:10em}\n');
        res.write('td {background-color:lightgrey}\n');
        res.write('caption {font-weight:bold}</style>');
        res.write('<table border="1"><caption>Form Data</caption>');
        res.write('<tr><th>Name</th><th>Value</th>');
        var dBody = querystring.parse(fullBody);
        for (var prop in dBody) {
          res.write("<tr><td>" + prop + "</td><td>" + dBody[prop] + "</td></tr>");
        }
        res.write('</table></body></html>');
        res.end();
      });
      return true;
    }
  }

  return false;
}

function handler(req, res) {
  var url = parse(req.url);
  var path = join(root, url.pathname);
  fs.stat(path, function(err, stat) {
    if (!err && stat.isFile()) {
      static_file_handler(stat, path, req, res);
    }
    else {
      if (!other_request_handler(req, res)) {
        res.statusCode = 404;
        res.end('Not Found');
      }
    }
  });
}

var server = http.createServer(handler);
server.listen(8000);
