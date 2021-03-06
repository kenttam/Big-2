_ = require "../public/javascripts/lib/underscore-min"
Card = require "./card"
Deck = require "./deck"
Player = require "./player"
RulesEngine = require "./rulesEngine"
ScoreEngine = require "./scoreEngine"

class Game
  constructor: (@name)->
    @deck = new Deck()
    @players = []
    @rulesEngine = new RulesEngine()
    @scoreEngine = new ScoreEngine()
    @playersPassed = 0
    @cardsInCenter = []
    @history = []
    @gameOver = true
    
  addPlayer: (player) ->
    if @players.length < 4 and player.constructor.name == "Player"
      @players.push player
      player.game = this
      return @players.length - 1
    else
      return false
  
  start: ->
    if @players.length == 4
      @deck.shuffle()
      @passOutCards()
      @whoseTurn = @findPlayerIndexWithDiamondThree()
      @gameOver = false
      return @whoseTurn
    else
      return false
     
  passOutCards: ->
    @players[0].hand = @deck.cards[0...13].sort(@rulesEngine.compareSingleCard)
    @players[1].hand = @deck.cards[13...26].sort(@rulesEngine.compareSingleCard)
    @players[2].hand = @deck.cards[26...39].sort(@rulesEngine.compareSingleCard)
    @players[3].hand = @deck.cards[39...52].sort(@rulesEngine.compareSingleCard)
    
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
        if @rulesEngine.checkIfMoveIsValid(cards, @cardsInCenter) and @currentPlayerHasCards(cards)
          @endTurn(cards)
          return true
        else
          return false
      else
        return false
    if @players[@whoseTurn].id == id
      if @rulesEngine.checkIfMoveIsValid(cards, @cardsInCenter) and @currentPlayerHasCards(cards)
        @endTurn(cards)
        return true
      else
        return false
    else
      return false
  playerPassed: (id) ->
    if @players[@whoseTurn].id == id and @playersPassed < 3
      @players[@whoseTurn].passed = true
      @endTurn()
      return true
    else
      return false
  endTurn:(cards) ->
    if cards?
      @history.push cards
      @cardsInCenter = cards
      @playersPassed = 0
      _.each(@players , (player) ->
        player.passed = false
      )
      @removeCardFromPlayersHand cards
    else
      @playersPassed += 1
      if @playersPassed == 3
        @cardsInCenter = []
    @players[@whoseTurn].lastPlayed = cards
    if @players[@whoseTurn].hand.length == 0
      @gameOver = true
      @scoreEngine.scoreGame(@players)
      return
    @whoseTurn += 1
    if @whoseTurn == 4
      @whoseTurn = 0
  currentPlayerHasCards: (cards) ->
    for card in cards
      found = _.find @players[@whoseTurn].hand, (cardInHand) ->
        return cardInHand.equal(card)
      unless found?
        return false
    return true
  removeCardFromPlayersHand: (cardsToRemove) ->
    @players[@whoseTurn].hand = _.reject @players[@whoseTurn].hand, (cardInHand) ->
      found = _.find cardsToRemove, (cardToRemove) ->
        return cardInHand.equal(cardToRemove)
      unless found?
        return false
      return true
    
module.exports = Game
