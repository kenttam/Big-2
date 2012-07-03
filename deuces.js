var ranks = [3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A", 2];

var numericalRanks = invert(ranks);

var suits = ["Diamond", "Club", "Heart", "Spade"];

var suitRanks = invert(suits);

var fiveCardsPlays = ["Straight", "Flush", "Full House", "Straight Flush"];

var fiveCardsPlayRanks = invert(fiveCardsPlays);

function removeByIndex(arrayName,arrayIndex){ 
	arrayName.splice(arrayIndex,1); 
}

function removeByIndexes(arrayName, arrayIndexes, offset){
	offset = typeof offset !== 'undefined' ? offset : 0; //default value for offset should be 0
	if(arrayIndexes.length == 0){
		return true;
	}
	arrayIndexes.sort();
	arrayName.splice(arrayIndexes[0] - offset, 1); //basecase
	arrayIndexes.splice(0,1); //remove the first element
	return removeByIndexes(arrayName, arrayIndexes, offset + 1);
}

function Card(rank, suit){
	this.rank = rank;
	this.suit = suit;
	this.numericalRank = numericalRanks[rank];
	this.suitRank = suitRanks[suit];
}

function Deck(){
	var cards = [];
	for(var x = 0; x < ranks.length; x++){
		for(var y = 0; y < suits.length; y++){
			cards.push(new Card(ranks[x], suits[y]));
		}
	}
	this.cards = cards;
}

Deck.prototype.shuffle = function(){
	//the shuffle method will pull out one card randomly and place it in the temp deck
	var result = [],
		randomNum;

	while(this.cards.length > 0){
		randomNum = Math.floor(Math.random() * this.cards.length);
		result.push(this.cards[randomNum]);
		removeByIndex(this.cards, randomNum);
	}

	this.cards = result;

}

function hasDiamondThree(cards){ //returns true if it has Diamond 3, false otherwise
	for(var x = 0; x < cards.length; x++){
		if(cards[x].suit == "Diamond" && cards[x].rank == 3){
			return true;
		}
	}
	return false;
}

function Player(game){
	this.hand = [];
	this.game = game;
}

Player.prototype.act = function(cardIndexes){
	//cards can only be played as singles, pairs, and 5-card hands,
	//have to check whether or not it is a valid hand.
	//have to check whether or not that player has those cards
	//5 cards hands come in straight, flush, full house, four of a kind + 1 card, straight flush
	//this function should take in an array of ints as the cards in hand that would be played ie. [0,2,4,6,7]
	var cardsToPlay = [];
	for(key in cardIndexes){
		cardsToPlay.push(this.hand[cardIndexes[key]]); //shouldnt pop until the end after verifying it's a valid move
	}

	if(this.game.state == 0){ //this represents the beginning of the game where the player can play anything he wants as long as the hand is valid and include the diamond 3
		if(hasDiamondThree(cardsToPlay)){
			if(this.game.isSingle(cardsToPlay) || this.game.isPair(cardsToPlay) || this.game.isFiveCardPlay(cardsToPlay)){
				this.game.putCardsInCenter(this, cardsToPlay);
				removeByIndexes(this.hand, cardIndexes);
				return true;
			}
			else
				return false;
		}
		else{
			return false;
		}
	}

	if(this.game.state == 2){ //everyone else has passed
		if(this.game.isSingle(cardsToPlay) || this.game.isPair(cardsToPlay) || this.game.isFiveCardPlay(cardsToPlay)){
			this.game.putCardsInCenter(this, cardsToPlay);
			removeByIndexes(this.hand, cardIndexes);
			return true;
		}
		else
			return false;
	}

	if(this.game.isSingle(cardsToPlay) && this.game.validSingleCardPlay(this.game.center, cardsToPlay)){
		this.game.putCardsInCenter(this, cardsToPlay);
		removeByIndexes(this.hand, cardIndexes);
		return true;
	}
	if(this.game.isPair(cardsToPlay) && this.game.validPairPlay(this.game.center, cardsToPlay)){
		this.game.putCardsInCenter(this, cardsToPlay);
		removeByIndexes(this.hand, cardIndexes);
		return true;
	}
	if(cardsToPlay.length == 5){
		if(validFiveCardPlay(this.game.center, cardsToPlay)){
			this.game.putCardsInCenter(this, cardsToPlay);
			removeByIndexes(this.hand, cardIndexes);
			return true;
		}
	}
	return false;

}

function Game(){
	this.deck = new Deck();
	this.players = [new Player(this), new Player(this), new Player(this), new Player(this)];
	this.center = [];
	this.centerHistory = [];
	this.playersPassed = 0;
	//this.whoseTurn = Math.floor(Math.random()*this.players.length); turn is determined by player holding the diamond 3 or last winner
}

Game.prototype.start = function(){
	this.deck.shuffle();
	this.passOutCards();
	for(var x = 0; x < this.players.length; x++){
		this.players[x].hand.sort(cardComparison);
		var firstCard = this.players[x].hand[0];
		if(firstCard.suit == "Diamond" && firstCard.rank == 3){
			//three of diamond goes first
			this.whoseTurn = x;
		}
	}
	this.state = 0;
	$(".player").eq(this.whoseTurn).addClass("myTurn");
}

Game.prototype.passOutCards = function(){
	var playerIndex = 0;
	while(this.deck.cards.length > 0){
		this.players[playerIndex].hand.push(this.deck.cards.pop());
		if(playerIndex === 3){
			playerIndex = 0;
		}else{
			playerIndex ++;
		}

	}

}

Game.prototype.print = function(){
	var string = "";
	var suit, rank;
	for(var x = 0; x < this.players.length; x++){
		string += "Player "+x+ ": ";
		for(var y = 0; y < this.players[x].hand.length; y++){
			suit = this.players[x].hand[y].suit;
			rank = this.players[x].hand[y].rank;
			string += rank + " of  " + suit + ", ";
		}
		string += "<br>";
	}
	document.write(string);
}

Game.prototype.putCardsInCenter = function(player, cards){
	this.center = [];
	for(key in cards){
		this.center.push(cards[key]);
	}
	this.centerHistory.push(this.center);
	this.yieldToNextPlayer();
	this.state = 1; //not zero, zero stands for beginning of game
}

Game.prototype.yieldToNextPlayer = function(){
	$(".myTurn").removeClass("myTurn");
	if(this.whoseTurn < 3)
		this.whoseTurn ++;
	else
		this.whoseTurn = 0;
	$(".player").eq(this.whoseTurn).addClass("myTurn");
}

Game.prototype.processTurn = function(){
	var cardsPlayed = this.players[this.whoseTurn].act();
	for (card in cardsPlayed){
		this.center.push(card);
	}
}

Game.prototype.checkMove = function(){

}

Game.prototype.validSingleCardPlay = function(inCenter, played){
	if(inCenter.length != 1){
		return false;
	}
	if(played[0].numericalRank > inCenter[0].numericalRank)
		return true;
	if(played[0].numericalRank == inCenter[0].numericalRank && played[0].suitRank > inCenter[0].suitRank)
		return true;
	return false;
}

Game.prototype.validPairPlay = function(inCenter, played){
	if(inCenter.length != 2){
		return false;
	}
	if(played[0].numericalRank > inCenter[0].numericalRank){
		return true;
	}
	//the pair can only be valid if it has a spade
	if(played[0].numericalRank == inCenter[1].numericalRank){
		if(played[0].suit == "Spade" || played[1].suit == "Spade")
			return true;
	}
	return false;
}

Game.prototype.validFiveCardPlay = function(inCenter, played){
	if(inCenter.length != 5){
		return false;
	}
	var inCenterRank = game.fiveCardsPlayMap(inCenter),
		playedRank = game.fiveCardsPlayMap(played);
	if(playedRank > inCenterRank){
		return true;
	}
	else if(playedRank == inCenterRank){ //same five card play
		//Judge from highest available card: Straight Flush, Flush, Straight
		//Four of a Kind judges the rank of the 4-cards Full house judge from the rank of the 3-card
		if(playedRank == 4 || playedRank == 1 || playedRank == 0){ //judge by rank of highest card
			var highestPlayed = played.sort(cardComparison)[4];
			var highestinCenter = inCenter.sort(cardComparison)[4];
			var higher = cardComparison(highestPlayed, highestinCenter); //returns 1 if first is better than second
			if(higher == 1){
				return true;
			}
			else{
				return false;
			}
		}
		else{ //full house and four of a kind
			//after the hand has been sorted, no matter what the third card is bound to be part of the set
			var playedSorted = played.sort(cardComparison);
			var inCenterSorted = inCenter.sort(cardComparison);

			var higher = cardComparison(playedSorted[2], inCenterSorted[2])

			if(higher == 1)
				return true;
			else
				return false;
		}

	}
	else
		return false;
}

Game.prototype.fiveCardPlaysMap = function(cards){
	if(this.isStraightFlush(cards)){
		return 4; //"Straigh Flush";
	}
	else if(this.isFourOfaKind(cards)){
		return 3; //"Four of a Kind";
	}
	else if(this.isFullHouse(cards)){
		return 2; //"Full House";
	}
	else if(this.isFlush(cards)){
		return 1; //"Flush";
	}
	else if(this.isStraight(cards)){
		return 0; //"Straight";
	}
}

Game.prototype.isSingle = function(cards){
	if(cards.length === 1){
		return true;
	}
	else{
		return false;
	}
}

Game.prototype.isPair = function(cards){
	if(cards.length != 2){
		return false;
	}
	else if(cards[0].rank == cards[1].rank){
		return true;
	}
	else{
		return false;
	}
}

Game.prototype.isStraight = function(cards){
	var cardsInRank = [];
	for (var y = 0; y < 5; y++){
		cardsInRank.push(cards[y].numericalRank);
	}
	cardsInRank.sort();
	for (var x = 1; x < 5; x++){
		if(cardsInRank[x] != cardsInRank[x-1]+1)
			return false;
	}
	return true;
}

Game.prototype.isFiveCardPlay = function(cards){
	if(this.isStraight(cards) || this.isFlush(cards) || this.isFullHouse(cards) || this.isFourOfaKind(cards) || this.isStraightFlush(cards))
		return true;
	else
		return false;
}

Game.prototype.isFlush = function(cards){
	if(cards[0].suit == cards[1].suit && cards[1].suit == cards[2].suit && cards[2].suit == cards[3].suit && cards[3].suit == cards[4].suit){
		return true;
	}
	else{
		return false;
	}
}

Game.prototype.isFullHouse = function(cards){
	var cardsInRank = [];
	for (var y = 0; y < 5; y++){
		cardsInRank.push(cards[y].numericalRank);
	}
	cardsInRank.sort(); //cards are sorted by rank, now have to check if 3 cards are of the same rank and 2 are of the same rank

	if(cardsInRank[0] == cardsInRank[1] && cardsInRank[1] == cardsInRank[2])
		return true;
	if(cardsInRank[2] == cardsInRank[3] && cardsInRank[3] == cardsInRank[4])
		return true;
	return false;
}

Game.prototype.isStraightFlush = function(cards){
	if(this.isStraight(cards) && this.isFlush(cards))
		return true;
	else
		return false;
}

Game.prototype.isFourOfaKind = function(cards){
	var cardsInRank = [];
	for (var y = 0; y < 5; y++){
		cardsInRank.push(cards[y].numericalRank);
	}
	cardsInRank.sort();
	if(cardsInRank[0] == cardsInRank[1] && cardsInRank[1] == cardsInRank[2] && cardsInRank[2] == cardsInRank[3]){
		return true;
	}
	if(cardsInRank[1] == cardsInRank[2] && cardsInRank[2] == cardsInRank[3] && cardsInRank[3] == cardsInRank[4]){
		return true;
	}
	return false;
}

function invert(obj) {
    var new_obj = {};
    for (var prop in obj) {
	    if(obj.hasOwnProperty(prop)) {
	    	new_obj[obj[prop]] = parseInt(prop);
	    }
    }
    return new_obj;
};

function sortCards(cards){ //returns in order smallest to largest only returns the rank and not the actual card
	var cardsInRank = [];
	for (var y = 0; y < 5; y++){
		cardsInRank.push(cards[y].numericalRank);
	}
	return cardsInRank.sort();
}

function cardComparison(card1, card2){
	//-1: card1 < card2
	//0: card1 == card2
	//1: card1 > card2
	if(card1.numericalRank > card2.numericalRank){
		return 1;
	}
	else if (card1.numericalRank == card2.numericalRank && card1.suitRank > card2.suitRank){
		return 1;
	}
	if(card1.numericalRank == card2.numericalRank && card1.suitRank == card2.suitRank){
		return 0
	}
	return -1;
}

var game = new Game;

game.start();
var player1 = game.players[0];
//player1.hand.sort(cardComparison);
//game.center = [player1.hand[0], player1.hand[1]];
var player2 = game.players[1];
//player2.hand.sort(cardComparison);
//game.print();

for(var n = 0; n < game.players.length;  n++){
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
	//console.log($(this).data().card);
	$(this).toggleClass("selected");
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
	if(game.players[whoseTurn].act(indexes)){ //if it's a valid move, have to remove those cards from the gui
		$("#center").html("");
		cardsInPlay.clone().appendTo("#center");
		cardsInPlay.remove();
		game.playersPassed = 0;
	}
	return false;
});

$("#pass-button").click(function(){
	if(game.state != 1){
		return false;
	}
	game.playersPassed ++;
	game.yieldToNextPlayer();
	if(game.playersPassed == 3){
		game.state = 2;
	}
	return false;
});

//the game has a few states.
//State 1: Beginning of the game. Diamond 3 goes first. The Diamond 3 must be part of the play. Winner goes first in subsequent games, but worrying about that later;
//State 2: Card is in play, player must beat the card that is in play or pass
//State 3: Everybody (3 people) has passed, play anything you want.
