ScoreEngine = require "../models/scoreEngine"
Player = require "../models/player"

describe "The Score Engine", ->
  scoreEngine = new ScoreEngine()
  it "is not null", ->
    expect(ScoreEngine?).toBe true
  describe "with a single player", ->
    player = new Player()
    it "can score losing with 1 card", ->
      player.hand = [1]
      scoreEngine.scoreSinglePlayer(player)
      expect(player.scoreForTheRound).toBe -1
    it "can score losing with 8 cards, use double multiplier", ->
      player.hand = [1..8]
      scoreEngine.scoreSinglePlayer(player)
      expect(player.scoreForTheRound).toBe -16
    it "can score losing with 10 cards to use triple multiplier", ->
      player.hand = [1..10]
      scoreEngine.scoreSinglePlayer(player)
      expect(player.scoreForTheRound).toBe -30
    it "can score losing with 13 cards to use quadriple mulitplier", ->
      player.hand = [1..13]
      scoreEngine.scoreSinglePlayer player
      expect(player.scoreForTheRound).toBe -52
    it "can score losing with 13 cards to use quadriple mulitplier", ->
  
