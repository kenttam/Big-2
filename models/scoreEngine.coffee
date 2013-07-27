_ = require "../public/javascripts/lib/underscore-min"

class ScoreEngine
  scoreGame: (players) ->
    that = this
    totalSubtracted = @scoreLosingPlayers(players)
    winner = _.find players, (player) ->
      player.hand.length is 0
    console.log winner
    winner.scoreForTheRound = -1 * totalSubtracted
    winner.totalScore += winner.scoreForTheRound
    winner.scoreHistory.push winner.totalScore

  scoreLosingPlayers: (players) ->
    that = this
    _.reduce(players, (memo, player) ->
      memo + that.scoreSinglePlayer(player)
    , 0)

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
    return player.scoreForTheRound


module.exports = ScoreEngine
