# Ruby MIDI Events library - object-oriented representation of MIDI messages
#
# This library provides a comprehensive set of classes and modules for working with MIDI events
# in Ruby. It offers an intuitive API for creating and manipulating various MIDI message types
# including channel messages (notes, control changes, program changes), system messages, and
# system exclusive (SysEx) messages.
#
# @example Basic note creation
#   require 'midi-events'
#
#   # Create a middle C note-on message on channel 0 with velocity 64
#   note = MIDIEvents::NoteOn.new(0, 64, 64)
#   # => #<MIDIEvents::NoteOn @channel=0, @note=64, @velocity=64>
#
# @example Using note names
#   # Create note using named constant
#   note = MIDIEvents::NoteOn["E4"].new(0, 100)
#   # => #<MIDIEvents::NoteOn @channel=0, @note=64, @velocity=100, @name="E4">
#
# @example Using context for common parameters
#   # Set channel and velocity as context
#   MIDIEvents.with(channel: 0, velocity: 100) do
#     note_on("E4")  # Creates note-on with channel 0, velocity 100
#   end
#
# @example Working with control changes
#   # Create modulation wheel control change
#   cc = MIDIEvents::ControlChange["Modulation Wheel"].new(0, 64)
#
# @example System exclusive messages
#   # Create a SysEx node representing a device
#   synth = MIDIEvents::SystemExclusive::Node.new(0x41, model_id: 0x42, device_id: 0x10)
#
#   # Send a command to the device
#   command = synth.command([0x40, 0x7F, 0x00], 0x00)
#
# @see MIDIEvents::Context For DSL-style message creation
# @see MIDIEvents::Constant For MIDI constant lookups
#
# @author (c)2021 Javier Sánchez Yeste for the modifications, licensed under LGPL 3.0 License
# @author (c)2011-2015 Ari Russo for original MIDI Message library, licensed under Apache 2.0 License
#
# @note This library is part of the MusaDSL ecosystem
# @note Based on Ari Russo's MIDI Message library with performance optimizations
module MIDIEvents
  VERSION = '0.7.0'.freeze
end
