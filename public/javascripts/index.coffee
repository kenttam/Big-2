window.RoomController = ($scope, socket) ->
  $scope.requestRoom = ->
    socket.emit('room', $scope.roomName)
    console.log("requested " + $scope.roomName)

window.GameController = ($scope, socket) ->
  socket.on "joined", (data) ->
    console.log data
    $scope.players = data.players
  
