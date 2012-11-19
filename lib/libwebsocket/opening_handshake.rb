require 'forwardable'
module LibWebSocket
  # This is a base class for LibWebSocket::OpeningHandshake::Client and LibWebSocket::OpeningHandshake::Server.
  class OpeningHandshake

    autoload :Client, "#{File.dirname(__FILE__)}/opening_handshake/client"
    autoload :Server, "#{File.dirname(__FILE__)}/opening_handshake/server"

    extend Forwardable

    def_delegator :controller, :secure
    def_delegator :controller, :error
    def_delegator :controller, :to_s
    def_delegator :controller, :finished?, :done?

    def controller
      @controller
    end

    def parse(opts)
      @controller << opts
      return false if @controller.error
      return true
    end

  end
end
