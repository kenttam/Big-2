Ranks = require "./ranks"
Suits = require "./suits"
_ = require "../lib/underscore-min"

class Card
  constructor: (rank, suit)->
    @rank = rank
    @suit = suit
  numericalRank: ->
    numericalRankDictionary = _.invert Ranks
    parseInt(numericalRankDictionary[@rank], 10)
  suitRank: ->
    suitRankDictionary = _.invert Suits
    parseInt(suitRankDictionary[@suit], 10)
  equal: (card) ->
    @rank == card.rank && @suit == card.suit


module.exports = Card
