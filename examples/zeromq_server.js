zmq     = require('zeromq')
socket  = zmq.createSocket('rep')
socket.bindSync('tcp://127.0.0.1:5555')

socket.on('message', function(meta, body) {
  var args = JSON.parse(meta)
  var method  = args[0]
  var path    = args[1]
  var headers = args[2]

  socket.send(JSON.stringify([
    200, {'Content-Type': 2}]), "ok")
})
