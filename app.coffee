express = require 'express'
stylus = require "stylus"
nib = require "nib"
app = express()
server = require('http').createServer(app)
server.listen(3000)
io = require("socket.io").listen(server)
Player = require "./models/Player"
Game = require "./models/Game"
_ = require "./lib/underscore-min"


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
currentRoom = {}
currentGame = {}
nickNames = {}
namesUsed = []
rooms = []
players = {}
games = {}

io.sockets.on('connection', (socket) ->
  guestNumber = assignGuestName(socket, guestNumber, nickNames, namesUsed)
  socket.on "room", (room)->
    joinRoom(socket, room)
)

assignGuestName = (socket, guestNumber, nickNames, namesUsed) ->
  name = "Guest" + guestNumber
  nickNames[socket.id] = name
  players[socket.id] = new Player(socket.id, name)
  console.log players[socket.id] instanceof Player
  socket.emit 'nameResult',
    success: true
    name: name
  namesUsed.push name
  return guestNumber + 1

joinRoom = (socket, room) ->
  socket.join(room)
  currentRoom[socket.id] = room
  unless games[room]?
    games[room] = new Game(room)
  currentGame[socket.id] = games[room]
  currentGame[socket.id].addPlayer(players[socket.id])
  socket.emit('joinResult', {room: room})
  socket.broadcast.to(room).emit('message', {
    text: nickNames[socket.id] + ' has joined ' + room + "."
  })
  socket.broadcast.to(room).emit('player:joined', {
    players: _.map(currentGame[socket.id].players, (player) ->
      _.omit(player, "game")
    )
  })
  usersInRoom = io.sockets.clients(room)
  if usersInRoom.length > 1
    usersInRoomSummary = "Users currently in " + room + ": "
    for user, index in usersInRoom
      userSocketId = user.id
      unless userSocketId == socket.id
        if index > 0
          usersInRoomSummary += ", "
        usersInRoomSummary += nickNames[userSocketId]
  usersInRoomSummary += "."
  socket.emit("message", {text: usersInRoomSummary})
