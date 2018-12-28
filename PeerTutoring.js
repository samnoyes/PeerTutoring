//Create file
var fs = require("fs");
var file = "questionsDatabase.db";
var exists = fs.existsSync(file);

var express = require('express');
var app = express();

var sqlite = require('sqlite3').verbose();
var db = new sqlite.Database(file);

var parser = require('body-parser');
app.use(parser.json());
app.use(parser.urlencoded({extended: true}));

var questions = [//Sample Questions
  { author : 'Audrey Hepburn', title: "Audrey Hepburn quote", description : "Nothing is impossible, the word itself says 'I'm possible'!"},
  { author : 'Walt Disney', title: "Walt Disney quote", description : "You may not realize it when it happens, but a kick in the teeth may be the best thing in the world for you"},
  { author : 'Unknown', title: "Unknown quote", description : "Even the greatest was once a beginner. Don't be afraid to take that first step."},
  { author : 'Neale Donald Walsch', title: "Neale Donald Walsch quote", description : "You are afraid to die, and you're afraid to live. What a way to exist."}
];

if (!exists) {
	console.log("Creating DB file.");
  	fs.openSync(file, "w");


	db.serialize(function(){
			console.log("adding first elements to database");

			db.run('CREATE TABLE questions(author TEXT,title TEXT,description TEXT,subject TEXT,time DATETIME)');
			db.run('CREATE TABLE comments(author TEXT,text TEXT,postID INTEGER,time DATETIME)');

			var query = db.prepare('INSERT INTO questions VALUES(?,?,?,?,?)');

			for (var q in questions) {
				query.run(questions[q]['author'], questions[q]['title'],questions[q]['description'],"English",new Date());
			}

			query.finalize();
	});
	exists = true;
}

app.post('/question', function(req, res) {
	if (!req.body.hasOwnProperty('author') || !req.body.hasOwnProperty('title') || !req.body.hasOwnProperty('description') || !req.body.hasOwnProperty('subject')) {
		res.statusCode = 400;
		console.log(req.body);
		return res.send('Error 400: bad syntax');
	}
	console.log('recieved question');

	db.serialize(function(){
		var query = db.prepare('INSERT INTO questions VALUES(?,?,?,?,?)');
		query.run(req.body.author, req.body.title, req.body.description, req.body.subject,new Date());
		query.finalize();
	});

	res.json(true);
});

app.post('/questions/:num', function(req, res) {
	console.log("Got the post boys");
	var json = [];
	var c = 0;
	res.setHeader('Content-Type', 'application/json');
	var sql = 'SELECT COUNT(*) AS numRows FROM questions';
	var numRows = 0;
	var rowsToGet = 20;
		db.each("select * from (select rowid as id, * from questions order by rowid DESC limit " + rowsToGet + " offset " + req.params.num + ") order by rowid ASC;", function(err, row) {
	 		if (!err && row.title != null && row.description!=null && row.author != null && row.subject != null && row.time != null) {
	    		json[c] = { Title: row.title, Description: row.description, Author: row.author, Subject: row.subject, Time: row.time, ID: row.id};
	    		c++;
	 		}
	 		else {
	 			console.log(err);
	 			return res.send("Error 400: bad syntax!");
	 		}
		}, function(err, rows) {
			if (!err) {
				return res.json(json);
			}
			console.log(err)
			return res.send(err)
		});
});

