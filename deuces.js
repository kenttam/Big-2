var ranks = [3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A", 2];

var suits = ["Spades", "Hearts", "Clubs", "Diamonds"];

function removeByIndex(arrayName,arrayIndex){ 
	arrayName.splice(arrayIndex,1); 
}

function Card(rank, suit){
	this.rank = rank;
	this.suit = suit;
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

function Player(){
	this.hand = [];
}

function Game(){
	this.deck = new Deck();
	this.players = [new Player(), new Player(), new Player(), new Player()];
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


var game = new Game;