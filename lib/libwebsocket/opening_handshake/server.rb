module LibWebSocket
  class OpeningHandshake
    # Construct or parse a server WebSocket handshake. This module is written for
    # convenience, since using request and response directly requires the same code
    # again and again.
    #
    # SYNOPSIS
    #
    #   h = LibWebSocket::OpeningHandshake::Server.new
    #
    #   # Parse client request
    #   h.parse \<<EOF
    #   GET /demo HTTP/1.1
    #   Upgrade: WebSocket
    #   Connection: Upgrade
    #   Host: example.com
    #   Origin: http://example.com
    #   Sec-WebSocket-Key1: 18x 6]8vM;54 *(5:  {   U1]8  z [  8
    #   Sec-WebSocket-Key2: 1_ tx7X d  <  nw  334J702) 7]o}` 0
    #
    #   Tm[K T2u
    #   EOF
    #
    #   h.error  # Check if there were any errors
    #   h.idone? # Returns true
    #
    #   # Create response
    #   h.to_s # HTTP/1.1 101 WebSocket Protocol Handshake
    #          # Upgrade: WebSocket
    #          # Connection: Upgrade
    #          # Sec-WebSocket-Origin: http://example.com
    #          # Sec-WebSocket-Location: ws://example.com/demo
    #          #
    #          # fQJ,fN/4F4!~K~MH
    class Server < OpeningHandshake

      def initialize(hash = {})
        @controller = ::WebSocket::Handshake::Server.new({:version => 76}.merge(hash))
      end

    end
  end
end
