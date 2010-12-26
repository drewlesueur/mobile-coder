net = require "net"
Server = net.Server
Streami = net.Stream
Crypto = require "crypto"
_ = require "underscore"
root._ = _
require "zextra/util.js"

hostname = "mcode.the.tl"
port = 9999

location = "/"


allDigits = (str) ->
  str.replace(/\D/g, "") - 0

numberOfSpaces = (str) ->
  str.replace(/[^ ]/g, "").length

`
function pack(num) {
var result = '';
result += String.fromCharCode(num >> 24 & 0xFF);
result += String.fromCharCode(num >> 16 & 0xFF);
result += String.fromCharCode(num >> 8 & 0xFF);
result += String.fromCharCode(num & 0xFF);
return result;
};
`


write = (stream, data) ->
  stream.write "\x00", "binary"
  stream.write data, "utf8"
  stream.write "\xff", "binary"

close = (stream) ->
  stream.write "" #right?

server = new Server
server.on 'connection', (stream) ->
  stream.on "data", (str) ->
    str = str.toString()
    console.log str.toString()
    if _.startsWith str, "GET / HTTP/1.1\r\nUpgrade: WebSocket\r\nConnection: Upgrade"
      console.log "web socket here we come"
      
      req = str.split "\r\n"
      for line in req
        if _.startsWith line, "Origin:"
          origin = _.s line, "Origin:".length + 1
        if _(line).startsWith "Sec-WebSocket-Key1:"
          key1 = _.s line, "Sec-WebSocket-Key1:".length + 1
        if _(line).startsWith "Sec-WebSocket-Key2:"
          key2 = _.s line, "Sec-WebSocket-Key2:".length + 1

      console.log "key 1 is #{key1}"
      console.log "key 2 is #{key2}"

      num1 = allDigits key1
      num2 = allDigits key2

      spaces1 = numberOfSpaces key1
      spaces2 = numberOfSpaces key2

      final1 = pack(parseInt(num1 / spaces1))
      final2 = pack(parseInt(num2 / spaces2))
      hash = Crypto.createHash "md5"
      hash.update final1
      hash.update final2
      hash.update _.s(req, -1, 1).toString "binary"

      ret =  "" +
        "HTTP/1.1 101 WebSocket Protocol Handshake\r\n" +
        "Upgrade: WebSocket\r\n" +
        "Connection: Upgrade\r\n" +
        "Sec-WebSocket-Origin: "+origin+"\r\n" +
        "Sec-WebSocket-Location: ws://#{hostname}:#{port}#{location}" +
        "\r\n\r\n" +
        hash.digest("binary")
      
      console.log()
      console.log ret
      stream.write ret, "binary"
     

             
      
      
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

