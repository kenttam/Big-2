	var game;
	$(document).ready(function(){
		$.get('http://localhost:8888/loadCards', function(data){
			game = data;
			for(var n = 0; n < game.players.length;  n++){
				if(!(game.players[n])){
					continue;
				}
				var currentPlayer = game.players[n];
				var $current = jQuery(".player").eq(n);
				for(var m = 0; m < currentPlayer.hand.length; m++){
					var item = currentPlayer.hand[m];
					var $ul = $current.find('ul');
					$ul.append("<li>" + item.rank + " of " + item.suit+ "</li> "); //append the element
					$ul.find('li').last().data("card", item); //and then attach the card data to it
				}
			}
			$(".player").find("li").click(function(){
				$(this).toggleClass("selected");
			});
			$(".player").eq(game.whoseTurn).addClass("myTurn");
		});
	});
	$("#play-button").click(function(){
		var whoseTurn = game.whoseTurn;
		var $currentPlayer = $(".player").eq(whoseTurn);
		var cardsInPlay = $currentPlayer.find('.selected');
		if(cardsInPlay.length != 1 && cardsInPlay.length != 2 && cardsInPlay.length != 5){
			alert("Please play the appropriate amount of cards");
			return false;
		}
		var indexes = [];
		for(var x = 0; x < cardsInPlay.length; x++){
			indexes.push($currentPlayer.find("li").index(cardsInPlay[x]));
		}
		//this is where ajax needs to be used.
		//var s_indexes = JSON.stringify('indexes': indexes);
		var x_indexes = {'indexes' : indexes};
		$.post('http://localhost:8888/act', x_indexes, function(u_data) {
			var data = JSON.parse(u_data);
			if(data.successful === true) //this means that the action was successful
			{
				$("#center").html("");
				cardsInPlay.clone().appendTo("#center");
				cardsInPlay.remove();
				var i = $(".player").index(".myTurn");
				$(".myTurn").removeClass("myTurn");
				$(".player").eq(data.game.whoseTurn).addClass("myTurn");
			}
		});
		return false;
	});
	$("#pass-button").click(function(){
		$.post('http://localhost:8888/pass', function(u_data) {
			var data = JSON.parse(u_data);
			if(data.successful === true){
				$(".myTurn").removeClass("myTurn");
				$(".player").eq(data.game.whoseTurn).addClass("myTurn");
			}
		});
	});