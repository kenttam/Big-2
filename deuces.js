var ranks = [3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A", 2];

var numericalRanks = invert(ranks);

var suits = ["Spades", "Hearts", "Clubs", "Diamonds"];

function removeByIndex(arrayName,arrayIndex){ 
	arrayName.splice(arrayIndex,1); 
}

function Card(rank, suit){
	this.rank = rank;
	this.suit = suit;
	this.numericalRank = numericalRanks[rank];
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

function Player(game){
	this.hand = [];
	this.game = game;
}

Player.prototype.act = function(cards){
	//cards can only be played as singles, pairs, and 5-card hands,
	//have to check whether or not it is a valid hand.
	//have to check whether or not that player has those cards
	//5 cards hands come in straight, flush, full house, four of a kind + 1 card, straight flush

}

function Game(){
	this.deck = new Deck();
	this.players = [new Player(this), new Player(this), new Player(this), new Player(this)];
	this.center = [];
	this.whoseTurn = Math.floor(Math.random()*this.players.length);
}

Game.prototype.start = function(){
	this.deck.shuffle();
	this.passOutCards();
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

Game.prototype.processTurn = function(){
	var cardsPlayed = this.players[this.whoseTurn].act();
	for (card in cardsPlayed){
		this.center.push(card);
	}
}

Game.prototype.checkMove = function(){

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

	if(cardsInRank[0] == cardsInRank[1] && cardsInRank[1] == cardsInRank[2] && cardsInRank[3] == cardsInRank[4])
		return true;
	if(cardsInRank[0] == cardsInRank[1] && cardsInRank[2] == cardsInRank[3] && cardsInRank[3] == cardsInRank[4])
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
	if(cardsInRank[0] == cardsInRank[1] && cardsInRank[1] == cardsInRank[2] && cardsInRank[2] == cardsInRank[3])
		return true;
	}
	if(cardsInRank[1] == cardsInRank[2] && cardsInRank[2] == cardsInRank[3] && cardsInRank[3] == cardsInRank[4])
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

var game = new Game;

var deck = new Deck();

var tempHand = [];
tempHand.push(deck.cards[0]);
tempHand.push(deck.cards[1]);
tempHand.push(deck.cards[2]);
tempHand.push(deck.cards[17]);
tempHand.push(deck.cards[16]);

document.write(game.isFullHouse(tempHand));