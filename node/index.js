/*var deuces = require("../deuces");
var server = require("./server");
var router = require("./router");
var requestHandlers = require("./requestHandlers");

var handle = {}
handle["/"] =  requestHandlers.start;
handle["/start"] = requestHandlers.start;
handle["/upload"] = requestHandlers.upload;
handle["/act"] = requestHandlers.act;
handle["/loadCards"] = requestHandlers.loadCards;
handle["/pass"] = requestHandlers.pass;
console.log(deuces);
server.start(router.route, handle, deuces);
*/
var deuces = require("../deuces");
var fs = require('fs');

var express = require('express');
var app = express.createServer();
app.use(express.bodyParser());
app.use(express.cookieParser());
app.use(express.session({ secret: "keyboard cat" }));

app.get('/getgame', function(req, res){
	req.session.player_id = 1;
	console.log(req.session);
	res.end();
});

app.get('/', function(req, res){
	console.log("Request handler 'start' was called.");
	console.log("Player id: " + req.session.player_id);
    fs.readFile('../index.html', function (err, html) {
        if (err) {
            throw err; 
        }       
        res.writeHead(200, {"Content-Type": "text/html"});  
        res.write(html);  
        res.end();  
    });
  //res.send('hello world');
});

app.get('/loadCards', function(req, res){
	console.log(deuces.game);
	var game = JSON.stringify(deuces.game);
	res.writeHead(200, {"Content-Type": "application/json"});
	res.write(game);
	res.end()
});

app.post('/act', function(req, res){
	var whoseTurn = deuces.game.whoseTurn;

	console.log(req.body);
	var indexes = req.body.indexes;

	var successful = deuces.game.players[whoseTurn].act(indexes);
	if(successful){
		deuces.game.playersPassed = 0;
		console.log(deuces.game.center)
	}

	res.writeHead(200, {"Content-Type": "text/plain"});
	var data = {"game": deuces.game, "successful": successful};
	res.write(JSON.stringify(data));
	res.end();
});

app.post('/pass', function(req, res){
    var game = deuces.game;
    var successful = true;
    if(game.state != 1){ //you could only pass at state 1, state 0 and 3 you can play any cards you want
      successful = false;
    }
    else{
      game.playersPassed ++;
      game.yieldToNextPlayer();
      if(game.playersPassed == 3){
        game.state = 2;
      }
    }
    res.writeHead(200, {"Content-Type": "text/plain"});
    var data = {"game": deuces.game, "successful": successful}
    res.write(JSON.stringify(data));
    res.end();
});

app.listen(8888);