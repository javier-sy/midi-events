# MIDI Events

[![Ruby Version](https://img.shields.io/badge/ruby-2.7+-red.svg)](https://www.ruby-lang.org/)
[![License](https://img.shields.io/badge/license-LGPL--3.0--or--later-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0.html)

**Ruby MIDI Events Objects**

This library is part of a suite of Ruby libraries for MIDI:

| Function | Library |
| --- | --- |
| MIDI Events representation | [MIDI Events](https://github.com/javier-sy/midi-events) |
| MIDI Data parsing | [MIDI Parser](https://github.com/javier-sy/midi-parser) |
| MIDI communication with Instruments and Control Surfaces | [MIDI Communications](https://github.com/javier-sy/midi-communications) |
| Low level MIDI interface to MacOS | [MIDI Communications MacOS Layer](https://github.com/javier-sy/midi-communications-macos) |
| Low level MIDI interface to Linux | **TO DO** (by now [MIDI Communications](https://github.com/javier-sy/midi-communications) uses [alsa-rawmidi](http://github.com/arirusso/alsa-rawmidi)) | 
| Low level MIDI interface to JRuby | **TO DO** (by now [MIDI Communications](https://github.com/javier-sy/midi-communications) uses [midi-jruby](http://github.com/arirusso/midi-jruby))| 
| Low level MIDI interface to Windows | **TO DO** (by now [MIDI Communications](https://github.com/javier-sy/midi-communications) uses [midi-winm](http://github.com/arirusso/midi-winmm)) | 

This library is based on [Ari Russo's](http://github.com/arirusso) library [MIDI Message](https://github.com/arirusso/midi-message).

## Features

* Flexible API to accommodate various sources and destinations of MIDI data
* Simple approach to System Exclusive data and devices
* [YAML dictionary of MIDI constants](https://github.com/javier-sy/midi-events/blob/master/lib/midi.yml)

## Install

`gem install midi-events`

Or if you're using Bundler, add this to your Gemfile

`gem "midi-events"`

## Usage

```ruby
require "midi-events"
```

#### Basic Messages

There are a few ways to create a new MIDI event. Here are some examples:

```ruby
MIDIEvents::NoteOn.new(0, 64, 64)

MIDIEvents::NoteOn["E4"].new(0, 100)

MIDIEvents.with(:channel => 0, :velocity => 100) { note_on("E4") }
```

Those expressions all evaluate to the same object:

```ruby
#<MIDIEvents::NoteOn:0x9c1c240
   @channel=0,
   @data=[64, 64],
   @name="E4",
   @note=64,
   @status=[9, 0],
   @velocity=64,
   @verbose_name="Note On: E4">
```

#### Raw Channel Messages

You can also create raw channel messages directly from nibbles and bytes:

```ruby
MIDIEvents::ChannelMessage.new(0x9, 0x0, 0x40, 0x40)
```

#### Mutable Properties

Some message properties can be modified after creation:

```ruby
msg = MIDIEvents::NoteOn["E4"].new(0, 100)
msg.note += 5  # Transpose up 5 semitones
```

#### System Realtime Messages

System Realtime messages are used for synchronization:

```ruby
MIDIEvents::SystemRealtime["Start"].new
MIDIEvents::SystemRealtime["Stop"].new
```

#### Building Melodies

You can construct sequences of notes programmatically:

```ruby
channel = 0
notes = [36, 40, 43]  # C E G
octaves = 2
velocity = 100

melody = []

(0..((octaves-1)*12)).step(12) do |oct|
  notes.each { |note| melody << MIDIEvents::NoteOn.new(channel, note + oct, velocity) }
end
```

#### SysEx Messages

As with any kind of message, you can begin with raw data:

```ruby
MIDIEvents::SystemExclusive.new(0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7)
```

Or in a more object oriented way:

```ruby  
synth = SystemExclusive::Node.new(0x41, model_id: 0x42, device_id: 0x10)

SystemExclusive::Command.new([0x40, 0x7F, 0x00], 0x00, node: synth)
```

A Node represents a device that you're sending a message to (eg. your Yamaha DX7 is a Node). Sysex messages can either be a Command or Request.

You can use the Node to instantiate a message:

```ruby  
synth.command([0x40, 0x7F, 0x00], 0x00)
```

One way or another, you will wind up with a pair of objects like this:

```ruby
#<MIDIEvents::SystemExclusive::Command:0x9c1e57c
   @address=[64, 0, 127],
   @checksum=[65],
   @data=[0],
   @node=
    #<MIDIMessage::SystemExclusive::Node:0x9c1e5a4
     @device_id=16,
     @manufacturer_id=65,
     @model_id=66>>
```

## Documentation

* [rdoc](http://rubydoc.info/github/javier-sy/midi-events)

## Differences between [MIDI Events](https://github.com/javier-sy/midi-events) library and [MIDI Message](https://github.com/arirusso/midi-message) library

[MIDI Events](https://github.com/javier-sy/midi-events) is mostly a clone of [MIDI Message](https://github.com/arirusso/midi-message) with some modifications:

* Renamed gem to midi-events instead of midi-message
* Renamed module to MIDIEvents instead of MIDIMessage
* Removed parsing features (in favour of the more complete parser [MIDI Parser](https://github.com/javier-sy/midi-parser))

## Then, why does exist this library if it is mostly a clone of another library?

The author has been developing since 2016 a Ruby project called
[Musa DSL](https://github.com/javier-sy/musa-dsl) that needs a way
of representing MIDI Events and a way of communicating with
MIDI Instruments and MIDI Control Surfaces.

[Ari Russo](https://github.com/arirusso) has done a great job creating
several interdependent Ruby libraries that allow
MIDI Events representation ([MIDI Message](https://github.com/arirusso/midi-message)
and [Nibbler](https://github.com/arirusso/nibbler))
and communication with MIDI Instruments and MIDI Control Surfaces
([unimidi](https://github.com/arirusso/unimidi),
[ffi-coremidi](https://github.com/arirusso/ffi-coremidi) and others)
that, **with some modifications**, I've been using in MusaDSL.

After thinking about the best approach to publish MusaDSL
I've decided to publish my own renamed version of the modified dependencies because:

* The original libraries have features
  (buffering, very detailed logging and processing history information, not locking behaviour when waiting input midi messages)
  that are not needed in MusaDSL and, in fact,
  can degrade the performance on some use cases in MusaDSL.
* The requirements for **Musa DSL** users probably will evolve in time, so it will be easier to maintain an independent source code base.
* Some differences on the approach of the modifications vs the original library doesn't allow to merge the modifications on the original libraries.
* Then the renaming of the libraries is needed to avoid confusing existent users of the original libraries.
* Due to some of the interdependencies of Ari Russo libraries,
  the modification and renaming on some of the low level libraries (ffi-coremidi, etc.)
  forces to modify and rename unimidi library.

All in all I have decided to publish a suite of libraries optimized for MusaDSL use case that also can be used by other people in their projects.

## Author

* [Javier Sánchez Yeste](https://github.com/javier-sy)

## Acknowledgements

Thanks to [Ari Russo](http://github.com/arirusso) for his ruby library [MIDI Message](https://github.com/arirusso/midi-message) licensed as Apache License 2.0.

## License

[MIDI Events](https://github.com/javier-sy/midi-events) Copyright (c) 2021-2025 [Javier Sánchez Yeste](https://yeste.studio), licensed under LGPL 3.0 License

[MIDI Message](https://github.com/arirusso/midi-message) Copyright (c) 2011-2015 [Ari Russo](http://arirusso.com), licensed under Apache License 2.0 (see the file LICENSE.midi-message)


