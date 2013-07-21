express = require 'express'
stylus = require "stylus"
nib = require "nib"
app = express()
server = require('http').createServer(app)
server.listen(3000)
io = require("socket.io").listen(server)

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


io.sockets.on('connection', (socket) ->
  socket.emit 'message', { message: "Welcome to Big 2" }
  socket.on "room", (room)->
    socket.join(room)
)

room = "helloworld"
io.sockets.in(room).emit("message", "what's up")
