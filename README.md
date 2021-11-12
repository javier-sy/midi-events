# MIDI Events

Ruby MIDI Events objects

## Features

TO-REVIEW

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

There are a few ways to create a new MIDI message.  Here are some examples

```ruby
MIDIEvents::NoteOn.new(0, 64, 64)

MIDIEvents::NoteOn["E4"].new(0, 100)

MIDIEvents.with(:channel => 0, :velocity => 100) { note_on("E4") }
```

Those expressions all evaluate to the same object

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

#### SysEx Messages

As with any kind of message, you can begin with raw data

```ruby
MIDIEvents::SystemExclusive.new(0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x00, 0x7F, 0x00, 0x41, 0xF7)
```

Or in a more object oriented way

```ruby  
synth = SystemExclusive::Node.new(0x41, :model_id => 0x42, :device_id => 0x10)

SystemExclusive::Command.new([0x40, 0x7F, 0x00], 0x00, :node => synth)
```

A Node represents a device that you're sending a message to (eg. your Yamaha DX7 is a Node).  Sysex messages can either be a Command or Request

You can use the Node to instantiate a message

```ruby  
synth.command([0x40, 0x7F, 0x00], 0x00)
```

One way or another, you will wind up with a pair of objects like this

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

Check out [midi-parser](http://github.com/javier-sy/midi-parser) for advanced parsing

## Documentation

* [rdoc](http://rubydoc.info/github/javier-sy/midi-events)

## Differences between [MIDI Events](https://github.com/javier-sy/midi-events) and [MIDI Message](https://github.com/arirusso/midi-message)

[MIDI Events](https://github.com/javier-sy/midi-events) is mostly a clone of [MIDI Message](https://github.com/arirusso/midi-message) with some modifications:
* Renamed gem to midi-events instead of midi-message
* Renamed module to MIDIEvents instead of MIDIMessage
* Removed parsing features (in favour of the more complete parser [MIDI Parser](https://github.com/javier-sy/midi-parser))
* TODO: update tests to use rspec instead of rake
* TODO: migrate (or confirm it's working ok) on to Ruby 3.0 or Ruby 3.1

## Author

* [Javier Sánchez Yeste](https://github.com/javier-sy)

## Acknowledgements

Thanks to [Ari Russo](http://github.com/arirusso) for his ruby library [MIDI Message](https://github.com/arirusso/midi-message) licensed as Apache License 2.0.

## License

[MIDI Events](https://github.com/javier-sy/midi-events) Copyright (c) 2021 [Javier Sánchez Yeste](https://yeste.studio), licensed under LGPL 3.0 License

[MIDI Message](https://github.com/arirusso/midi-message) Copyright (c) 2011-2015 [Ari Russo](http://arirusso.com), licensed under Apache License 2.0 (see the file LICENSE.midi-message)


