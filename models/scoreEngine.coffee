_ = require "../public/javascripts/lib/underscore-min"

class ScoreEngine
  scoreGame: (players) ->

  scoreSinglePlayer: (player) ->
    numCardsLeft = player.hand.length
    if numCardsLeft < 8
      multiplier = 1
    else if numCardsLeft < 10
      multiplier = 2
    else if numCardsLeft < 13
      multiplier = 3
    else
      multiplier = 4
    player.scoreForTheRound = -1 * multiplier * numCardsLeft
    player.totalScore += player.scoreForTheRound


module.exports = ScoreEngine
