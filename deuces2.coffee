_ = require "./lib/underscore-min"
Card = require "./card"
Deck = require "./deck"
Player = require "./player"
RulesEngine = require "./rulesEngine"

class Game
  constructor: ->
    @deck = new Deck()
    @players = []
    @rulesEngine = new RulesEngine()
    @playersPassed = 0
    @cardsInCenter = []
    @history = []
    
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
    if @history.length == 0
      diamondThree = _.find cards, (card)->
        return card.equal(new Card(3, "Diamond"))
      if diamondThree?
        return @rulesEngine.checkIfMoveIsValid cards, @cardsInCenter
      else
        return false
    if @players[@whoseTurn].id == id
      return @rulesEngine.checkIfMoveIsValid(cards, @cardsInCenter)
    else
      return false
 
exports.Game = Game
