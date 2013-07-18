_ = require "./lib/underscore-min"

class RulesEngine
  constructor: ()->
    
  checkIfMoveIsValid: (cards, cardsInCenter) ->
    if cardsInCenter.length == 0
      return @validHand cards
    else if @isSingle cardsInCenter
      if @isSingle cards
        return @validSinglePlay cards, cardsInCenter
      else
        return false
    else if @isPair cardsInCenter
      if @isPair cards
        return @validPairPlay cards, cardsInCenter
      else
        return false
    else if @validFiveCardHand cardsInCenter
      if @validFiveCardHand cards
        return @validFiveCardsPlay cards, cardsInCenter
      else
        return false
      
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
      if @isStraightFlush(cards)
        return @compareStraightFlush cards, cardsInCenter
      else
        return false
    else if @isFourOfAKind cardsInCenter
      if @isStraightFlush(cards)
        return true
      else if @isFourOfAKind cards
        return @compareFourOfAKind cards, cardsInCenter
      else
        return false
    else if @isFullHouse cardsInCenter
      if @isStraightFlush(cards) || @isFourOfAKind(cards)
        return true
      else if @isFullHouse cards
        return @compareFullHouse cards, cardsInCenter
      else
        return false
    else if @isFlush cardsInCenter
      if @isStraightFlush(cards) || @isFourOfAKind(cards) || @isFullHouse(cards)
        return true
      else if @isFlush cards
        return @compareFlush cards, cardsInCenter
      else
        return false
    else if @isStraight cardsInCenter
      if @isStraightFlush(cards) || @isFourOfAKind(cards) || @isFullHouse(cards) || @isFlush(cards)
        return true
      else if @isStraight cards
        return @compareStraight cards, cardsInCenter
      else
        return false
    else
      return false

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

  compareFourOfAKind: (cards, center) ->
    return @getFourOfAKindRank(cards) > @getFourOfAKindRank(center)
  
  getFourOfAKindRank: (cards) ->
    if (cards[0].rank == cards[1].rank)
      return cards[0].numericalRank()
    else if cards[0] == cards[2].rank
      return cards[0].numericalRank()
    else
      return cards[1].numericalRank()

  compareFullHouse: (cards, center) ->
    return @getFullHouseRank(cards) > @getFullHouseRank(center)
 
  compareFlush: (cards, center) ->
    if (cards[0].suitRank() > center[0].suitRank())
      return true
    else if (cards[0].suitRank() == center[0].suitRank())
      sortedCards = @sortByNumericalRank cards
      sortedCenter = @sortByNumericalRank center
      return sortedCards[4].numericalRank() > sortedCenter[4].numericalRank()
    else
      return false

  compareStraight: (cards, center) ->
    sortedCards = @sortByNumericalRank cards
    sortedCenter = @sortByNumericalRank center
    if sortedCards[4].numericalRank() > sortedCenter[4].numericalRank()
      return true
    else if sortedCards[4].numericalRank() == sortedCenter[4].numericalRank()
      return sortedCards[4].suitRank() > sortedCenter[4].suitRank()
    else
      return false
  
  getFullHouseRank: (cards) ->
    sortedCards = @sortByNumericalRank cards
    if (sortedCards[0].rank == sortedCards[1].rank == sortedCards[2])
      return sortedCards[0].numericalRank()
    else
      return sortedCards[4].numericalRank()
     
  validHand: (cards) ->
    @isSingle(cards) or @isPair(cards) or @validFiveCardMove(cards)

  validFiveCardHand: (cards) ->
    cards.length == 5 and (@isStraight(cards) or @isFlush(cards) or @isFullHouse(cards) or @isFourOfAKind(cards))

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
