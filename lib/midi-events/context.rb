module MIDIEvents

  # DSL for creating MIDI messages with shared context
  #
  # Provides a convenient way to create multiple MIDI messages that share common
  # parameters (like channel and velocity) without repeating them for each message.
  #
  # @example Basic context usage
  #   MIDIEvents.with(channel: 0, velocity: 100) do
  #     note_on("C4")   # Creates NoteOn with channel 0, velocity 100
  #     note_off("C4")  # Creates NoteOff with channel 0, velocity 100
  #   end
  #
  # @example Override context parameters
  #   MIDIEvents.with(channel: 0, velocity: 100) do
  #     note_on("C4")                  # Uses context: channel 0, velocity 100
  #     note_on("E4", velocity: 127)   # Overrides velocity to 127
  #   end
  #
  # @example Control changes in context
  #   MIDIEvents.with(channel: 0) do
  #     control_change("Modulation Wheel", 64)
  #     program_change("Acoustic Grand Piano")
  #   end
  #
  # @api public
  class Context

    # @return [Integer, nil] The MIDI channel (0-15) for messages created in this context
    attr_accessor :channel

    # @return [Integer, nil] The velocity (0-127) for note messages created in this context
    attr_accessor :velocity

    # Create and execute a context with the given parameters
    #
    # @param [Hash] options Context parameters
    # @param [Proc] block The block to execute within this context
    # @option options [Integer] :channel MIDI channel (0-15)
    # @option options [Integer] :velocity Note velocity (0-127)
    # @return [Object] The result of evaluating the block
    def self.with(options = {}, &block)
      new(options, &block).instance_eval(&block)
    end

    # @param [Hash] options
    # @option options [Fixnum] :channel
    # @option options [Fixnum] :velocity
    def initialize(options = {})
      @channel = options[:channel]
      @velocity = options[:velocity]
    end

    # A note off message
    # @param [Fixnum, String] note
    # @param [Hash] options
    # @option options [Fixnum] :channel
    # @option options [Fixnum] :velocity
    def note_off(note, options = {})
      channel = options[:channel] || @channel
      velocity = options[:velocity] || @velocity
      raise 'note_off requires both channel and velocity' if channel.nil? || velocity.nil?
      
      if note.is_a?(String)
        NoteOff[note].new(channel, velocity, options)
      else
        NoteOff.new(channel, note, velocity, options)
      end
    end
    alias_method :NoteOff, :note_off

    # A note on message
    # @param [Fixnum, String] note
    # @param [Hash] options
    # @option options [Fixnum] :channel
    # @option options [Fixnum] :velocity
    def note_on(note, options = {})
      channel = options[:channel] || @channel
      velocity = options[:velocity] || @velocity
      raise 'note_on requires both channel and velocity' if channel.nil? || velocity.nil?

      if note.is_a?(String)
        NoteOn[note].new(channel, velocity, options)
      else
        NoteOn.new(channel, note, velocity, options)
      end
    end
    alias_method :NoteOn, :note_on

    # A program change message
    # @param [Fixnum, String] program
    # @param [Hash] options
    # @option options [Fixnum] :channel
    def program_change(program, options = {})
      channel = options[:channel] || @channel
      raise 'program_change requires channel' if channel.nil?

      if program.is_a?(String)
        ProgramChange[program].new(channel, options)
      else
        ProgramChange.new(channel, program, options)
      end
    end
    alias_method :ProgramChange, :program_change

    # A control change message
    # @param [Fixnum, String] index
    # @param [Fixnum] value
    # @param [Hash] options
    # @option options [Fixnum] :channel
    # @option options [Fixnum] :velocity
    def control_change(index, value, options = {})
      channel = options[:channel] || @channel
      raise 'control_change requires channel' if channel.nil?

      if index.is_a?(String)
        ControlChange[index].new(channel, value, options)
      else
        ControlChange.new(channel, index, value, options)
      end
    end
    alias_method :ControlChange, :control_change
    alias_method :Controller, :control_change
    alias_method :controller, :control_change

    # A poly pressure message
    # @param [Fixnum, String] note
    # @param [Fixnum] value
    # @param [Hash] options
    # @option options [Fixnum] :channel
    def polyphonic_aftertouch(note, value, options = {})
      channel = options[:channel] || @channel
      raise 'channel_aftertouch requires a channel' if channel.nil?

      if note.is_a?(String)
        PolyphonicAftertouch[note].new(channel, value, options)
      else
        PolyphonicAftertouch.new(channel, note, value, options)
      end
    end

    alias_method :PolyphonicAftertouch, :polyphonic_aftertouch
    alias_method :PolyAftertouch, :polyphonic_aftertouch
    alias_method :PolyphonicPressure, :polyphonic_aftertouch
    alias_method :PolyPressure, :polyphonic_aftertouch
    alias_method :poly_aftertouch, :polyphonic_aftertouch
    alias_method :poly_pressure, :polyphonic_aftertouch

    # A channel pressure message
    # @param [Fixnum] value
    # @param [Hash] options
    # @option options [Fixnum] :channel
    def channel_aftertouch(value, options = {})
      channel = options[:channel] || @channel
      raise 'channel_aftertouch requires a channel' if channel.nil?

      ChannelAftertouch.new(channel, value, options)
    end
    alias_method :ChannelAftertouch, :channel_aftertouch
    alias_method :ChannelPressure, :channel_aftertouch
    alias_method :channel_pressure, :channel_aftertouch

    # A poly pressure message
    # @param [Fixnum] low
    # @param [Fixnum] high
    # @param [Hash] options
    # @option options [Fixnum] :channel
    def pitch_bend(low, high, options = {})
      channel = options[:channel] || @channel
      raise 'channel_aftertouch requires a channel' if channel.nil?

      PitchBend.new(channel, low, high, options)
    end
    alias_method :PitchBend, :pitch_bend

  end

  # Shortcut to MIDIMessage::Context.with
  # @param [Hash] options
  # @param [Proc] block
  # @option options [Fixnum] :channel
  # @option options [Fixnum] :velocity
  def self.with_context(options = {}, &block)
    Context.with(options, &block)
  end
  class << self
    alias_method :with, :with_context
  end

end
