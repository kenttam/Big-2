express = require 'express'
app = express()

app.get '/', (req, res) ->
  body = "Hello world"
  res.setHeader "Content-Type", "text/plain"
  res.setHeader "Content-Length", body.length
  res.end(body)

app.listen 3000
