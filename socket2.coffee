net = require "net"
Server = net.Server
Stream = net.Stream
_ = require "underscore"
root._ = _
require "zextra/util.js"

hostname = "mcode.the.tl"
port = 9999

location = "/"


allDigits = (str) ->
  str.replace /\D/g, ""

numberOfSpaces = (str) ->
  str.replace(/[^ ]/g, "").length

server = new Server
server.on 'connection', (stream) ->
  stream.on "data", (str) ->
    str = str.toString()
    console.log str.toString()
    if _.startsWith str, "GET / HTTP/1.1\r\nUpgrade: WebSocket\r\nConnection: Upgrade"
      console.log "web socket here we come"
      
      req = str.split "\r\n"
      for line in req
        if _(line).startsWith "Sec-WebSocket-Key1"
          key1 = _.s line, "Sec-WebSocket-Key1".length + 1
        if _(line).startsWith "Sec-WebSocket-Key2"
          key2 = _.s line, "Sec-WebSocket-Key2".length + 1

      console.log "key 1 is #{key1}"
      console.log "key 2 is #{key2}"

      #older code sir, but it doesn't checkout anymore
      #stream.write "HTTP/1.1 101 Web Socket Protocol Handshake\r\nUpgrade: WebSocket\r\nConnection: Upgrade\r\nWebSocket-Origin: http://#{hostname}:#{port}\r\nWebSocket-Location: ws://#{hostname}:#{port}#{location}\r\n\r\n"      
    else if _.startsWith str, "GET"
      content = "yo world"
      stream.write "HTTP/1.1 200 OK\r\n" +
        "Connection: close\r\n" +
        "Content-Type: text/html\r\n" +
        "Content-Length: #{content.length}\r\n\r\n" +
        content
server.listen port
#server = net.createServer (c) ->
#  console.log "testerson"
#server.listen 1001

