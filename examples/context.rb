#!/usr/bin/env ruby
#
# Use a block loaded with velocity and channel
#

$:.unshift(File.join("..", "lib"))

require "midi-events"

MIDIEvents.with(:channel => 0, :velocity => 100) do

  note_on("E4")
  note_off("E4")

  note_on("C4")
  note_off("C4")

  control_change("Portamento", 64)

  note_on("E4")
  pp note_off("E4")

  pp program_change(20)

end
