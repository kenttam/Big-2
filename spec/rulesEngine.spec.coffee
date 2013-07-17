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

