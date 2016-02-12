var http = require('http');
var express = require('express');
var path = require('path');
var app = express();
var server = http.Server(app);
var bodyParser = require('body-parser');

var port = process.env.PORT || 12345;

app.use(bodyParser.urlencoded({ extended: true })); 

//app.use(express.bodyParser());

app.post('/myaction', function(req, res) {
  res.send('You sent the name "' + req.body.name + '".');
});

app.use(express.static(path.join(__dirname, 'public/')));

server.listen(port, function(){
	console.log('App is listening on port ' + port);

});
