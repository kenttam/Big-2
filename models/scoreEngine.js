// Generated by CoffeeScript 1.6.3
(function() {
  var ScoreEngine, _;

  _ = require("../public/javascripts/lib/underscore-min");

  ScoreEngine = (function() {
    function ScoreEngine() {}

    ScoreEngine.prototype.scoreGame = function(players) {
      var that, totalSubtracted, winner;
      that = this;
      totalSubtracted = this.scoreLosingPlayers(players);
      winner = _.find(players, function(player) {
        return player.hand.length === 0;
      });
      console.log(winner);
      winner.scoreForTheRound = -1 * totalSubtracted;
      winner.totalScore += winner.scoreForTheRound;
      return winner.scoreHistory.push(winner.totalScore);
    };

    ScoreEngine.prototype.scoreLosingPlayers = function(players) {
      var that;
      that = this;
      return _.reduce(players, function(memo, player) {
        return memo + that.scoreSinglePlayer(player);
      }, 0);
    };

    ScoreEngine.prototype.scoreSinglePlayer = function(player) {
      var multiplier, numCardsLeft;
      numCardsLeft = player.hand.length;
      if (numCardsLeft < 8) {
        multiplier = 1;
      } else if (numCardsLeft < 10) {
        multiplier = 2;
      } else if (numCardsLeft < 13) {
        multiplier = 3;
      } else {
        multiplier = 4;
      }
      player.scoreForTheRound = -1 * multiplier * numCardsLeft;
      player.totalScore += player.scoreForTheRound;
      if (player.scoreForTheRound < 0) {
        player.scoreHistory.push(player.totalScore);
      }
      return player.scoreForTheRound;
    };

    return ScoreEngine;

  })();

  module.exports = ScoreEngine;

}).call(this);
