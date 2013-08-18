describe "Services", ->
  beforeEach(angular.module("deuces"))
  describe "playerMap", ->
    playerMap = null
    beforeEach ->
      inject ($injector) ->
        playerMap = $injector.get "playerMap"
    it "should be able to map players to their seats", ->
      players = [{}, {}, {}, {}]
      playerIndex = 2
      mappedPlayers = playerMap(playerIndex, players)
      expect(mappedPlayers[3].seat).toBe "west"
      expect(mappedPlayers[0].seat).toBe "north"
      expect(mappedPlayers[1].seat).toBe "east"
