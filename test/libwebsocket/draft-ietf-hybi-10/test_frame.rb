# -*- encoding: binary -*-
require 'test_helper'

class TestFrame < Test::Unit::TestCase

  def test_append_ietf_hybi_10
    f = LibWebSocket::Frame.new(:version => 'draft-ietf-hybi-10')

    f.append
    assert_nil f.next
    f.append('')
    assert_nil f.next

    # Not masked
    f.append ["810548656c6c6f"].pack('H*')
    assert_equal 'Hello', f.next_bytes
    assert_equal 1, f.opcode
    assert f.text?

    # Multi
    f.append(["810548656c6c6f"].pack('H*') + ["810548656c6c6f"].pack('H*'))
    assert_equal 'Hello', f.next_bytes
    assert_equal 'Hello', f.next_bytes

    # Masked
    f.append ["818537fa213d7f9f4d5158"].pack('H*')
    assert_equal 'Hello', f.next_bytes
    assert_equal 1, f.opcode

    # Fragments
    f.append ["010348656c"].pack("H*")
    assert_nil f.next_bytes
    f.append ["80026c6f"].pack("H*")
    assert_equal 'Hello', f.next_bytes
    assert_equal 1, f.opcode

    # Multi fragments
    f.append(["010348656c"].pack('H*') + ["80026c6f"].pack('H*'))
    assert_equal 'Hello', f.next_bytes
    assert_equal 1, f.opcode

    # Injected control frame (1 fragment, ping, 2 fragment)
    f.append ["010348656c"].pack('H*')
    f.append ["890548656c6c6f"].pack('H*')
    f.append ["80026c6f"].pack('H*')
    assert_equal 'Hello', f.next_bytes
    assert_equal 9, f.opcode
    assert_equal 'Hello', f.next_bytes
    assert_equal 1, f.opcode

    # Too many fragments
    130.times { f.append(["010348656c"].pack('H*')) }
    assert_raise(LibWebSocket::Frame::Error::PolicyViolation) { f.next_bytes }

    # Ping request
    f = LibWebSocket::Frame.new(:version => 'draft-ietf-hybi-10')
    f.append ["890548656c6c6f"].pack('H*')
    assert_equal 'Hello', f.next_bytes
    assert_equal 9, f.opcode
    assert f.ping?

    # Ping response
    f.append ["8a0548656c6c6f"].pack('H*')
    assert_equal 'Hello', f.next_bytes
    assert_equal 10, f.opcode
    assert f.pong?

    # 256 bytes
    f.append ["827E0100" + '05' * 256].pack('H*')
    assert_equal 256, f.next_bytes.length
    assert_equal 2, f.opcode
    assert f.binary?

    # 64KiB
    f.append ["827F0000000000010000" + '05' * 65536].pack('H*')
    assert_equal 65536, f.next_bytes.length
    assert_equal 2, f.opcode

    # Too big frame
    f.append ["827F0000000000100000" + '05' * (65536 + 1)].pack('H*')
    assert_raise(LibWebSocket::Frame::Error::MessageTooBig) { f.next_bytes }
  end

end