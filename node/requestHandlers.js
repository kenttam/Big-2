var fs = require('fs');

function start(response, postData, deuces) {
  console.log("Request handler 'start' was called.");

  /*var body = '<html>'+
    '<head>'+
    '<meta http-equiv="Content-Type" content="text/html; '+
    'charset=UTF-8" />'+
    '</head>'+
    '<body>'+
    '<form action="/upload" method="post">'+
    '<textarea name="text" rows="20" cols="60"></textarea>'+
    '<input type="submit" value="Submit text" />'+
    '</form>'+
    '</body>'+
    '</html>';*/

    fs.readFile('../index.html', function (err, html) {
        if (err) {
            throw err; 
        }       
        response.writeHead(200, {"Content-Type": "text/html"});  
        response.write(html);  
        response.end();  
    });

    /*response.writeHead(200, {"Content-Type": "text/html"});
    response.write(body);
    response.end();*/
}

function loadCards(response, postData, deuces){
  console.log(deuces.game);
  var game = JSON.stringify(deuces.game);
  response.writeHead(200, {"Content-Type": "application/json"});
  response.write(game);
  response.end()
}

function upload(response, postData, deuces) {
  console.log("Request handler 'upload' was called.");
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.write("You've sent: " + postData);
  response.end();
}

function act(response, postData, deuces){
  var whoseTurn = deuces.game.whoseTurn;
  //var $currentPlayer = $(".player").eq(whoseTurn);
  /*var cardsInPlay = $currentPlayer.find('.selected');
  if(cardsInPlay.length != 1 && cardsInPlay.length != 2 && cardsInPlay.length != 5){
    alert("Please play the appropriate amount of cards");
    return false;
  }*/
  console.log(postData);
  var indexes = JSON.parse(postData);
  /*for(var x = 0; x < cardsInPlay.length; x++){
    indexes.push($currentPlayer.find("li").index(cardsInPlay[x]));
  }*/
  var successful = deuces.game.players[whoseTurn].act(indexes);
  if(successful){ //if it's a valid move, have to remove those cards from the gui
    //$("#center").html("");
    //cardsInPlay.clone().appendTo("#center");
    //cardsInPlay.remove();
    deuces.game.playersPassed = 0;
    console.log(deuces.game.center)
  }
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.write(successful.toString());
  response.end();
  //return false;

}

function pass(response, postData, deuces){
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
    response.writeHead(200, {"Content-Type": "text/plain"});
    response.write(successful.toString());
    response.end();
}

exports.start = start;
exports.upload = upload;
exports.act = act;
exports.loadCards = loadCards;
exports.pass = pass;