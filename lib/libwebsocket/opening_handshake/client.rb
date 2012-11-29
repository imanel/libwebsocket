module LibWebSocket
  class OpeningHandshake
    # Construct or parse a client WebSocket handshake. This module is written for
    # convenience, since using request and response directly requires the same code
    # again and again.
    #
    # SYNOPSIS
    #
    #   h = LibWebSocket::OpeningHandshake::Client.new(:url => 'ws://example.com')
    #
    #   # Create request
    #   h.to_s # GET /demo HTTP/1.1
    #          # Upgrade: WebSocket
    #          # Connection: Upgrade
    #          # Host: example.com
    #          # Origin: http://example.com
    #          # Sec-WebSocket-Key1: 18x 6]8vM;54 *(5:  {   U1]8  z [  8
    #          # Sec-WebSocket-Key2: 1_ tx7X d  <  nw  334J702) 7]o}` 0
    #          #
    #          # Tm[K T2u
    #
    #   # Parse server response
    #   h.parse \<<EOF
    #   HTTP/1.1 101 WebSocket Protocol Handshake
    #   Upgrade: WebSocket
    #   Connection: Upgrade
    #   Sec-WebSocket-Origin: http://example.com
    #   Sec-WebSocket-Location: ws://example.com/demo
    #
    #   fQJ,fN/4F4!~K~MH
    #   EOF
    #
    #   h.error # Check if there were any errors
    #   h.done? # Returns true
    class Client < OpeningHandshake

      def_delegator :controller, :uri

      def initialize(hash = {})
        @controller = ::WebSocket::Handshake::Client.new({:version => 76}.merge(hash))
      end

      def url
        lws_url = LibWebSocket::URL.new
        lws_url.parse(uri)
        lws_url
      end

    end
  end
end
