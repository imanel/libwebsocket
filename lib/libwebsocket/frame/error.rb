module LibWebSocket
  class Frame

    # Generic close error command for frame. Should not be called directly - use one of subclasses.
    # This should be catched and responded to according to clean_close? and status.
    class Error < LibWebSocket::Error

      # Should close frame be sent before closing?
      # If so then status code should be used to build it.
      def clean_close?
        true
      end

      # Status code for closing frame.
      def status_code
        500 # This should not be called directly
      end

      # 1000 indicates a normal closure, meaning whatever purpose the
      # connection was established for has been fulfilled.
      class NormalClosure < Error
        def status_code; 1000; end
      end

      # 1001 indicates that an endpoint is "going away", such as a server
      # going down, or a browser having navigated away from a page.
      class GoingAway < Error
        def status_code; 1001; end
      end

      # 1002 indicates that an endpoint is terminating the connection due
      # to a protocol error.
      class ProtocolError < Error
        def status_code; 1002; end
      end

      # 1003 indicates that an endpoint is terminating the connection
      # because it has received a type of data it cannot accept (e.g. an
      # endpoint that understands only text data MAY send this if it
      # receives a binary message).
      class UnsupportedData < Error
        def status_code; 1003; end
      end

      # 1005 is a reserved value and MUST NOT be set as a status code in a
      # Close control frame by an endpoint.  It is designated for use in
      # applications expecting a status code to indicate that no status
      # code was actually present.
      class NoStatusRcvd < Error
        def status_code; 1005; end
      end

      # 1006 is a reserved value and MUST NOT be set as a status code in a
      # Close control frame by an endpoint.  It is designated for use in
      # applications expecting a status code to indicate that the
      # connection was closed abnormally, e.g. without sending or
      # receiving a Close control frame.
      class AbnormalClosure < Error
        def status_code; 1006; end
      end

      # 1007 indicates that an endpoint is terminating the connection
      # because it has received data within a message that was not
      # consistent with the type of the message (e.g., non-UTF-8 [RFC3629]
      # data within a text message).
      class InvalidFramePayloadData < Error
        def status_code; 1007; end
      end

      # 1008 indicates that an endpoint is terminating the connection
      # because it has received a message that violates its policy.  This
      # is a generic status code that can be returned when there is no
      # other more suitable status code (e.g. 1003 or 1009), or if there
      # is a need to hide specific details about the policy.
      class PolicyViolation < Error
        def status_code; 1008; end
      end

      # 1009 indicates that an endpoint is terminating the connection
      # because it has received a message which is too big for it to
      # process.
      class MessageTooBig < Error
        def status_code; 1009; end
      end

      # 1010 indicates that an endpoint (client) is terminating the
      # connection because it has expected the server to negotiate one or
      # more extension, but the server didn't return them in the response
      # message of the WebSocket handshake.  The list of extensions which
      # are needed SHOULD appear in the /reason/ part of the Close frame.
      # Note that this status code is not used by the server, because it
      # can fail the WebSocket handshake instead.
      class MandatoryExtension < Error
        def status_code; 1010; end
      end

    end
  end
end