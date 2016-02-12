var http       = require('http');
var path       = require('path');
var express    = require('express');
var bodyParser = require('body-parser');

var port = process.env.PORT || 12345;

var app = express();
var server = http.Server(app);

app.use(bodyParser.urlencoded({ extended: true })); 

app.post('/myaction', function(req, res) {
  // TODO SAVE TO DATABASE (SQLITE?)

  // TODO SEND RESPONSE OF confirmation to user
  res.send('You sent the name "' + req.body.name + '".');
  res.send('You sent the email "' + req.body.email + '".');
  res.send('You sent the message "' + req.body.message + '".');
});

app.use(express.static(path.join(__dirname, 'public/')));

server.listen(port, function(){
	console.log('App is listening on port ' + port);

});
