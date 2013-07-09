_ = require "./lib/underscore-min"

Ranks =
  0 : 3
  1 : 4
  2 : 5
  3 : 6
  4 : 7
  5 : 8
  6 : 9
  7 : 10
  8 : "J"
  9 : "Q"
  10 : "K"
  11 : "A"
  12 : 2

Suits =
  0 : "Diamond"
  1 : "Club"
  2 : "Hearts"
  3 : "Spade"

class Game
  constructor: ->
    @deck = new Deck()
    @players = []
    
  addPlayer: (player) ->
    if player instanceof Player and @players.length < 4
      @players.push player
  
class Deck
  constructor: ->
    @cards = []
    for own rank_num, rank of Ranks
      for own suit_num, suit of Suits
        @cards.push(new Card(rank, suit))

class Player
  constructor: ->

class Card
  constructor: (rank, suit)->
    @rank = rank
    @suits = suit
 
exports.Card = Card
exports.Game = Game
exports.Player = Player
