Card = require "../models/card"
Deck = require "../models/deck"
Player = require "../models/player"
Game = require "../models/game"
_ = require "../public/javascripts/lib/underscore-min"

game = new Game()

describe "The Deck", ->
  it "is not null", ->
    expect(typeof(game.deck)).not.toBe 'undefined'

  it "has 52 cards", ->
    expect(game.deck.cards.length).toBe 52

  it "can be shuffled", ->
    newDeck = new Deck()
    game.deck.shuffle()
    expect(_.isEqual(game.deck.cards, newDeck.cards)).toBe false

describe "The Player", ->
  it "is not null", ->
    expect(Player?).toBe true

describe "The Card", ->
  it "can return numerical rank", ->
    card = new Card("3", "Diamond")
    expect(card.numericalRank()).toBe 0

describe "The Game", ->
  game = new Game()
  it "is not null", ->
    expect(Game?).toBe true
  it "has a deck", ->
    expect(game.deck?).toBe true
  it "has players", ->
    expect(game.players?).toBe true
  it "can add players", ->
    player = new Player()
    game.addPlayer player
    expect(game.players.length).toBe 1
    expect(player.game).toBe game
  it "should not add more than 4 players", ->
    player2 = new Player()
    player3 = new Player()
    player4 = new Player()
    game.addPlayer player2
    game.addPlayer player3
    game.addPlayer player4
    expect(game.players.length).toBe 4
    player5 = new Player()
    game.addPlayer player5
    expect(game.players.length).toBe 4
  it "should not add something that's not a player", ->
    game2 = new Game()
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
    game.players[3].hand = [new Card(3, "Diamond")]
    index = game.findPlayerIndexWithDiamondThree()
    expect(index).toBe 3
  it "can process the first turn", ->
    game.whoseTurn = 0
    game.players[0] = new Player()
    game.players[0].id = 1
    game.players[0].hand = [new Card(3, "Spade"), new Card(3, "Diamond"), new Card(4, "Diamond")]
    game.history = []
    game.cardsInCenter = []
    expect(game.processTurn(1, [new Card(3, "Spade"), new Card(3, "Diamond")])).toBe true
    game.history = []
    game.cardsInCenter = []
    game.whoseTurn = 0
    expect(game.processTurn(1, [new Card(4, "Diamond")])).toBe false
  it "can process a turn with a single card", ->
    game.history = [new Card(3, "Diamond")]
    game.cardsInCenter = [new Card(3, "Diamond")]
    game.whoseTurn = 0
    game.players[0].hand = [new Card(4, "Spade"), new Card(4, "Diamond")]
    expect(game.processTurn(1, [new Card(4, "Diamond"), new Card(4, "Spade")])).toBe false
    game.history = [new Card(3, "Diamond")]
    game.cardsInCenter = [new Card(3, "Diamond")]
    game.whoseTurn = 0
    expect(game.processTurn(1, [new Card(4, "Diamond")])).toBe true
  it "can process turn with pairs", ->
    game.cardsInCenter = [new Card(3, "Diamon"), new Card(3, "Heart")]
    game.whoseTurn = 0
    game.players[0].hand = [new Card(4, "Spade"), new Card(4, "Diamond")]
    expect(game.processTurn(1, [new Card(4, "Diamond")])).toBe false
    game.cardsInCenter = [new Card(3, "Diamon"), new Card(3, "Heart")]
    game.whoseTurn = 0
    game.players[0].hand = [new Card(4, "Spade"), new Card(4, "Diamond")]
    expect(game.processTurn(1, [new Card(4, "Diamond"), new Card(4, "Spade")])).toBe true
  it "can process turn with five cards play", ->
    game.cardsInCenter = [new Card(3, "Diamond"), new Card(3, "Heart"), new Card(3, "Spade"), new Card(4, "Diamond"), new Card(4, "Spade")]
    game.whoseTurn = 0
    game.players[0].hand = [new Card(4, "Diamond"), new Card(4, "Spade"), new Card(4, "Club"), new Card(4, "Heart"), new Card(7, "Club")]
    expect(game.processTurn(1, [new Card(4, "Diamond")])).toBe false
    game.whoseTurn = 0
    expect(game.processTurn(1, [new Card(4, "Diamond"), new Card(4, "Spade"), new Card(4, "Club"), new Card(4, "Heart"), new Card(7, "Club")])).toBe true
  it "can process 3 players passed", ->
    player1 = new Player()
    player1.id = 1
    player2 = new Player()
    player2.id = 2
    player3 = new Player()
    player3.id = 3
    player4 = new Player()
    player4.id = 4
    game.players = [player1, player2, player3, player4]
    game.whoseTurn = 0
    game.cardsInCenter = [new Card(3, "Diamond"), new Card(3, "Heart"), new Card(3, "Spade"), new Card(4, "Diamond"), new Card(4, "Spade")]
    game.playerPassed(1)
    game.playerPassed(2)
    game.players[2].hand = [new Card(4, "Hearts")]
    expect(game.processTurn(3, [new Card(4, "Hearts")])).toBe false
    game.playerPassed(3)
    game.players[3].hand = [new Card(4, "Hearts")]
    expect(game.processTurn(4, [new Card(4, "Hearts")])).toBe true
    expect(game.whoseTurn).toBe 0
    expect(game.playersPassed).toBe 0
  it "can tell if a player has a card", ->
    game.whoseTurn = 0
    game.players[0].hand = [new Card(3, "Diamond")]
    expect(game.currentPlayerHasCards([new Card(3, "Diamond")])).toBe true
    expect(game.currentPlayerHasCards([new Card(4, "Diamond")])).toBe false
  it "can remove cards from a player's hand after it has been played", ->
    game.whoseTurn = 0
    game.players[0].hand = [new Card(3, "Spade")]
    game.cardsInCenter = []
    expect(game.processTurn(1, [new Card(3, "Spade")])).toBe true
    expect(game.players[0].hand.length).toBe 0
