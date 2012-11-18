module LibWebSocket
  # This is a base class for LibWebSocket::OpeningHandshake::Client and LibWebSocket::OpeningHandshake::Server.
  class OpeningHandshake

    autoload :Client, "#{File.dirname(__FILE__)}/opening_handshake/client"
    autoload :Server, "#{File.dirname(__FILE__)}/opening_handshake/server"

    def secure
      @controller.secure
    end

    def error
      @controller.error
    end

    def parse(opts)
      @controller << opts
      return false if @controller.error
      return true
    end

    def done?
      @controller.finished?
    end

    def to_s
      @controller.to_s
    end

    def controller
      @controller
    end

  end
end
