
/**
 * Module dependencies.
 */

/*var express = require('express')
  , routes = require('./routes');

var app = module.exports = express.createServer();

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({ secret: 'your secret here' }));
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// Routes

app.get('/', routes.index);

app.listen(3000, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
*/

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
var deuces = require("./deuces");
var fs = require('fs')  , 
routes = require('./routes/game');

var map = {};

var express = require('express');
var app = express.createServer();
var io = require('socket.io').listen(app);

MemoryStore = require('connect/middleware/session/memory');
var session_store = new MemoryStore();

/*io.sockets.on('connection', function (socket) {
	socket.emit('news', { hello: 'world' });
	socket.on('my other event', function (data) {
		console.log(data);
	});
	socket.on("hi", function(data){
		console.log("hi");
	});
});*/

var connect = require('connect');
io.on('connection', function(socket_client) {
  var cookie_string = socket_client.request.headers.cookie;
  var parsed_cookies = connect.utils.parseCookie(cookie_string);
  var connect_sid = parsed_cookies['connect.sid'];
  if (connect_sid) {
    session_store.get(connect_sid, function (error, session) {
      //HOORAY NOW YOU'VE GOT THE SESSION OBJECT!!!!
    });
  }
});

app.configure(function(){
	app.set('views', __dirname + '/views');
	app.set('view engine', 'jade');
	app.use(express.bodyParser());
	app.use(express.methodOverride());
	app.use(express.cookieParser());
	app.use(express.session({ store: session_store }));
	app.use(app.router);
	app.use(require("stylus").middleware({
	    src: __dirname + "/public",
	    compress: true
	}));
	app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

app.get('/create-game', function(req, res){
	require('crypto').randomBytes(8, function(ex, buf) {
		var token = buf.toString('hex');
		console.log(token);
		req.session.game_id = token;
		req.session.player_id = 0;
		var string = "<a href='/join/"+token+"'>localhost:8888/join/"+token+"</a>";
		res.write(string.toString());
		res.end();
		map[token] = new deuces.game;
		map[token].numPlayers = 1;
	});
  //res.end();
  /*req.session.player_id = 1;
  console.log(req.session);
  res.end();*/
});

app.get('/join/:id?', function(req, res){
	var id = req.params.id;
	req.session.game_id = id;
	req.session.player_id = map[req.session.game_id].numPlayers;
	console.log("Game ID: "+req.session.game_id);
	map[req.session.game_id].numPlayers ++;
	res.writeHead(200, {"Content-Type": "text/html"});  
	res.write(id.toString());  
	res.end(); 
	/*res.write(id);
	res.end();*/
});

//app.get('/', routes.home);

app.get('/', function(req, res){
	console.log("Request handler 'start' was called.");
	console.log("Player id: " + req.session.player_id);
	if(!req.session.game_id){
		res.redirect('/create-game');
	}
	else{
		res.render('home', { title: 'Big 2' });
	}
	//res.send('hello world');
});
function clone(obj) {
    // Handle the 3 simple types, and null or undefined
    if (null == obj || "object" != typeof obj) return obj;

    // Handle Date
    if (obj instanceof Date) {
        var copy = new Date();
        copy.setTime(obj.getTime());
        return copy;
    }

    // Handle Array
    if (obj instanceof Array) {
        var copy = [];
        for (var i = 0, len = obj.length; i < len; ++i) {
            copy[i] = clone(obj[i]);
        }
        return copy;
    }

    // Handle Object
    if (obj instanceof Object) {
        var copy = {};
        for (var attr in obj) {
            if (obj.hasOwnProperty(attr)) copy[attr] = clone(obj[attr]);
        }
        return copy;
    }

    throw new Error("Unable to copy obj! Its type isn't supported.");
}

app.get('/loadCards', function(req, res){
	//console.log(map);
	var game = map[req.session.game_id];
	//var game = JSON.stringify(deuces.game);
	console.log(game.players);
	var pid = req.session.player_id;
	//var current_player = game.players[pid];
	var gameClone = clone(game);
	for(var x = 0; x < 4; x++){ //this is used to not let the player know the other player's cards
		if(pid != x){
			gameClone.players[x] = null;
		}
	}
	//var temp = sanitize_game(game);
	res.writeHead(200, {"Content-Type": "application/json"});
	res.write(JSON.stringify(gameClone));
	res.end()
});

app.post('/act', function(req, res){
	//var whoseTurn = deuces.game.whoseTurn;

	console.log(req.body);
	var indexes = req.body.indexes;

	var game = map[req.session.game_id];
	var whoseTurn = game.whoseTurn;
	var successful = game.players[whoseTurn].act(indexes);
	if(successful){
		game.playersPassed = 0;
		console.log("Act was called!");
		io.sockets.on('connection', function (socket) {
			if(successful)
				socket.emit('cardPlayed', { index:whoseTurn, lastPlayed: game.players[whoseTurn].lastPlayed  });
		});
	//console.log(deuces.game.center)
	}
	res.writeHead(200, {"Content-Type": "text/plain"});
	var data = {"game": game, "successful": successful};
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

/*function sanitize_game(game, pid){ //to return a temp game with only the current players cards, hiding the other players cards
  var temp = game;
  for(var x = 0; x < 4; x++){ //this is used to not let the player know the other player's cards
    if(pid != x){
      temp.players[x] = null;
    }
  }
  return temp;
}*/