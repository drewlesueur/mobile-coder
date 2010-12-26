(function() {
  $(document).ready(function() {
    window.ws = new WebSocket("ws://mcode.the.tl:9999/");
    ws.onopen = function() {
      console.log("open");
      return ws.send("hahaha");
    };
    ws.onmessage = function(e) {
      return console.log(e.data);
    };
    ws.onclose = function(e) {
      return console.log("closed!!");
    };
    return ws.onerror = function(e) {
      return console.log("error");
    };
  });
}).call(this);
