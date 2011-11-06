import json
import zmq

context  = zmq.Context()
socket   = context.socket(zmq.REP)
socket.bind('tcp://127.0.0.1:5555')

while True:
    meta = socket.recv()
    body = socket.recv()

    (method, path, headers) = json.loads(meta)

    socket.send(json.dumps((200, {"Content-Type": 2})), zmq.SNDMORE)
    socket.send(body)
    
