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
  
  start: ->
    if @players.length == 4
      @deck.shuffle()
     
  passOutCards: ->
    @players[0].hand = @deck.cards[0...13]
    @players[1].hand = @deck.cards[13...26]
    @players[2].hand = @deck.cards[26...39]
    @players[3].hand = @deck.cards[39...52]
    
  findPlayerIndexWithDiamondThree: ->
    diamondThree = new Card(3, "Diamond")
    playerNumber = null
    _.each(@players, (player, currentPlayerNumber) ->
      _.each(player.hand, (card) ->
        if _.isEqual(card, diamondThree)
          playerNumber = currentPlayerNumber
      )
    )
    return playerNumber
    
    
class Deck
  constructor: ->
    @cards = []
    for own rank_num, rank of Ranks
      for own suit_num, suit of Suits
        @cards.push(new Card(rank, suit))
  shuffle: ->
    @cards = _.shuffle(@cards)

class Player
  constructor: ->
    @hand = []
    
class Card
  constructor: (rank, suit)->
    @rank = rank
    @suits = suit
 
exports.Card = Card
exports.Game = Game
exports.Player = Player
exports.Deck = Deck
