module Faraday
  class Adapter
    register_middleware :zeromq => :ZeroMQ

    class ZeroMQ < Adapter
      VERSION = "0.0.1"

      def initialize(app, socket, serializer)
        super app
        @socket = socket
        @serializer = serializer
      end

      def call(env)
        path = env[:url].path
        if query = env[:url].query
          query = Faraday::Utils.parse_query(query)
        end

        meta = [env[:method], path, query, env[:request_headers]]
        @socket.send_string(@serializer.dump(meta), ZMQ::SNDMORE)
        @socket.send_string(@serializer.dump(env[:body]))

        @socket.recv_string(meta='')
        @socket.recv_string(body='')

        status, headers = @serializer.load(meta)

        save_response(env, status.to_i, @serializer.load(body), headers)

        @app.call env
      end
    end
  end
end

