_ = require "./lib/underscore-min"

class RulesEngine
  constructor: ()->
    
  checkIfMoveIsValid: (cards) ->
    ###
    if @playersPassed == 3 || @cardsInCenter.length == 0
      
    else
    ###
  isSingle: (cards) ->
    return cards.length == 1
   
  isPair: (cards) ->
    return cards.length == 2 && cards[0].rank == cards[1].rank

  isStraight: (cards) ->
    sortedCards = _.sortBy(cards, (card)->
      card.numericalRank()
    )
    for x in [0...4]
      unless sortedCards[x].numericalRank() + 1 is sortedCards[x+1].numericalRank()
        return false

    return true

module.exports = RulesEngine
