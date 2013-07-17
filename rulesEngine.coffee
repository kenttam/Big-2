_ = require "./lib/underscore-min"

class RulesEngine
  constructor: ()->
    
  checkIfMoveIsValid: (cards, cardsInCenter) ->
    if cardsInCenter.length == 0
      return @validMove cards
    else if @isSingle cardsInCenter
      if @isSingle cards
        return @validSingleMove cards, cardsInCenter
      else
        return false
    else if @isPair cardsInCenter
      if @isPair cards
        return validPairPlay cards, cardsInCenter
      
  validSinglePlay: (cards, cardsInCenter) ->
    if cards[0].numericalRank() > cardsInCenter[0].numericalRank()
      return true
    else if cards[0].numericalRank() == cardsInCenter[0].numericalRank()
      return cards[0].suitRank() > cardsInCenter[0].suitRank()
    else
      return false
  
  validPairPlay: (cards, cardsInCenter) ->
    if cards[0].numericalRank() > cardsInCenter[0].numericalRank()
      return true
    else if cards[0].numericalRank() == cardsInCenter[0].numericalRank()
      sortedCards = @sortBySuitRank(cards)
      sortedCenter = @sortBySuitRank(cardsInCenter)
      return sortedCards[1].suitRank() > sortedCenter[1].suitRank()
    else
      return false

  validFiveCardsPlay: (cards, cardsInCenter) ->
    if @isStraightFlush cardsInCenter
      if @isStraightFlush cards
        return @compareStraightFlush cards, cardsInCenter

  compareStraightFlush: (cards, center) ->
    sortedCards = @sortByNumericalRank cards
    sortedCenter = @sortBySuitRank center
    if (sortedCards[4].numericalRank() > sortedCenter[4].numericalRank())
      return true
    else if (sortedCards[4].numericalRank() == sortedCenter[4].numericalRank())
      if sortedCards[4].suitRank() > sortedCenter[4].suitRank()
        return true
      else
        return false
    else
      return false
     
  validHand: (cards) ->
    @isSingle cards or @isPair cards or @validFiveCardMove cards

  validFiveCardHand: (cards) ->
    @isStraight cards or @isFlush cards or @isFullHouse cards or @isFourOfAKind

  isSingle: (cards) ->
    return cards.length == 1
   
  isPair: (cards) ->
    return cards.length == 2 && cards[0].rank == cards[1].rank

  isStraight: (cards) ->
    sortedCards = @sortByNumericalRank(cards)
    for x in [0...4]
      unless sortedCards[x].numericalRank() + 1 is sortedCards[x+1].numericalRank()
        return false

    return true
  isFlush: (cards) ->
    if(cards[0].suit == cards[1].suit == cards[2].suit == cards[3].suit == cards[4].suit)
      return true
    else
      return false
  isFullHouse: (cards) ->
    sortedCards = @sortByNumericalRank(cards)
    if(sortedCards[0].numericalRank() == sortedCards[1].numericalRank() == sortedCards[2].numericalRank() && sortedCards[3].numericalRank() == sortedCards[4].numericalRank())
      return true
    if(sortedCards[0].numericalRank() == sortedCards[1].numericalRank() && sortedCards[2].numericalRank() == sortedCards[3].numericalRank() == sortedCards[4].numericalRank())
      return true
    return false
  isFourOfAKind: (cards) ->
    sortedCards = @sortByNumericalRank(cards)
    if(sortedCards[0].numericalRank() == sortedCards[1].numericalRank() == sortedCards[2].numericalRank() == sortedCards[3].numericalRank() || sortedCards[1].numericalRank() == sortedCards[1].numericalRank() == sortedCards[2].numericalRank() == sortedCards[3].numericalRank())
      return true
    else
      return false
  isStraightFlush: (cards) ->
    @isStraight(cards) && @isFlush(cards)

  sortByNumericalRank: (cards) ->
    _.sortBy(cards, (card)->
      card.numericalRank()
    )
  sortBySuitRank: (cards) ->
    _.sortBy(cards, (card)->
      card.suitRank()
    )


module.exports = RulesEngine
