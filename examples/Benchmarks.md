This is a quick test of Faraday making 3000 requests.

Faraday with net/http, hitting the sinatra/thin app  
16.807534s

Faraday with net/http, hitting the node.js http app  
9.609719s

Faraday with typhoeus, hitting the sinatra/thin app  
3.894546s

Faraday with typhoeus, hitting the node.js http app  
1.6805s

Faraday with zeromq, hitting the ruby zeromq server  
1.514022s

Faraday with zeromq, hitting the node zeromq server  
1.580222s

Faraday with zeromq, hitting the python zeromq server  
1.45092s
