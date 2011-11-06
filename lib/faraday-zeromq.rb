require 'yajl'

module Faraday
  class Adapter
    register_lookup_modules :zeromq => :ZeroMQ

    class ZeroMQ < Adapter 
      VERSION = "0.0.1"

      def initialize(app, socket)
        super app
        @socket = socket
      end

      def call(env)
        path = env[:url].path
        if query = env[:url].query
          path << "?#{query}"
        end

        @socket.send_string Yajl.dump([
          env[:method], path, env[:request_headers]]), ZMQ::SNDMORE
        @socket.send_string env[:body]

        @socket.recv_string meta=''
        @socket.recv_string body=''

        status, headers = Yajl.load(meta)

        save_response(env, status.to_i, body, headers)

        @app.call env
      end
    end
  end
end
