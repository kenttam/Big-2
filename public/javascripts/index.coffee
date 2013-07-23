window.RoomController = ($scope, socket) ->
  $scope.inRoom = false
  $scope.requestRoom = ->
    socket.emit('room', $scope.roomName)
  socket.on "joined:game", (data) ->
    $scope.roomName = data.room
    $scope.inRoom = true
  socket.on "nameResult", (data) ->
    if data.success
      $scope.playerName = data.name

window.GameController = ($scope, socket) ->
  socket.on "players:updated", (data) ->
    $scope.players = data.players
  $scope.startGame = ->
    socket.emit('startGame')
  socket.on "joined:game", (data) ->
    $scope.playerIndex = data.playerIndex
  socket.on "update:turn", (data) ->
    $scope.whoseTurn = data
  socket.on "hand", (data) ->
    $scope.hand = data
