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
  describe "the whole game", ->
    player1 = new Player()
    player1.hand = []
    player2 = new Player()
    player2.hand = [1..9]
    player3 = new Player()
    player3.hand = [1..12]
    player4 = new Player()
    player4.hand = [1..2]
    players = [player1, player2, player3, player4]
    it "can score the losing players", ->
      expect(scoreEngine.scoreLosingPlayers(players)).toBe(-2 + -18 + -36 + 0)
      expect(player4.scoreForTheRound).toBe -2
      expect(player2.scoreForTheRound).toBe -18
      expect(player3.scoreForTheRound).toBe -36
    it "can score the winning player", ->
      scoreEngine.scoreGame(players)
      expect(player1.scoreForTheRound).toBe(2 + 18 + 36)
    
