window.RoomController = ($scope, socket) ->
  $scope.inRoom = false
  $scope.requestRoom = ->
    socket.emit('room', $scope.roomName)
  $scope.startTestGame = ->
    socket.emit('startTestGame')
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
  $scope.suitSpecialCharacter = (suit) ->
    if suit == "Diamond"
      return "&diams;"
    else
      return "&" + suit.toLowerCase() + "s;"
  $scope.playCards = ->
    socket.emit('play:cards', $scope.selectedCards())
  $scope.selectedCards = ->
    _.filter $scope.hand, (card) ->
      return card.selected
  $scope.pass = ->
    socket.emit('pass')
  socket.on "update:game", (data) ->
    $scope.players = data.players
    $scope.center = data.center
    $scope.whoseTurn = data.whoseTurn
  socket.on "gameOver", (data) ->
    $scope.players = data.players
    $scope.gameOver = true
    $scope.winnerIndex = data.whoseTurn

   
