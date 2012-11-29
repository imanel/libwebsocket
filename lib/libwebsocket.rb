require 'websocket'
# Client/server WebSocket message and frame parser/constructor. This module does
# not provide a WebSocket server or client, but is made for using in http servers
# or clients to provide WebSocket support.
module LibWebSocket

  autoload :Frame,            "#{File.dirname(__FILE__)}/libwebsocket/frame"
  autoload :OpeningHandshake, "#{File.dirname(__FILE__)}/libwebsocket/opening_handshake"
  autoload :URL,              "#{File.dirname(__FILE__)}/libwebsocket/url"

end
