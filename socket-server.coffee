http = require "http"
io = require "socket.io"
server = http.createServer (req, res) ->
  res.writeHeader 200,
    "Content-Type" : "text/html"
  res.end "<h1>Hello World</h1>"

server.listen 8008
socket = io.listen server
socket.on "connection", (client) ->
  info = {}
  client.on "message", (message) ->
    client.send "hi" + message    
