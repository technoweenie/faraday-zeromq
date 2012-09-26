require 'msgpack'

module Faraday
  class Adapter
    register_middleware :zeromq => :ZeroMQ

    class ZeroMQ < Adapter
      VERSION = "0.0.1"

      def initialize(app, socket)
        super app
        @socket = socket
      end

      def call(env)
        path = env[:url].path
        if query = env[:url].query
          query = Faraday::Utils.parse_query(query)
        end

        meta = [env[:method], path, query, env[:request_headers]].to_msgpack
        @socket.send_string(meta, ZMQ::SNDMORE)
        @socket.send_string(env[:body].to_msgpack)

        @socket.recv_string(meta='')
        @socket.recv_string(body='')

        status, headers = MessagePack.unpack(meta)

        save_response(env, status.to_i, MessagePack.unpack(body), headers)

        @app.call env
      end
    end
  end
end

