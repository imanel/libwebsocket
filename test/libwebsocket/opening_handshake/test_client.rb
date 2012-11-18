require 'test_helper'

class TestServerOpeningHandshake < Test::Unit::TestCase

  def test_to_s
    h = LibWebSocket::OpeningHandshake::Client.new(:url => 'ws://example.com/demo?param=true&another=hello')

    assert_equal h.to_s, "GET /demo?param=true&another=hello HTTP/1.1\x0d\x0a" +
      "Upgrade: WebSocket\x0d\x0a" +
      "Connection: Upgrade\x0d\x0a" +
      "Host: example.com\x0d\x0a" +
      "Sec-WebSocket-Key1: #{h.controller.send(:key1)}\x0d\x0a" +
      "Sec-WebSocket-Key2: #{h.controller.send(:key2)}\x0d\x0a" +
      "\x0d\x0a#{h.controller.send(:key3)}"

    h = LibWebSocket::OpeningHandshake::Client.new(:url => 'ws://example.com')

    assert_equal h.to_s, "GET / HTTP/1.1\x0d\x0a" +
      "Upgrade: WebSocket\x0d\x0a" +
      "Connection: Upgrade\x0d\x0a" +
      "Host: example.com\x0d\x0a" +
      "Sec-WebSocket-Key1: #{h.controller.send(:key1)}\x0d\x0a" +
      "Sec-WebSocket-Key2: #{h.controller.send(:key2)}\x0d\x0a" +
      "\x0d\x0a#{h.controller.send(:key3)}"

    assert !h.done?
    assert h.parse('')

    assert h.parse("HTTP/1.1 101 WebSocket Protocol Handshake\x0d\x0a" +
          "Upgrade: WebSocket\x0d\x0a" +
          "Connection: Upgrade\x0d\x0a" +
          "Sec-WebSocket-Origin: http://example.com\x0d\x0a" +
          "Sec-WebSocket-Location: ws://example.com/demo\x0d\x0a" +
          "\x0d\x0a" +
          "fQJ,fN/4F4!~K~MH")
    assert !h.error
    assert h.done?

    message = "HTTP/1.1 101 WebSocket Protocol Handshake\x0d\x0a"
    h = LibWebSocket::OpeningHandshake::Client.new(:url => 'ws://example.com')
    assert h.parse(message)
    assert !h.error

    h = LibWebSocket::OpeningHandshake::Client.new(:url => "ws://example.com")
    assert !h.parse("HTTP/1.0 foo bar\x0d\x0a\x0d\x0a")
    assert_equal :invalid_header, h.error
  end

end
