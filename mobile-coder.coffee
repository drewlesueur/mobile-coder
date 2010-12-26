$(document).ready () ->
 
 ws = new WebSocket "ws://mcode.the.tl:9999/"
 ws.onopen = () ->
   console.log "open"
   ws.send "hahaha"
 ws.onmessage = (e) ->
   console.log e.data
 ws.onclose = (e) ->
   console.log "closed!!"
 ws.onerror = (e) ->
    console.log "error"
# socket = new io.Socket("ws://mcode.the.tl:8008/")
# socket.connect()
# socket.send "test"

