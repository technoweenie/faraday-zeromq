require 'yajl'
require 'ffi-rzmq'

context = ZMQ::Context.new
socket  = context.socket ZMQ::REP
socket.bind 'tcp://127.0.0.1:5555'

loop do
  socket.recv_string meta=''
  socket.recv_string body=''

  method, path, headers = Yajl.load(meta)

  socket.send_string Yajl.dump([
    200, {'Content-Length' => 2}]), ZMQ::SNDMORE
  socket.send_string 'ok'
end

