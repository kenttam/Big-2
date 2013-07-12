Ranks = require "./ranks"
_ = require "./lib/underscore-min"

class Card
  constructor: (rank, suit)->
    @rank = rank
    @suits = suit
  numericalRank: ->
    numericalRankDictionary = _.invert Ranks
    parseInt(numericalRankDictionary[@rank], 10)

module.exports = Card
