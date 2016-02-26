var http       = require('http');
var path       = require('path');
var express    = require('express');
var bodyParser = require('body-parser');
var sqlite3 = require('sqlite3').verbose();

var port = process.env.PORT || 12345;

var app = express();
var server = http.Server(app);

var db = new sqlite3.Database('wics_db.sqlite');
db.run("CREATE TABLE IF NOT EXISTS contactRequest (name TEXT, email TEXT, message TEXT)");

app.use(bodyParser.urlencoded({ extended: true })); 

app.post('/myaction', function(req, res) {
  // TODO SAVE TO DATABASE (SQLITE?)
  console.log('You sent the name "' + req.body.name + '".');
  console.log('You sent the email "' + req.body.email + '".');
  console.log('You sent the message "' + req.body.message + '".');

	db.run ("INSERT INTO contactRequest (name, email, message) VALUES (?, ?, ?)", req.body.name, req.body.email, req.body.message);

	db.each("SELECT name, email, message FROM contactRequest", function(err, row) {
      console.log(row.name);
      console.log(row.email);
      console.log(row.message);
  	});
  // TODO SEND RESPONSE OF confirmation to user
  res.write('You sent the name "' + req.body.name + '".');
  res.write('You sent the email "' + req.body.email + '".');
  res.end('You sent the message "' + req.body.message + '".');
});

app.use(express.static(path.join(__dirname, 'public/')));

server.listen(port, function(){
	console.log('App is listening on port ' + port);
});

