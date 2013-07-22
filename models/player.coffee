class Player
  constructor: (@name, @id) ->
    @hand = []
    @game = null
    @id ||= Math.floor(Math.random()*10000000) #using a random number for now until i can set up database and generate ids
  playCards: (cards)->
    game.processTurn(@id, cards)

module.exports = Player
