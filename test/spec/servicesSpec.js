// Generated by CoffeeScript 1.6.3
(function() {
  describe("Services", function() {
    beforeEach(module("deuces"));
    return describe("playerMap", function() {
      var playerMap;
      playerMap = null;
      beforeEach(function() {
        return inject(function($injector) {
          return playerMap = $injector.get("playerMap");
        });
      });
      return it("should be able to map players to their seats", function() {
        var mappedPlayers, playerIndex, players;
        players = [{}, {}, {}, {}];
        playerIndex = 2;
        mappedPlayers = playerMap(playerIndex, players);
        expect(mappedPlayers[3].seat).toBe("west");
        expect(mappedPlayers[0].seat).toBe("north");
        return expect(mappedPlayers[1].seat).toBe("east");
      });
    });
  });

}).call(this);
