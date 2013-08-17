window.deucesApp = angular.module('deuces', [], ($provide) ->
  $provide.factory 'socket', ($rootScope) ->
    socket = io.connect()
    return {
      on: (eventName, callback) ->
        socket.on(eventName, ->
          args = arguments
          $rootScope.$apply( ->
            callback.apply(socket, args)
          )
        )
      emit: (eventName, data, callback) ->
        socket.emit(eventName, data, ->
          args = arguments
          $rootScope.$apply( ->
            if (callback)
              callback.apply(socket, args)
          )
        )
    }
  $provide.factory 'playerMap', ($rootScope) ->
    return (playerIndex, players) ->
      directions = ["west", "north", "east"]
      for x in [0...3]
        currentPlayerIndex = playerIndex + x
        unless currentPlayerIndex > 3
          players[currentPlayerIndex].seat = directions[x]
        else
          players[currentPlayerIndex-4].seat = directions[x]
      return players
)

