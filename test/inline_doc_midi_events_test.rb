require_relative 'helper'

# Test class for MIDI Events inline documentation examples
#
# Verifies that all code examples in the YARD documentation are correct
# and produce the expected results.
class InlineDocMIDIEventsTest < Minitest::Test

  # Tests for main module documentation (lib/midi-events.rb)

  def test_example_from_line_8_basic_note_creation
    # Example from line 8: Basic note creation
    note = MIDIEvents::NoteOn.new(0, 64, 64)

    assert_equal 0, note.channel
    assert_equal 64, note.note
    assert_equal 64, note.velocity
    assert_kind_of MIDIEvents::NoteOn, note
  end

  def test_example_from_line_15_using_note_names
    # Example from line 15: Using note names
    note = MIDIEvents::NoteOn["E4"].new(0, 100)

    assert_equal 0, note.channel
    assert_equal 64, note.note
    assert_equal 100, note.velocity
    assert_equal "E4", note.name
  end

  def test_example_from_line_20_using_context_for_common_parameters
    # Example from line 20: Using context for common parameters
    result = MIDIEvents.with(channel: 0, velocity: 100) do
      note_on("E4")
    end

    assert_equal 0, result.channel
    assert_equal 64, result.note
    assert_equal 100, result.velocity
    assert_kind_of MIDIEvents::NoteOn, result
  end

  def test_example_from_line_26_working_with_control_changes
    # Example from line 26: Working with control changes
    cc = MIDIEvents::ControlChange["Modulation Wheel"].new(0, 64)

    assert_equal 0, cc.channel
    assert_equal 1, cc.index  # Modulation Wheel is CC 1
    assert_equal 64, cc.value
  end

  def test_example_from_line_30_system_exclusive_messages
    # Example from line 30: System exclusive messages
    synth = MIDIEvents::SystemExclusive::Node.new(0x41, model_id: 0x42, device_id: 0x10)
    command = synth.command([0x40, 0x7F, 0x00], 0x00)

    assert_kind_of MIDIEvents::SystemExclusive::Command, command
    assert_equal synth, command.node
    assert_equal [0x40, 0x7F, 0x00], command.address
    assert_equal 0x00, command.data
  end

  # Tests for Constant module documentation (lib/midi-events/constant.rb)

  def test_constant_example_from_line_11_looking_up_note_values
    # Example from line 11: Looking up note values
    result = MIDIEvents::Constant.find('Note', 'C4')

    assert_kind_of MIDIEvents::Constant::Map, result
    assert_equal "C4", result.key
    assert_equal 60, result.value
  end

  def test_constant_example_from_line_15_getting_constant_value_directly
    # Example from line 15: Getting constant value directly
    result = MIDIEvents::Constant.value('Note', 'E4')

    assert_equal 64, result
  end

  def test_constant_example_from_line_19_using_constants_in_message_creation
    # Example from line 19: Using constants in message creation
    note = MIDIEvents::NoteOn["C4"].new(0, 100)

    assert_equal 60, note.note
    assert_equal "C4", note.name
  end

  def test_constant_name_example_from_line_54_underscore
    # Example from line 54: Name.underscore
    result = MIDIEvents::Constant::Name.underscore("Control Change")

    assert_equal "control_change", result
  end

  def test_constant_name_example_from_line_66_match
    # Example from line 66: Name.match?
    result = MIDIEvents::Constant::Name.match?("Control Change", "control_change")

    assert_equal true, result
  end

  def test_constant_group_example_from_line_84_accessing_constant_group
    # Example from line 84: Accessing a constant group
    group = MIDIEvents::Constant::Group['Note']
    result = group.find('C4')

    assert_kind_of MIDIEvents::Constant::Map, result
    assert_equal 60, result.value
  end

  def test_constant_group_example_from_line_107_find_by_name
    # Example from line 107: Find constant in group by name
    group = MIDIEvents::Constant::Group['Note']
    result = group.find('E4')

    assert_kind_of MIDIEvents::Constant::Map, result
    assert_equal 64, result.value
  end

  def test_constant_group_example_from_line_119_find_by_value
    # Example from line 119: Find constant by value (reverse lookup)
    group = MIDIEvents::Constant::Group['Note']
    result = group.find_by_value(64)

    assert_kind_of MIDIEvents::Constant::Map, result
    assert_equal "E4", result.key
  end

  def test_constant_map_example_from_line_183_map_creation
    # Example from line 183: Creating a constant mapping
    map = MIDIEvents::Constant::Map.new("C4", 60)

    assert_equal "C4", map.key
    assert_equal 60, map.value
  end

  def test_constant_message_builder_example_from_line_213
    # Example from line 213: MessageBuilder usage
    builder = MIDIEvents::NoteOn["C4"]
    note = builder.new(0, 100)

    assert_equal 60, note.note
    assert_equal 0, note.channel
    assert_equal 100, note.velocity
  end

  def test_constant_status_example_from_line_245
    # Example from line 245: Status lookups
    note_on_status = MIDIEvents::Constant::Status['Note On']
    cc_status = MIDIEvents::Constant::Status['Control Change']

    assert_equal 0x9, note_on_status
    assert_equal 0xB, cc_status
  end

  def test_constant_loader_dsl_example_from_line_355
    # Example from line 355: MessageBuilder via DSL
    builder = MIDIEvents::NoteOn["C4"]
    note = builder.new(0, 100)

    assert_equal 60, note.note
    assert_equal 0, note.channel
    assert_equal 100, note.velocity
  end

  # Tests for TypeConversion module documentation (lib/midi-events/type_conversion.rb)

  def test_type_conversion_example_from_line_8_hex_string_to_bytes
    # Example from line 8: Converting hex string to bytes
    result = MIDIEvents::TypeConversion.hex_string_to_numeric_byte_array("904040")

    assert_equal [0x90, 0x40, 0x40], result
  end

  def test_type_conversion_example_from_line_12_bytes_to_hex_string
    # Example from line 12: Converting bytes to hex string
    result = MIDIEvents::TypeConversion.numeric_byte_array_to_hex_string([0x90, 0x40, 0x40])

    assert_equal "904040", result
  end

  def test_type_conversion_example_from_line_26_hex_chars_to_bytes
    # Example from line 26: hex_chars_to_numeric_byte_array
    result = MIDIEvents::TypeConversion.hex_chars_to_numeric_byte_array(["9", "0", "4", "0"])

    assert_equal [0x90, 0x40], result
  end

  def test_type_conversion_example_from_line_47_hex_string_to_bytes_direct
    # Example from line 47: hex_string_to_numeric_byte_array
    result = MIDIEvents::TypeConversion.hex_string_to_numeric_byte_array("904040")

    assert_equal [0x90, 0x40, 0x40], result
  end

  def test_type_conversion_example_from_line_64_hex_str_to_chars
    # Example from line 64: hex_str_to_hex_chars
    result = MIDIEvents::TypeConversion.hex_str_to_hex_chars("904040")

    assert_equal ["9", "0", "4", "0", "4", "0"], result
  end

  def test_type_conversion_example_from_line_76_bytes_to_hex_string_direct
    # Example from line 76: numeric_byte_array_to_hex_string
    result = MIDIEvents::TypeConversion.numeric_byte_array_to_hex_string([0x90, 0x40, 0x40])

    assert_equal "904040", result
  end

  def test_type_conversion_example_from_line_93_byte_to_hex_chars
    # Example from line 93: numeric_byte_to_hex_chars
    result = MIDIEvents::TypeConversion.numeric_byte_to_hex_chars(0x90)

    assert_equal ["9", "0"], result
  end

  def test_type_conversion_example_from_line_106_byte_to_nibbles
    # Example from line 106: numeric_byte_to_nibbles
    result = MIDIEvents::TypeConversion.numeric_byte_to_nibbles(0x90)

    assert_equal [0x9, 0x0], result
  end

  # Tests for Context class documentation (lib/midi-events/context.rb)

  def test_context_example_from_line_8_basic_context_usage
    # Example from line 8: Basic context usage
    note_on = nil
    note_off = nil

    MIDIEvents.with(channel: 0, velocity: 100) do
      note_on = note_on("C4")
      note_off = note_off("C4")
    end

    assert_equal 0, note_on.channel
    assert_equal 100, note_on.velocity
    assert_equal 0, note_off.channel
    assert_equal 100, note_off.velocity
  end

  def test_context_example_from_line_14_override_context_parameters
    # Example from line 14: Override context parameters
    note1 = nil
    note2 = nil

    MIDIEvents.with(channel: 0, velocity: 100) do
      note1 = note_on("C4")
      note2 = note_on("E4", velocity: 127)
    end

    assert_equal 100, note1.velocity
    assert_equal 127, note2.velocity
  end

  def test_context_example_from_line_20_control_changes_in_context
    # Example from line 20: Control changes in context
    cc = nil
    pc = nil

    MIDIEvents.with(channel: 0) do
      cc = control_change("Modulation Wheel", 64)
      pc = program_change(0)
    end

    assert_equal 0, cc.channel
    assert_equal 1, cc.index
    assert_equal 64, cc.value
    assert_equal 0, pc.channel
    assert_equal 0, pc.program
  end

  # Tests for README.md examples (from examples/ folder)

  def test_readme_example_raw_channel_message
    # Example from README: Raw channel messages
    channel_msg = MIDIEvents::ChannelMessage.new(0x9, 0x0, 0x40, 0x40)

    assert_kind_of MIDIEvents::ChannelMessage::Message, channel_msg
    assert_equal [9, 0], channel_msg.status
    assert_equal [64, 64], channel_msg.data
  end

  def test_readme_example_mutable_properties
    # Example from README: Mutable properties
    msg = MIDIEvents::NoteOn["E4"].new(0, 100)
    assert_equal 64, msg.note  # E4 = 64

    msg.note += 5
    assert_equal 69, msg.note  # 64 + 5 = 69 (A4)
  end

  def test_readme_example_system_realtime_start
    # Example from README: System Realtime Start
    start_msg = MIDIEvents::SystemRealtime["Start"].new

    assert_kind_of MIDIEvents::SystemRealtime, start_msg
    assert_equal "Start", start_msg.name
  end

  def test_readme_example_system_realtime_stop
    # Example from README: System Realtime Stop
    stop_msg = MIDIEvents::SystemRealtime["Stop"].new

    assert_kind_of MIDIEvents::SystemRealtime, stop_msg
    assert_equal "Stop", stop_msg.name
  end

  def test_readme_example_building_melodies
    # Example from README: Building melodies
    channel = 0
    notes = [36, 40, 43]  # C E G
    octaves = 2
    velocity = 100

    melody = []

    (0..((octaves-1)*12)).step(12) do |oct|
      notes.each { |note| melody << MIDIEvents::NoteOn.new(channel, note + oct, velocity) }
    end

    assert_equal 6, melody.length  # 3 notes * 2 octaves

    # First octave
    assert_equal 36, melody[0].note  # C
    assert_equal 40, melody[1].note  # E
    assert_equal 43, melody[2].note  # G

    # Second octave
    assert_equal 48, melody[3].note  # C + 12
    assert_equal 52, melody[4].note  # E + 12
    assert_equal 55, melody[5].note  # G + 12

    melody.each do |note|
      assert_kind_of MIDIEvents::NoteOn, note
      assert_equal 0, note.channel
      assert_equal 100, note.velocity
    end
  end

end
