socket = io.connect("http://localhost:3000")

room = "helloworld"

socket.on "message", (data) ->
  console.log data
  socket.emit "send", { my: "data" }

window.RoomController = ($scope) ->
  $scope.requestRoom = ->
    socket.emit('room', $scope.roomName)
    console.log("requested " + $scope.roomName)

window.GameController = ($scope) ->
  socket.on "player:joined", (data) ->
    console.log(data)
  
