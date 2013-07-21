socket = io.connect("http://localhost:3000")

room = "helloworld"
socket.on "connect", ->
  socket.emit('room', room)

socket.on "message", (data) ->
  console.log data
  socket.emit "send", { my: "data" }
