require "helper"

class MIDIEvents::MessagesTest < Minitest::Test

  def test_channel_message
    message = MIDIEvents::ChannelMessage.new(0x9, 0x0, 0x40, 0x40)
    refute_nil message
    assert message.kind_of?(MIDIEvents)
    assert_equal(0x9, message.status[0])
    assert_equal(0x0, message.status[1])
    assert_equal(0x40, message.data[0])
    assert_equal(0x40, message.data[1])
    assert_equal([0x90, 0x40, 0x40], message.to_a)
    assert_equal("904040", message.to_bytestr)
  end

  def test_note_off
    message = MIDIEvents::NoteOff.new(0, 0x40, 0x40)
    assert_equal(0, message.channel)
    assert_equal(0x40, message.note)
    assert_equal(0x40, message.velocity)
    assert_equal([0x80, 0x40, 0x40], message.to_a)
    assert_equal("804040", message.to_bytestr)
  end

  def test_note_on
    message = MIDIEvents::NoteOn.new(1, 0x40, 0x40)
    assert_equal(1, message.channel)
    assert_equal(0x40, message.note)
    assert_equal(0x40, message.velocity)
    assert_equal([0x91, 0x40, 0x40], message.to_a)
    assert_equal("914040", message.to_bytestr)
    assert_equal([0x91, 0x40, 0x40], message.to_bytes)
  end

  def test_change_channel
    message = MIDIEvents::NoteOn.new(1, 0x40, 0x40)
    assert_equal(1, message.channel)
    assert_equal(0x40, message.note)
    assert_equal(0x40, message.velocity)
    assert_equal([0x91, 0x40, 0x40], message.to_a)
    assert_equal("914040", message.to_bytestr)
    assert_equal([0x91, 0x40, 0x40], message.to_bytes)

    message.channel = 3
    assert_equal(3, message.channel)
    assert_equal(0x40, message.note)
    assert_equal(0x40, message.velocity)
    assert_equal([0x93, 0x40, 0x40], message.to_a)
    assert_equal("934040", message.to_bytestr)
    assert_equal([0x93, 0x40, 0x40], message.to_bytes)
  end

  def test_note_on_to_note_off
    message = MIDIEvents::NoteOn.new(0, 0x40, 0x40)
    assert_equal(0, message.channel)
    assert_equal(0x40, message.note)
    assert_equal(0x40, message.velocity)
    assert_equal([0x90, 0x40, 0x40], message.to_a)
    off = message.to_note_off
    assert_equal(0, off.channel)
    assert_equal(0x40, off.note)
    assert_equal(0x40, off.velocity)
    assert_equal([0x80, 0x40, 0x40], off.to_a)
  end


  def test_polyphonic_aftertouch
    message = MIDIEvents::PolyphonicAftertouch.new(1, 0x40, 0x40)
    assert_equal(1, message.channel)
    assert_equal(0x40, message.note)
    assert_equal(0x40, message.value)
    assert_equal([0xA1, 0x40, 0x40], message.to_a)
    assert_equal("A14040", message.to_bytestr)
  end

  def test_control_change
    message = MIDIEvents::ControlChange.new(2, 0x20, 0x20)
    assert_equal(message.channel, 2)
    assert_equal(0x20, message.index)
    assert_equal(0x20, message.value)
    assert_equal([0xB2, 0x20, 0x20], message.to_a)
    assert_equal("B22020", message.to_bytestr)
  end

  def test_program_change
    message = MIDIEvents::ProgramChange.new(3, 0x40)
    assert_equal(3, message.channel)
    assert_equal(0x40, message.program)
    assert_equal([0xC3, 0x40], message.to_a)
    assert_equal("C340", message.to_bytestr)

  end

  def test_channel_aftertouch
    message = MIDIEvents::ChannelAftertouch.new(3, 0x50)
    assert_equal(3, message.channel)
    assert_equal(0x50, message.value)
    assert_equal([0xD3, 0x50], message.to_a)
    assert_equal("D350", message.to_bytestr)
  end

  def test_pitch_bend
    message = MIDIEvents::PitchBend.new(0, 0x50, 0xA0)
    assert_equal(0, message.channel)
    assert_equal(0x50, message.low)
    assert_equal(0xA0, message.high)
    assert_equal([0xE0, 0x50, 0xA0], message.to_a)
    assert_equal("E050A0", message.to_bytestr)
  end

  def test_system_common
    message = MIDIEvents::SystemCommon.new(1, 0x50, 0xA0)
    assert_equal(1, message.status[1])
    assert_equal(0x50, message.data[0])
    assert_equal(0xA0, message.data[1])
    assert_equal([0xF1, 0x50, 0xA0], message.to_a)
    assert_equal("F150A0", message.to_bytestr)
  end

  def test_system_realtime
    message = MIDIEvents::SystemRealtime.new(0x8)
    assert_equal(8, message.id)
    assert_equal([0xF8], message.to_a)
    assert_equal("F8", message.to_bytestr)
  end

end
