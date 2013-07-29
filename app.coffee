express = require 'express'
stylus = require "stylus"
nib = require "nib"
app = express()
server = require('http').createServer(app)
port = process.env.PORT || 3000
server.listen(port)
io = require("socket.io").listen(server)
Player = require "./models/player"
Game = require "./models/game"
Card = require "./models/card"
_ = require "./public/javascripts/lib/underscore-min"


compile = (str, path) ->
  return stylus(str)
    .set("filename", path)
    .use(nib())

app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.logger 'dev')
app.use(stylus.middleware(
  src : __dirname + '/public'
  compile : compile
))
app.use(express.static(__dirname + '/public'))

app.get '/', (req, res) ->
  res.render('index',
    title: 'Home'
  )

guestNumber = 1
currentGame = {}
nickNames = {}
namesUsed = []
players = {}
games = {}

io.sockets.on('connection', (socket) ->
  guestNumber = assignGuestName(socket, guestNumber, nickNames, namesUsed)

  socket.on "room", (room)->
    joinRoom(socket, room)
    
  socket.on "startGame", ->
    if currentGame[socket.id].gameOver
      whoseTurn = currentGame[socket.id].start()
      currentRoom = currentGame[socket.id].room
      io.sockets.in(currentRoom).emit("update:turn", whoseTurn)
      for socket in io.sockets.clients(currentRoom)
        socket.emit("hand", players[socket.id].hand)

  socket.on "startTestGame", ->
    games["test"] = null
    joinRoom(socket, "test")
    currentGame[socket.id].addPlayer new Player(1, "test2")
    currentGame[socket.id].addPlayer new Player(1, "test3")
    currentGame[socket.id].addPlayer new Player(1, "test4")
    currentGame[socket.id].start()
    currentGame[socket.id].whoseTurn = 0
    currentGame[socket.id].players[0].hand[0] = new Card(3, "Diamond")
    socket.emit("hand", players[socket.id].hand)

  socket.on "play:cards", (data) ->
    cards = _.map data, (card) ->
      new Card(card.rank, card.suit)
    currentGame[socket.id].processTurn(socket.id, cards)
    socket.emit("hand", players[socket.id].hand)
    currentPlayers = _.map(currentGame[socket.id].players, (player) ->
      _.omit(player, ["game", "hand"])
    )
    if currentGame[socket.id].gameOver
      io.sockets.in(currentGame[socket.id].room).emit("gameOver", { center: currentGame[socket.id].cardsInCenter, players: currentPlayers, whoseTurn: currentGame[socket.id].whoseTurn})
    else
      io.sockets.in(currentGame[socket.id].room).emit("update:game", { center: currentGame[socket.id].cardsInCenter, players: currentPlayers, whoseTurn: currentGame[socket.id].whoseTurn})

  socket.on "pass", ->
    currentGame[socket.id].playerPassed(socket.id)
    currentPlayers = _.map(currentGame[socket.id].players, (player) ->
      _.omit(player, ["game", "hand"])
    )
    io.sockets.in(currentGame[socket.id].room).emit("update:game", { center: currentGame[socket.id].cardsInCenter, players: currentPlayers, whoseTurn: currentGame[socket.id].whoseTurn})

)



assignGuestName = (socket, guestNumber, nickNames, namesUsed) ->
  name = "Guest" + guestNumber
  nickNames[socket.id] = name
  players[socket.id] = new Player(socket.id, name)
  socket.emit 'nameResult',
    success: true
    name: name
  namesUsed.push name
  return guestNumber + 1

joinRoom = (socket, room) ->
  socket.join(room)
  unless games[room]?
    games[room] = new Game(room)
  currentGame[socket.id] = games[room]
  playerIndex = currentGame[socket.id].addPlayer(players[socket.id])
  socket.emit("joined:game", {room: room, playerIndex: playerIndex})
  io.sockets.in(room).emit('players:updated', {
    players: _.map(currentGame[socket.id].players, (player) ->
      _.omit(player, ["game", "hand"])
    )
  })
