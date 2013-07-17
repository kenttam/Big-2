// Generated by CoffeeScript 1.6.3
(function() {
  var Card, Ranks, Suits, _;

  Ranks = require("./ranks");

  Suits = require("./suits");

  _ = require("./lib/underscore-min");

  Card = (function() {
    function Card(rank, suit) {
      this.rank = rank;
      this.suit = suit;
    }

    Card.prototype.numericalRank = function() {
      var numericalRankDictionary;
      numericalRankDictionary = _.invert(Ranks);
      return parseInt(numericalRankDictionary[this.rank], 10);
    };

    Card.prototype.suitRank = function() {
      var suitRankDictionary;
      suitRankDictionary = _.invert(Suits);
      return parseInt(suitRankDictionary[this.suit], 10);
    };

    return Card;

  })();

  module.exports = Card;

}).call(this);
