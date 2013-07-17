RulesEngine = require "../rulesEngine"
Card = require "../card"

describe "The Rules Engine", ->
  rulesEngine = new RulesEngine()
  it "is not null", ->
    expect(RulesEngine?).toBe true
  it "can tell if a hand is a single", ->
    hand = [new Card(3, "Diamond")]
    expect(rulesEngine.isSingle(hand)).toBe true
    hand.push new Card(4, "Diamond")
    expect(rulesEngine.isSingle(hand)).toBe false
  it "can tell if a hand is a pair", ->
    hand = [new Card(3, "Diamond")]
    expect(rulesEngine.isPair(hand)).toBe false
    hand.push new Card(4, "Diamond")
    expect(rulesEngine.isPair(hand)).toBe false
    hand[1] = new Card(3, "Spade")
    expect(rulesEngine.isPair(hand)).toBe true
  it "can tell if a hand is a straight", ->
    hand = [new Card(3, "Diamond"), new Card(4, "Hearts"), new Card(5, "Club"), new Card(6, "Spade"), new Card(7, "Diamond")]
    expect(rulesEngine.isStraight hand).toBe true
    hand[4] = new Card(5, "Spade")
    expect(rulesEngine.isStraight hand).toBe false
  it "can tell if a hand is a flush", ->
    hand = [new Card(10, "Diamond"), new Card(4, "Diamond"), new Card(5, "Diamond"), new Card(6, "Diamond"), new Card(7, "Diamond")]
    expect(rulesEngine.isFlush hand).toBe true
    hand[0] = new Card(10, "Spade")
    expect(rulesEngine.isFlush hand).toBe false
  it "can tell if a hand is a full house", ->
    hand = [new Card(2, "Diamond"), new Card(2, "Spade"), new Card(3, "Diamond"), new Card(3, "Spade"), new Card(3, "Heart")]
    expect(rulesEngine.isFullHouse hand).toBe true
    hand[4] = new Card(4, "Heart")
    expect(rulesEngine.isFullHouse hand).toBe false
  it "can tell if a hand is a four of a kind", ->
    hand = [new Card(3, "Club"),new Card(2, "Diamond"), new Card(3, "Diamond"), new Card(3, "Spade"), new Card(3, "Heart")]
    expect(rulesEngine.isFourOfAKind hand).toBe true
    hand = [new Card(2, "Club"),new Card(2, "Diamond"), new Card(3, "Diamond"), new Card(3, "Spade"), new Card(3, "Heart")]
    expect(rulesEngine.isFourOfAKind hand).toBe false
  it "can tell if a hand is a straight flush", ->
    hand = [new Card(3, "Diamond"), new Card(4, "Diamond"), new Card(5, "Diamond"), new Card(6, "Diamond"), new Card(7, "Diamond")]
    expect(rulesEngine.isStraightFlush hand).toBe true
    hand = [new Card(3, "Spade"), new Card(4, "Diamond"), new Card(5, "Diamond"), new Card(6, "Diamond"), new Card(7, "Diamond")]
    expect(rulesEngine.isStraightFlush hand).toBe false
  it "can sort cards by Suits", ->
    hand = [new Card(3, "Heart"), new Card(3, "Spade"), new Card(3, "Diamond"), new Card(3 , "Club")]
    sortedHand = rulesEngine.sortBySuitRank(hand)
    expect(sortedHand[0].suit).toBe "Diamond"
    expect(sortedHand[1].suit).toBe "Club"
    expect(sortedHand[2].suit).toBe "Heart"
    expect(sortedHand[3].suit).toBe "Spade"
  it "can sort cards by Rank", ->
    hand = [new Card(2, "Heart"), new Card("A", "Spade"), new Card("K", "Diamond"), new Card(3 , "Club")]
    sortedHand = rulesEngine.sortByNumericalRank(hand)
    expect(sortedHand[0].rank).toBe 3
    expect(sortedHand[1].rank).toBe "K"
  describe "comparisons", ->
    it "can tell if a single is better than the one in center", ->
      hand = [new Card(3, "Spade")]
      center = [new Card(4, "Diamond")]
      expect(rulesEngine.validSinglePlay hand, center).toBe false
      hand = [new Card(4, "Spade")]
      expect(rulesEngine.validSinglePlay hand, center).toBe true
    it "can tell if a pair is better than the one in center", ->
      hand = [new Card(3, "Spade"), new Card(3, "Diamond")]
      center = [new Card(4, "Spade"), new Card(4, "Diamond")]
      expect(rulesEngine.validPairPlay hand, center).toBe false
      expect(rulesEngine.validPairPlay center, hand).toBe true
      center = [new Card(3, "Hearts"), new Card(3, "Club")]
      expect(rulesEngine.validPairPlay hand, center).toBe true
  describe "five cards plays", ->
    it "can tell if one straight flush is better than another", ->
      hand = [new Card(3, "Diamond"), new Card(4, "Diamond"), new Card(5, "Diamond"), new Card(6, "Diamond"), new Card(7, "Diamond")]
      center = [new Card(3, "Spade"), new Card(4, "Spade"), new Card(5, "Spade"), new Card(6, "Spade"), new Card(7, "Spade")]
      expect(rulesEngine.compareStraightFlush hand, center).toBe false
      hand[0] = new Card(8, "Diamond")
      expect(rulesEngine.compareStraightFlush hand, center).toBe true
    it "can tell the rank of a four of a kind", ->
      hand = [new Card(3, "Diamond"), new Card(3, "Heart"), new Card(3, "Spade"), new Card(3, "Club"), new Card(7, "Diamond")]
      expect(rulesEngine.getFourOfAKindRank hand).toBe 0
    it "can compare four of a kind", ->
      hand = [new Card(3, "Diamond"), new Card(3, "Heart"), new Card(3, "Spade"), new Card(3, "Club"), new Card(7, "Diamond")]
      center = [new Card(4, "Diamond"), new Card(4, "Heart"), new Card(4, "Spade"), new Card(4, "Club"), new Card(7, "Diamond")]
      expect(rulesEngine.compareFourOfAKind hand, center).toBe false
    it "can compare full house", ->
      hand = [new Card(3, "Diamond"), new Card(3, "Heart"), new Card(3, "Spade"), new Card(7, "Club"), new Card(7, "Diamond")]
      center = [new Card(4, "Diamond"), new Card(4, "Heart"), new Card(4, "Spade"), new Card(7, "Club"), new Card(7, "Diamond")]
      expect(rulesEngine.compareFullHouse hand, center).toBe false
    it "can compare flushes", ->
      hand = [new Card(9, "Diamond"), new Card(4, "Diamond"), new Card(5, "Diamond"), new Card(6, "Diamond"), new Card(7, "Diamond")]
      center = [new Card(8, "Spade"), new Card(4, "Spade"), new Card(5, "Spade"), new Card(6, "Spade"), new Card(7, "Spade")]
      expect(rulesEngine.compareFlush hand, center).toBe false
      center  = [new Card(8, "Diamond"), new Card(10, "Diamond"), new Card("J", "Diamond"), new Card("Q", "Diamond"), new Card(2, "Diamond")]
      expect(rulesEngine.compareFlush center, hand).toBe true
    it "can compare straights", ->
      hand = [new Card(8, "Spade"), new Card(4, "Diamond"), new Card(5, "Diamond"), new Card(6, "Diamond"), new Card(7, "Diamond")]
      center = [new Card(8, "Diamond"), new Card(4, "Spade"), new Card(5, "Spade"), new Card(6, "Spade"), new Card(7, "Spade")]
      expect(rulesEngine.compareFlush hand, center).toBe true
      center = [new Card(3, "Diamond"), new Card(4, "Spade"), new Card(5, "Spade"), new Card(6, "Spade"), new Card(7, "Spade")]
      expect(rulesEngine.compareFlush hand, center).toBe true
    it "can validate five card plays", ->
      straightFlush = [new Card(3, "Diamond"), new Card(4, "Diamond"), new Card(5, "Diamond"), new Card(6, "Diamond"), new Card(7, "Diamond")]
      fourOfAKind = [new Card(3, "Club"),new Card(2, "Diamond"), new Card(3, "Diamond"), new Card(3, "Spade"), new Card(3, "Heart")]
      fullHouse = [new Card(2, "Diamond"), new Card(2, "Spade"), new Card(3, "Diamond"), new Card(3, "Spade"), new Card(3, "Heart")]
      flush = [new Card(10, "Diamond"), new Card(4, "Diamond"), new Card(5, "Diamond"), new Card(6, "Diamond"), new Card(7, "Diamond")]
      straight = [new Card(3, "Diamond"), new Card(4, "Hearts"), new Card(5, "Club"), new Card(6, "Spade"), new Card(7, "Diamond")]
      expect(rulesEngine.validFiveCardsPlay straightFlush, fourOfAKind).toBe true
      expect(rulesEngine.validFiveCardsPlay fourOfAKind, fullHouse).toBe true
      expect(rulesEngine.validFiveCardsPlay fullHouse, flush).toBe true
      expect(rulesEngine.validFiveCardsPlay flush, straight).toBe true
      expect(rulesEngine.validFiveCardsPlay straightFlush, flush).toBe true
      
