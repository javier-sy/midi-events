module MIDIEvents
  # MIDI constant lookups and mappings
  #
  # Provides a flexible system for referring to MIDI messages by their human-readable names
  # instead of numeric values. For example, "C4" for MIDI note 60, or "Bank Select" for
  # MIDI control change 0.
  #
  # Constants are loaded from a YAML dictionary (midi.yml) and organized into groups
  # (Notes, Control Changes, Status bytes, etc.).
  #
  # @example Looking up note values
  #   MIDIEvents::Constant.find('Note', 'C4')
  #   # => #<MIDIEvents::Constant::Map @key="C4", @value=60>
  #
  # @example Getting constant value directly
  #   MIDIEvents::Constant.value('Note', 'E4')
  #   # => 64
  #
  # @example Using constants in message creation
  #   MIDIEvents::NoteOn["C4"].new(0, 100)
  #   # Creates a NoteOn message for C4 (MIDI note 60)
  #
  # @api public
  module Constant
    # Get a Mapping object for the specified constant
    # @param [Symbol, String] group_name
    # @param [String] const_name
    # @return [MIDIEvents::Constant::Map, nil]
    def self.find(group_name, const_name)
      group = Group[group_name]
      group.find(const_name)
    end

    # Get the value of the specified constant
    # @param [Symbol, String] group_name
    # @param [String] const_name
    # @return [Object]
    def self.value(group_name, const_name)
      map = find(group_name, const_name)
      map.value
    end

    # Name manipulation utilities for constant lookups
    #
    # Provides methods to normalize and compare constant names in a case-insensitive
    # manner, supporting both "Control Change" and "control_change" formats.
    #
    # @api private
    module Name
      extend self

      # Convert a name to underscore format
      #
      # @example
      #   MIDIEvents::Constant::Name.underscore("Control Change")
      #   # => "control_change"
      #
      # @param [Symbol, String] string The name to convert
      # @return [String] The underscored version
      def underscore(string)
        string.to_s.downcase.gsub(/(\ )+/, '_')
      end

      # Check if two names match (case-insensitive, supports underscored or spaced)
      #
      # @example
      #   MIDIEvents::Constant::Name.match?("Control Change", "control_change")
      #   # => true
      #
      # @param [Symbol, String] key First name to compare
      # @param [Symbol, String] other Second name to compare
      # @return [Boolean] True if names match
      def match?(key, other)
        match_key = key.to_s.downcase
        [match_key, Name.underscore(match_key)].include?(other.to_s.downcase)
      end
    end

    # Container for a group of related MIDI constants
    #
    # Groups organize constants by category (e.g., "Note", "Control Change", "Status").
    # Each group contains multiple Map objects that pair constant names with their values.
    #
    # @example Accessing a constant group
    #   group = MIDIEvents::Constant::Group['Note']
    #   group.find('C4')  # => Map object for C4
    #
    # @api public
    class Group
      # @return [Array<MIDIEvents::Constant::Map>] The constants in this group
      attr_reader :constants

      # @return [String] The group's key/name
      attr_reader :key

      # Create a new constant group
      #
      # @param [String] key The group identifier
      # @param [Hash] constants Hash of constant names to values
      def initialize(key, constants)
        @key = key
        @constants = constants.map { |k, v| Constant::Map.new(k, v) }
      end

      # Find a constant in this group by its name
      #
      # @example
      #   group = MIDIEvents::Constant::Group['Note']
      #   group.find('E4')  # => Map for E4 (value 64)
      #
      # @param [String, Symbol] name The constant name to find
      # @return [MIDIEvents::Constant::Map, nil] The matching constant or nil
      def find(name)
        @constants.find { |const| Name.match?(const.key, name) }
      end

      # Find a constant in this group by its value (reverse lookup)
      #
      # @example
      #   group = MIDIEvents::Constant::Group['Note']
      #   group.find_by_value(64)  # => Map for E4
      #
      # @param [Object] value The numeric value to find
      # @return [MIDIEvents::Constant::Map, nil] The matching constant or nil
      def find_by_value(value)
        @constants.find { |const| Name.match?(const.value, value) }
      end

      class << self
        # All constant groups
        # @return [Array<ConstantGroup>]
        def all
          ensure_initialized
          @groups
        end

        # Find a constant group by its key
        # @param [String, Symbol] key
        # @return [ConstantGroup]
        def find(key)
          ensure_initialized
          @groups.find { |group| Name.match?(group.key, key) }
        end
        alias [] find

        private

        # Lazy initialize
        # @return [Boolean]
        def ensure_initialized
          populate_dictionary | populate_groups
        end

        # Populate the dictionary of constants
        # @return [Boolean]
        def populate_dictionary
          return unless @dict.nil?

          file = File.expand_path('../midi.yml', __dir__)
          @dict = YAML.load_file(file)
          @dict.freeze
          true
        end

        # Populate the constant groups using the dictionary
        # @return [Boolean]
        def populate_groups
          return unless @groups.nil? && !@dict.nil?

          @groups = @dict.map { |k, v| new(k, v) }
          true
        end

      end

    end

    # A single constant mapping (name to value pair)
    #
    # Represents an individual MIDI constant, pairing a human-readable name
    # with its numeric MIDI value.
    #
    # @example
    #   map = MIDIEvents::Constant::Map.new("C4", 60)
    #   map.key    # => "C4"
    #   map.value  # => 60
    #
    # @api public
    class Map
      # @return [String] The human-readable name of the constant
      attr_reader :key

      # @return [Object] The numeric MIDI value
      attr_reader :value

      # Create a new constant mapping
      #
      # @param [String] key The constant name (e.g., "C4", "Note On")
      # @param [Object] value The constant value (e.g., 60, 0x9)
      def initialize(key, value)
        @key = key
        @value = value
      end
    end

    # Helper class for building messages with pre-bound constants
    #
    # This class is returned when you call a message class's bracket method
    # with a constant name (e.g., NoteOn["C4"]). It stores the constant
    # and message class so that when you call #new, it creates the message
    # with the constant value already filled in.
    #
    # @example
    #   builder = MIDIEvents::NoteOn["C4"]
    #   note = builder.new(0, 100)  # channel 0, velocity 100
    #   # The note value (60 for C4) is automatically filled in
    #
    # @api private
    class MessageBuilder
      # Create a new message builder
      #
      # @param [Class] klass The message class to build (e.g., NoteOn)
      # @param [MIDIEvents::Constant::Map] const The constant to build with
      def initialize(klass, const)
        @klass = klass
        @const = const
      end

      # Create a message instance with the bound constant
      #
      # @param [Array] args The remaining arguments for the message constructor
      # @return [MIDIEvents::Message] The constructed message
      def new(*args)
        args = args.dup
        args.last.is_a?(Hash) ? args.last[:const] = @const : args.push(const: @const)
        @klass.new(*args)
      end
    end

    # Shortcuts for dealing with MIDI status bytes
    #
    # Provides quick lookup of status byte values by their human-readable names
    # (e.g., "Note On" => 0x9).
    #
    # @example
    #   MIDIEvents::Constant::Status['Note On']  # => 0x9
    #   MIDIEvents::Constant::Status['Control Change']  # => 0xB
    #
    # @api public
    module Status
      extend self

      # Find a status byte value by its name
      #
      # @param [String, Symbol] status_name The name of the status (e.g., "Note On")
      # @return [Integer, nil] The status nibble value or nil if not found
      def find(status_name)
        const = Constant.find('Status', status_name)
        const&.value
      end
      alias [] find
    end

    # Internal system for loading constants into message objects
    #
    # Handles the automatic population of message metadata (names, verbose names)
    # based on constant definitions in midi.yml.
    #
    # @api private
    module Loader
      extend self

      # Get the property index for a constant in a message
      #
      # @param [MIDIEvents::Message] message The message to inspect
      # @return [Integer] The index of the constant property
      def get_index(message)
        key = message.class.constant_property
        message.class.properties.index(key) || 0
      end

      # Populate message metadata using constant information from midi.yml
      #
      # Looks up the constant for a message and returns metadata including
      # the constant object, name, and verbose name.
      #
      # @param [MIDIEvents::Message] message The message to populate
      # @return [Hash, nil] Hash with :const, :name, :verbose_name keys, or nil
      def get_info(message)
        const_group_name = message.class.display_name
        group_name_alias = message.class.constant_name
        property = message.class.constant_property
        value = message.send(property) unless property.nil?
        value ||= message.status[1] # default property to use for constants
        group = Constant::Group[group_name_alias] || Constant::Group[const_group_name]
        unless group.nil?
          unless (const = group.find_by_value(value)).nil?
            {
              const: const,
              name: const.key,
              verbose_name: "#{message.class.display_name}: #{const.key}"
            }
          end
        end
      end

      # DSL class methods for message classes to work with constants
      #
      # These methods are extended into message classes to provide constant lookup
      # functionality (e.g., NoteOn["C4"]).
      #
      # @api private
      module DSL
        # Find a constant value in this class's group for the passed in key
        # @param [String] name The constant key
        # @return [String] The constant value
        def get_constant(name)
          key = constant_name || display_name
          return if key.nil?

          group = Group[key]
          group.find(name)
        end

        # @return [String]
        def display_name
          const_get('DISPLAY_NAME') if const_defined?('DISPLAY_NAME')
        end

        # @return [Hash]
        def constant_map
          const_get('CONSTANT') if const_defined?('CONSTANT')
        end

        # @return [String]
        def constant_name
          constant_map&.keys&.first
        end

        # @return [Symbol]
        def constant_property
          constant_map[constant_name] unless constant_map.nil?
        end

        # Get the status nibble for this particular message type
        # @return [Fixnum] The status nibble
        def type_for_status
          Constant::Status[display_name]
        end

        # Find a constant and return a MessageBuilder bound to it
        #
        # This enables the bracket syntax: NoteOn["C4"].new(channel, velocity)
        #
        # @example
        #   builder = MIDIEvents::NoteOn["C4"]
        #   note = builder.new(0, 100)  # Creates NoteOn for C4 on channel 0
        #
        # @param [String, Symbol] const_name The constant name to look up
        # @return [MIDIEvents::Constant::MessageBuilder, nil] Builder or nil if not found
        def find(const_name)
          const = get_constant(const_name.to_s)
          MessageBuilder.new(self, const) unless const.nil?
        end
        alias [] find
      end
    end
  end
end
