var http = require('http');
var express = require('express');
var path = require('path');
var app = express();
var server = http.Server(app);

var port = process.env.PORT || 12345;

app.use(express.static(path.join(__dirname, '/public')));

server.listen(port, function(){
	console.log('App is listening on port ' + port);

});
