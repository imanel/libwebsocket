# -*- encoding: binary -*-

module LibWebSocket
  # Construct or parse a WebSocket frame.
  #
  # SYNOPSIS
  #
  #   # Create frame
  #   frame = LibWebSocket::Frame.new('123')
  #   frame.to_bytes
  #
  #   # Parse frames
  #   frame = LibWebSocket::Frame.new
  #   frame.append(...)
  #   frame.next # get next message
  #   frame.next # get another next message
  class Frame

    autoload :Error, "#{File.dirname(__FILE__)}/frame/error"

    MAX_RAND_INT = 2 ** 32
    TYPES = {
      :text   => 0x01,
      :binary => 0x02,
      :ping   => 0x09,
      :pong   => 0x0a,
      :close  => 0x08
    }

    attr_accessor :buffer, :version, :max_fragments_amount, :max_payload_size, :fin, :rsv, :opcode, :masked

    # Create a new Frame instance. Automatically detect if the passed data is a string or bytes.
    # Options can be buffer or hash with options:
    #   :buffer - content of buffer
    #   :type - frame type(allowed values: text, binary, ping, pong, close)
    #   :version - protocol version(see readme for supported versions)
    #   :max_fragments_amount - max number of message parts per single frame
    #   :max_payload_size - max bytesize of single message
    # @example
    #   LibWebSocket::Frame->new('data')
    #   LibWebSocket::Frame->new(:buffer => 'data', :type => 'close')
    def initialize(options = '')
      if options.is_a?(Hash)
        options.each {|k,v| instance_variable_set("@#{k}",v) }
      else
        @buffer = options
      end

      @buffer ||= ''
      @version ||= 'draft-ietf-hybi-10'
      @fragments = []
      @max_fragments_amount ||= 128
      @max_payload_size ||= 65536
    end

    # Append a frame chunk.
    # @example
    #   frame.append("\x00foo")
    #   frame.append("bar\xff")
    def append(string = nil)
      return unless string.is_a?(String)

      string.force_encoding("ASCII-8BIT") if string.respond_to?(:force_encoding)

      self.buffer += string
      return self
    end

    # Return the next frame.
    # @example
    #   frame.append(...)
    #   frame.next; # next message
    def next
      bytes = self.next_bytes
      return unless bytes

      bytes.force_encoding('UTF-8') if bytes.respond_to?(:force_encoding)
      return bytes
    end

    def opcode
      @opcode || 1
    end

    def ping?;   opcode == TYPES[:ping];   end # Check if frame is a ping request.
    def pong?;   opcode == TYPES[:pong];   end # Check if frame is a pong response.
    def close?;  opcode == TYPES[:close];  end # Check if frame is of close type.
    def text?;   opcode == TYPES[:text];   end # Check if frame is of text type.
    def binary?; opcode == TYPES[:binary]; end # Check if frame is of binary type.

    # Return the next message as a UTF-8 encoded string.
    def next_bytes
      if ['draft-hixie-75', 'draft-ietf-hybi-00'].include? self.version
        if self.buffer.slice!(/\A\xff\x00/m)
          self.opcode = TYPES[:close]
          return ''
        end

        return unless self.buffer.slice!(/^[^\x00]*\x00(.*?)\xff/m)
        return $1
      end

      return unless self.buffer.length >= 2

      while self.buffer.length > 0
        hdr = self.buffer[0..0]
        bits = hdr.unpack("B*").first.split(//)

        self.fin = bits[0]
        self.rsv = bits[1..3]
        opcode = hdr.unpack('C').first & 0b00001111
        offset = 1 # FIN,RSV[1-3],OPCODE

        payload_len = buffer[1..1].unpack('C').first
        self.masked = (payload_len & 0b10000000) >> 7
        offset += 1 # + MASKED,PAYLOAD_LEN

        payload_len = payload_len & 0b01111111
        if payload_len == 126
          return unless self.buffer.length >= offset + 2

          payload_len = self.buffer[offset..offset+2].unpack('n').first
          offset += 2
        elsif payload_len > 126
          return unless self.buffer.length >= offset + 4
          bits = self.buffer[offset..offset+7].unpack('B*').first
          bits.gsub!(/^./,'0') # Most significant bit must be 0.
          bits = bits[32..-1] # No idea how to unpack 64-bit unsigned integer with big-endian byte order
          payload_len = Array(bits).pack("B*").unpack("N").first
          offset += 8
        end

        if payload_len > self.max_payload_size
          self.buffer = ''
          raise Error::MessageTooBig.new("Payload is too big. Deny big message (#{payload_len}) or increase max_payload_size (#{self.max_payload_size})")
        end

        mask = ''
        if self.masked == 1
          return unless self.buffer.length >= offset + 4

          mask = self.buffer[offset..offset+4]
          offset += 4
        end

        return if self.buffer.length < offset + payload_len

        payload = self.buffer[offset..offset+payload_len-1]
        payload = self.mask(payload, mask) if self.masked == 1

        self.buffer[0..offset+payload_len-1] = ''

        # Inject control frame
        if !@fragments.empty? && (opcode & 0b1000 != 0)
          self.opcode = opcode
          return payload
        end

        if self.fin != '0'
          if @fragments.empty?
            self.opcode = opcode
          else
            self.opcode = @fragments.shift
          end

          payload = (@fragments + Array(payload)).join
          @fragments = []
          return payload
        else
          # Remember first fragment opcode
          @fragments.push(opcode) if @fragments.empty?

          @fragments.push(payload)
          raise Error::PolicyViolation.new("Too many fragments") if @fragments.size > self.max_fragments_amount
        end
      end

      return
    end

    protected

    def mask(payload, mask)
      mask = mask.bytes.to_a
      payload = payload.bytes.to_a
      payload.each_with_index do |p, i|
        j = i % 4
        payload[i] = p ^ mask[j]
      end
      return payload.collect(&:chr).join
    end

  end
end