app.post('/filtered_questions/:num', function(req, res) {
	var json = [];
	var c = 0;
	res.setHeader('Content-Type', 'application/json');
	var sql = 'SELECT COUNT(*) AS numRows FROM questions';
	var numRows = 0;
	var rowsToGet = 20;
	db.each("SELECT COUNT(*) AS numRows FROM questions", function(err, row) {
        numRows = row['numRows'];
        if (parseInt(req.params.num) > numRows && parseInt(req.params.num) > 0) {
			return res.send("Error 400: bad syntax!");
		}
        var queryStr = "select rowid as id, * from questions WHERE subject = '"
        for (var subject in req.body) {
			queryStr += req.body[subject] + "' OR subject = '";
        }
        queryStr = queryStr.slice(0,-15);
        queryStr += " order by rowid DESC limit " + rowsToGet + " offset " + req.params.num;
        console.log("select * from (" + queryStr + ") order by rowid ASC;")
		db.each("select * from (" + queryStr + ") order by rowid ASC;", function(err, row) {//select * from questions WHERE subject = " + subject + " order by rowid DESC limit " + rowsToGet + " offset " + req.params.num + ") order by rowid ASC;", function(err, row) {
	 		if (!err && row.title != null && row.description != null && row.author != null && row.subject != null && row.time != null) {
	    		json[c] = { Title: row.title, Description: row.description, Author: row.author, Subject: row.subject, Time: row.time, ID: row.id};
	    		c++;
	 		}
	 		else {
	 			console.log(err);
	 			return res.send("Error 400: bad syntax!");
	 		}
		}, function(err, rows) {
			if (!err) {
				return res.json(json);
			}
			console.log(err)
			return res.send(err)
		});
		
    });
});

app.post('/comment', function(req, res) {
	console.log(req.body);
	if (!req.body.hasOwnProperty('author') || !req.body.hasOwnProperty('text') || !req.body.hasOwnProperty('postID')) {
		res.statusCode = 400;
		console.log("Bad syntax.  Author: " + req.body.author + ". text: " + req.body.text + ".  ID: " + req.body.postID);
		return res.send('Error 400: bad syntax');
	}
	console.log('recieved comment');

	db.serialize(function() {
		var query = db.prepare('INSERT INTO comments VALUES(?,?,?,?)');
		query.run(req.body.author,req.body.text,req.body.postID, new Date());
		query.finalize();
	});

	res.json(true);
});

app.delete('/comment/:id', function(req, res) {
	if (exists) {
		db.serialize( function() {
			db.run("DELETE FROM comments WHERE rowid = " + req.params.id, function(error) {
				if (error) {
					console.log(error);
					res.send("Error 400: bad syntax");
				}
				else {
					res.send("Deleted successfully!");
				}
			});
		});
	}
});

app.delete('/comment', function(req, res) {
	if (exists) {
		db.serialize( function() {
			if (req.body.hasOwnProperty('postID'), req.body.hasOwnProperty(''))
			db.run("DELETE FROM comments WHERE rowid = " + req.params.id, function(error) {
				if (error) {
					console.log(error);
					res.send("Error 400: bad syntax");
				}
				else {
					res.send("Deleted successfully!");
				}
			});
		});
	}
});

app.delete('/question/:id', function(req, res) {
	if (exists) {
		db.serialize( function() {
			db.run("DELETE FROM questions WHERE rowid = " + req.params.id, function(error) {
				if (error) {
					console.log(error);
					res.send("Error 400: bad syntax");
				}
				else {
					res.send("Deleted successfully!");
				}
			});
		});
	}
});

