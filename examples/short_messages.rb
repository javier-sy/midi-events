#!/usr/bin/env ruby
#
# Walk through of different ways to instantiate short (non-sysex) MIDI Messages
#

$:.unshift(File.join("..", "lib"))

require "midi-events"

# Here are examples of different ways to construct messages, going from low to high-level

channel_msg = MIDIEvents::ChannelMessage.new(0x9, 0x0, 0x40, 0x40)

pp channel_msg

pp MIDIEvents::ChannelMessage.new(MIDIEvents::Constant::Status["Note On"], 0x0, 0x40, 0x40)

pp MIDIEvents::NoteOn.new(0, 64, 64) # or NoteOn.new(0x0, 0x64, 0x64)

# some message properties are mutable

pp msg = MIDIEvents::NoteOn["E4"].new(0, 100)

msg.note += 5

pp msg
