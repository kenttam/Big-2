deuces = require "../deuces2"
_ = require "../lib/underscore-min"

describe "The module", ->
	it "is not null", ->
		expect(deuces).not.toBe null

game = new deuces.Game()

describe "The Deck", ->
  it "is not null", ->
    expect(typeof(game.deck)).not.toBe 'undefined'

  it "has 52 cards", ->
    expect(game.deck.cards.length).toBe 52

  it "can be shuffled", ->
    newDeck = new deuces.Deck()
    game.deck.shuffle()
    expect(_.isEqual(game.deck.cards, newDeck.cards)).toBe false

describe "The Player", ->
  it "is not null", ->
    expect(deuces.Player?).toBe true

describe "The Card", ->
  it "can return numerical rank", ->
    card = new deuces.Card("3", "Diamond")
    expect(card.numericalRank()).toBe 0

describe "The Game", ->
  game = new deuces.Game()
  it "is not null", ->
    expect(deuces.Game?).toBe true
  it "has a deck", ->
    expect(game.deck?).toBe true
  it "has players", ->
    expect(game.players?).toBe true
  it "can add players", ->
    player = new deuces.Player()
    game.addPlayer player
    expect(game.players.length).toBe 1
    expect(player.game).toBe game
  it "should not add more than 4 players", ->
    player2 = new deuces.Player()
    player3 = new deuces.Player()
    player4 = new deuces.Player()
    game.addPlayer player2
    game.addPlayer player3
    game.addPlayer player4
    expect(game.players.length).toBe 4
    player5 = new deuces.Player()
    game.addPlayer player5
    expect(game.players.length).toBe 4
  it "should not add something that's not a player", ->
    game2 = new deuces.Game()
    game2.addPlayer 1
    expect(game2.players.length).toBe 0
  it "can pass out cards to players", ->
    game.passOutCards()
    expect(game.players[0].hand.length).toBe 13
    expect(game.players[1].hand.length).toBe 13
    expect(game.players[2].hand.length).toBe 13
    expect(game.players[3].hand.length).toBe 13
  it "can find the player with Diamond Three", ->
    game.players[0].hand = []
    game.players[1].hand = []
    game.players[2].hand = []
    game.players[3].hand = [new deuces.Card(3, "Diamond")]
    index = game.findPlayerIndexWithDiamondThree()
    expect(index).toBe 3

describe "The Rules Engine", ->
  rulesEngine = new deuces.RulesEngine()
  it "is not null", ->
    expect(deuces.RulesEngine?).toBe true
  it "can tell if a hand is a single", ->
    hand = [new deuces.Card(3, "Diamond")]
    expect(rulesEngine.isSingle(hand)).toBe true
    hand.push new deuces.Card(4, "Diamond")
    expect(rulesEngine.isSingle(hand)).toBe false
  it "can tell if a hand is a pair", ->
    hand = [new deuces.Card(3, "Diamond")]
    expect(rulesEngine.isPair(hand)).toBe false
    hand.push new deuces.Card(4, "Diamond")
    expect(rulesEngine.isPair(hand)).toBe false
    hand[1] = new deuces.Card(3, "Spade")
    expect(rulesEngine.isPair(hand)).toBe true
  it "can tell if a hand is a straight", ->
    hand = [new deuces.Card(3, "Diamond"), new deuces.Card(4, "Hearts"), new deuces.Card(5, "Club"), new deuces.Card(6, "Spade"), new deuces.Card(7, "Diamond")]
    expect(rulesEngine.isStraight hand).toBe true
    hand[4] = new deuces.Card(5, "Spade")
    expect(rulesEngine.isStraight hand).toBe false