app.put('/question', function(req,res) {//Edit a question
	if (exists) {
		db.serialize( function() {
			if (req.body.hasOwnProperty('author') && req.body.hasOwnProperty('title') && req.body.hasOwnProperty('description') && req.body.hasOwnProperty('id')) {
				db.each("SELECT rowid AS id, title, description, author FROM questions WHERE rowid = " + req.body.id + "\nUNION ALL\nSELECT NULL, NULL, NULL\nLIMIT 1;", function(err, row) {
					if (err) {
						console.log(err);
						res.send("Error 400: bad syntax!");
					}
					else if (row.title != null && row.description != null && row.author != null) {
						db.run("UPDATE questions SET author = '" + req.body.author + "', title = '" + req.body.title + "', description = '" + req.body.description + "' WHERE rowid = " + row.id, function(err) {
							if (err) {
								console.log(err);
								return res.send("Error 400: bad syntax!");
							}
							res.send("Successfully updated author, title, and description");
						});
					}
					else {
						res.send("Error 404: question not found");
					}
				});
			}
			else if (req.body.hasOwnProperty('title') && req.body.hasOwnProperty('description') && req.body.hasOwnProperty('id')) {
				db.each("SELECT rowid AS id, title, description, author FROM questions WHERE rowid = " + req.body.id + "\nUNION ALL\nSELECT NULL, NULL, NULL\nLIMIT 1;", function(err, row) {
					if (err) {
						console.log(err);
						res.send("Error 400: bad syntax!");
					}
					else if (row.title != null && row.description != null && row.author != null) {
						db.run("UPDATE questions SET title = '" + req.body.title + "', description = '" + req.body.description + "' WHERE rowid = " + row.id, function(err) {
							if (err) {
								console.log(err);
								return res.send("Error 400: bad syntax!");
							}
							res.send("Successfully updated title and description");
						});
					}
					else {
						res.send("Error 404: question not found");
					}
				});
			}
			else if (req.body.hasOwnProperty('author') && req.body.hasOwnProperty('id')) {
				db.each("SELECT rowid AS id, title, description, author FROM questions WHERE rowid = " + req.body.id + "\nUNION ALL\nSELECT NULL, NULL, NULL\nLIMIT 1;", function(err, row) {
					if (err) {
						console.log(err);
						res.send("Error 400: bad syntax!");
					}
					else if (row.title != null && row.description != null && row.author != null) {
						db.run("UPDATE questions SET author = '" + req.body.author + "' WHERE rowid = " + row.id, function(err) {
							if (err) {
								console.log(err);
								return res.send("Error 400: bad syntax!");
							}
							res.send("Successfully updated author");
						});
					}
					else {
						res.send("Error 404: question not found");
					}
				});
			}
			else {
				res.send('Error 400: bad syntax!');
			}

		});
	}
});

app.get('/', function(req, res) {
	res.type("text/plain");
	res.send("Hello world");
});

app.get('/question/:id', function(req, res) {
	if (exists) {
		db.serialize( function() {
			db.each("SELECT rowid AS id, title, description, author, subject, time FROM questions WHERE rowid = " + req.params.id + "\nUNION ALL\nSELECT NULL, NULL, NULL, NULL, NULL\nLIMIT 1;", function(err, row) {
	     		if (err) {
	     			console.log(err);
	     			return res.send("Error 400: bad syntax!");
	     		}
	     		else if (row.title != null && row.description != null && row.author != null) {
	     			return res.json({Title: row.title, Description: row.description, Author: row.author, Subject: row.subject, time: row.time});
	     			console.log("Found that match!");
	     			match = true;
	     		}
	     		else {
	     			return res.send("Error 404: question not found");
	     		}
	  		});
		});
	}
	else if (req.params.id < questions.length && req.params.id >= 0) {
		res.send(questions[req.params.id]);
		console.log("taking from the offline database");
	}
});

app.get('/comments/:id', function(req, res) {
	var json = [];
	var c = 0;
	res.setHeader('Content-Type', 'application/json');
	db.each("SELECT rowid AS id, * FROM comments WHERE postID = " + req.params.id, function(err, row) {
 		if (!err && row.text != null && row.author != null && row.postID != null && row.time != null) {
    		json[c] = { Text: row.text, Author: row.author, Time: row.time, ID: row.id};
    		c++;
 		}
 		else {
 			console.log(err);
 			return res.send("Error 400: bad syntax!");
 		}
	}, function(err, rows) {
		if (!err) {
			return res.json(json);
		}
		console.log(err)
		return res.send(err)
	});
});

app.get('/*', function(req, res) {
	res.send("404 –– Page not found");
});



app.listen(process.env.PORT || 3020);