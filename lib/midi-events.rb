#
# Ruby MIDI message objects
#
# (c)2021 Javier Sánchez Yeste for the modifications, licensed under LGPL 3.0 License
# (c)2011-2015 Ari Russo for original MIDI Message library, licensed under Apache 2.0 License
#

# Libs
require 'forwardable'
require 'yaml'

# Modules
require 'midi-events/constant'
require 'midi-events/message'
require 'midi-events/channel_message'
require 'midi-events/note_message'
require 'midi-events/system_exclusive'
require 'midi-events/system_message'
require 'midi-events/type_conversion'

# Classes
require 'midi-events/context'
require 'midi-events/messages'

module MIDIEvents
  VERSION = '0.5.1'.freeze
end
