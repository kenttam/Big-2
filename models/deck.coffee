Ranks = require "./ranks"
Suits = require "./suits"
Card = require "./card"
_ = require "../public/javascripts/lib/underscore-min"

class Deck
  constructor: ->
    @cards = []
    for own rank_num, rank of Ranks
      for own suit_num, suit of Suits
        @cards.push(new Card(rank, suit))
  shuffle: ->
    @cards = _.shuffle(@cards)

module.exports = Deck
