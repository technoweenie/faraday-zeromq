require 'test/unit'
require 'faraday'
require File.expand_path("../../lib/faraday-zeromq", __FILE__)

module ZMQ
  SNDMORE = 1
end

class AdapterTest < Test::Unit::TestCase
  class FakeSocket
    attr_reader :sent

    def initialize(responses)
      @sent      = []
      @responses = responses.empty? ? [[200, {}], :ok] : responses
      @responses.map!(&:to_msgpack)
    end

    def send_string(str, flags = 0)
      @sent << [str, flags]
    end

    def recv_string(s)
      s.replace @responses.shift
    end
  end

  def test_handle_basic_response
    conn = build_connection
    res = conn.get '/'
    assert_equal 200,  res.status
    assert_equal 'ok', res.body
  end

  def test_handle_custom_response_headers
    socket = build_socket([201, {'Content-Length' => 3}], 'ok!')
    res = build_connection(socket).get '/'
    assert_equal 201,   res.status
    assert_equal 3,     res.headers['content-length']
    assert_equal 'ok!', res.body
  end

  def test_send_request_headers
    socket = build_socket([200, {}], 'ok')
    conn = build_connection socket

    res = conn.post "/a?b=c" do |req|
      req.body = 'body'
      req.headers['Content-Type'] = 'text/plain'
    end

    params, flag = socket.sent.shift
    params = MessagePack.unpack params

    assert_equal 'post',       params.shift
    assert_equal '/a?b=c',     params.shift
    assert_equal 'text/plain', params.shift['Content-Type']
    assert_equal 1, flag
    assert_equal ['body'.to_msgpack, 0], socket.sent.shift

    assert_equal 200, res.status
  end

  def build_socket(*responses)
    FakeSocket.new responses
  end

  def build_connection(socket = build_socket)
    Faraday.new do |builder|
      builder.adapter :zeromq, socket
    end
  end
end
