// Generated by CoffeeScript 1.6.3
(function() {
  var Player;

  Player = (function() {
    function Player(id, name) {
      this.id = id;
      this.name = name;
      this.hand = [];
      this.game = null;
      this.id || (this.id = Math.floor(Math.random() * 10000000));
      this.passed = false;
      this.totalScore = 0;
      this.scoreForTheRound = 0;
      this.scoreHistory = [];
    }

    Player.prototype.playCards = function(cards) {
      return game.processTurn(this.id, cards);
    };

    return Player;

  })();

  module.exports = Player;

}).call(this);