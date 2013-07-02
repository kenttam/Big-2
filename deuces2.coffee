_ = require "./lib/underscore-min"

class Game
  constructor: ->
  
class Deck
  constructor: ->

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

class Card
  constructor: (rank, suit)->
    this.rank = rank
    this.suits = suit
 
exports.Card = Card
exports.Game = Game
