class Player
  constructor: (@id, @name) ->
    @hand = []
    @game = null
    @id ||= Math.floor(Math.random()*10000000) #using a random number for now until i can set up database and generate ids
    @passed = false
    @totalScore = 0
    @scoreForTheRound = 0
    @scoreHistory = []
  playCards: (cards)->
    game.processTurn(@id, cards)

module.exports = Player
