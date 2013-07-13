_ = require "./lib/underscore-min"
Card = require "./card"
Deck = require "./deck"
Player = require "./player"

class Game
  constructor: ->
    @deck = new Deck()
    @players = []
    @rulesEngine = new RulesEngine()
    @playersPassed = 0
    @cardsInCenter = []
    
  addPlayer: (player) ->
    if player instanceof Player and @players.length < 4
      @players.push player
      player.game = this
  
  start: ->
    if @players.length == 4
      @deck.shuffle()
      @passOutCards()
      @whoseTurn = @findPlayerIndexWithDiamondThree()
     
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

  processTurn: (id, cards) ->
    if @players[@whoseTurn].id == id
      result = @rulesEngine.checkIfMoveIsValid(cards)
    
class RulesEngine
  constructor: ()->
    
  checkIfMoveIsValid: (cards) ->
    ###
    if @playersPassed == 3 || @cardsInCenter.length == 0
      
    else
    ###
  isSingle: (cards) ->
    return cards.length == 1
   
  isPair: (cards) ->
    return cards.length == 2 && cards[0].rank == cards[1].rank

  isStraight: (cards) ->
    sortedCards = _.sortBy(cards, (card)->
      card.numericalRank()
    )
    for x in [0...4]
      unless sortedCards[x].numericalRank() + 1 is sortedCards[x+1].numericalRank()
        return false

    return true

 
exports.Game = Game
exports.RulesEngine = RulesEngine
