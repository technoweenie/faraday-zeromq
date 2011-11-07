This is a quick test of Faraday making 3000 requests.

## Faraday with net/http

```ruby
conn = Faraday.new 'http://localhost:4567'
t=Time.now ; 3000.times { conn.get('/hi') } ; Time.now - t
```

* hitting the sinatra/thin app  
  16.807534s

* hitting the node.js http app  
  9.609719s

## Faraday with typhoeus

```ruby
conn = Faraday.new 'http://localhost:4567' do |builder|
  builder.adapter :typhoeus
end
t=Time.now ; 3000.times { conn.get('/hi') } ; Time.now - t
```

* hitting the sinatra/thin app  
  3.894546s

* hitting the node.js http app  
  1.6805s

## Faraday with ZeroMQ

```ruby
require 'ffi-rzmq'
context = ZMQ::Context.new
socket  = context.socket ZMQ::REQ
socket.connect 'tcp://127.0.0.1:5555'
conn = Faraday.new do |builder|
  builder.adapter :zeromq, socket
end
t=Time.now ; 3000.times { conn.get('/hi') } ; Time.now - t
```

* hitting the ruby zeromq server  
  1.514022s

* hitting the node zeromq server  
  1.580222s

* hitting the python zeromq server  
  1.45092s
