module MIDIEvents
  # Common behavior amongst Channel Message types
  module ChannelMessage
    include MIDIEvents # this enables ..kind_of?(MIDIEvents)

    attr_reader :data, :name

    # Shortcut to RawChannelMessage.new
    # aka build a ChannelMessage from raw nibbles and bytes
    # eg ChannelMessage.new(0x9, 0x0, 0x40, 0x40)
    # @param [*Fixnum] data The status nibbles and data bytes
    # @return [RawChannelMessage] The resulting RawChannelMessage object
    def self.new(*data, &block)
      Message.new(*data, &block)
    end

    # @param [*Fixnum] data The status nibbles and data bytes
    def initialize(*data)
      data = data.dup
      options = data.last.is_a?(Hash) ? data.pop : {}
      add_constant_value(options[:const], data) unless options[:const].nil?
      initialize_channel_message(self.class.type_for_status, *data)
    end

    private

    def self.included(base)
      base.send(:include, ::MIDIEvents::Message)
      base.send(:extend, ClassMethods)
    end

    # Add the given constant to message data
    def add_constant_value(constant, data)
      index = Constant::Loader.get_index(self)
      data.insert(index, constant.value)
    end

    # Assign the message data
    def assign_data(status_nibble_1, status_nibble_2, data_byte_1, data_byte_2 = 0)
      @status = [status_nibble_1, status_nibble_2]
      @data = [data_byte_1]
      @data[1] = data_byte_2 if self.class.second_data_byte?
    end

    # Initialize the message: assign data, decorate with accessors
    def initialize_channel_message(status_nibble_1, status_nibble_2, data_byte_1, data_byte_2 = 0)
      assign_data(status_nibble_1, status_nibble_2, data_byte_1, data_byte_2)
      Accessors.initialize(self) unless self.class.properties.nil?
      initialize_message(status_nibble_1, status_nibble_2)
    end

    class Accessors
      SCHEMA = [
        { name: :status, index: 1 }, # second status nibble
        { name: :data, index: 0 }, # first data byte
        { name: :data, index: 1 } # second data byte
      ].freeze

      # @param [Class] klass
      # @return [Class]
      def self.decorate(klass)
        decorator = new(klass)
        decorator.decorate
      end

      # Initialize a message object with it's properties
      # @param [MIDIEvents] message
      # @return [Boolean]
      def self.initialize(message)
        message.class.properties.each_with_index do |property, i|
          data_mapping = SCHEMA[i]
          container = message.send(data_mapping[:name])
          index = data_mapping[:index]
          message.send(:instance_variable_set, "@#{property.to_s}", container[index])
        end
        true
      end

      # @param [Class] klass
      def initialize(klass)
        @klass = klass
      end

      # @return [Class]
      def decorate
        @klass.properties.each_with_index do |property, i|
          data_mapping = SCHEMA[i]
          define_getter(property)
          define_setter(property, data_mapping)
        end
        @klass
      end

      private

      # @param [Symbol, String] property
      # @return [Boolean]
      def define_getter(property)
        @klass.send(:attr_reader, property)
        true
      end

      # @param [Symbol, String] property
      # @param [Hash] mapping
      # @return [Boolean]
      def define_setter(property, mapping)
        index = mapping[:index]
        @klass.send(:define_method, "#{property.to_s}=") do |value|
          send(:instance_variable_set, "@#{property.to_s}", value)
          send(mapping[:name])[index] = value
          send(:update)
          return self
        end
        true
      end

    end

    # For defining Channel Message class types
    module ClassMethods
      def properties
        const_get('DATA') if const_defined?('DATA')
      end

      # Does the schema of this Channel Message carry a second data byte?
      # eg. NoteMessage does, and ProgramChange doesn"t
      # @return [Boolean] Is there a second data byte on this message type?
      def second_data_byte?
        properties.nil? || (properties.length - 1) > 1
      end

    end

    # Use this if you want to instantiate a raw channel message
    #
    # For example ChannelMessage::Message.new(0x9, 0x0, 0x40, 0x57)
    # creates a raw note-on message
    class Message
      include ChannelMessage

      DISPLAY_NAME = 'Channel Message'.freeze

      # Build a Channel Message from raw nibbles and bytes
      # eg ChannelMessage.new(0x9, 0x0, 0x40, 0x40)
      # @param [*Fixnum] data The status nibbles and data bytes
      # @return [RawChannelMessage] The resulting RawChannelMessage object
      def initialize(*data)
        initialize_channel_message(*data)
      end
    end
  end
end
