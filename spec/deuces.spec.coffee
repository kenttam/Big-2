deuces = require "../deuces2"

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
    oldDeck = _.clone(game.deck)
    game.deck.shuffle()
    expect(_.isEqual(game.deck.cards, oldDeck.cards)).toBe false

describe "The Player", ->
  it "is not null", ->
    expect(deuces.Player?).toBe true

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
    game = new deuces.Game()
    game.addPlayer 1
    expect(game.players.length).toBe 0
