express = require 'express'
stylus = require "stylus"
nib = require "nib"
app = express()

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
  body = "Hello world"
  res.setHeader "Content-Type", "text/plain"
  res.setHeader "Content-Length", body.length
  res.end(body)

app.listen 3000
