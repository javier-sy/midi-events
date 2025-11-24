module MIDIEvents

  # Utilities for converting between different MIDI data representations
  #
  # Provides methods to convert between hex strings, nibbles, and numeric byte arrays.
  # Useful for working with MIDI data in different formats.
  #
  # @example Converting hex string to bytes
  #   MIDIEvents::TypeConversion.hex_string_to_numeric_byte_array("904040")
  #   # => [0x90, 0x40, 0x40]
  #
  # @example Converting bytes to hex string
  #   MIDIEvents::TypeConversion.numeric_byte_array_to_hex_string([0x90, 0x40, 0x40])
  #   # => "904040"
  #
  # @api public
  module TypeConversion

    extend self

    # Convert an array of hex character nibbles to numeric bytes
    #
    # Pairs nibbles together to form bytes. If there's an odd number of nibbles,
    # the second-to-last nibble is removed.
    #
    # @example
    #   hex_chars_to_numeric_byte_array(["9", "0", "4", "0"])
    #   # => [0x90, 0x40]
    #
    # @param [Array<String>] nibbles Array of hex character strings (e.g., ["9", "0", "4", "0"])
    # @return [Array<Integer>] Array of numeric bytes (e.g., [0x90, 0x40])
    def hex_chars_to_numeric_byte_array(nibbles)
      nibbles = nibbles.dup # Don't mess with the input
      # get rid of last nibble if there's an odd number
      # it will be processed later anyway
      nibbles.slice!(nibbles.length-2, 1) if nibbles.length.odd?
      bytes = []
      while !(nibs = nibbles.slice!(0,2)).empty?
        byte = (nibs[0].hex << 4) + nibs[1].hex
        bytes << byte
      end
      bytes
    end
    
    # Convert a hex string to an array of numeric bytes
    #
    # @example
    #   hex_string_to_numeric_byte_array("904040")
    #   # => [0x90, 0x40, 0x40]
    #
    # @param [String] string A string of hex digits (e.g., "904040")
    # @return [Array<Integer>] An array of numeric bytes (e.g., [0x90, 0x40, 0x40])
    def hex_string_to_numeric_byte_array(string)
      string = string.dup
      bytes = []
      until string.length == 0
        bytes << string.slice!(0, 2).hex
      end
      bytes
    end
    
    # Convert a hex string to an array of character nibbles
    #
    # @example
    #   hex_str_to_hex_chars("904040")
    #   # => ["9", "0", "4", "0", "4", "0"]
    #
    # @param [String] string A string of hex digits (e.g., "904040")
    # @return [Array<String>] An array of individual hex character nibbles
    def hex_str_to_hex_chars(string)
      string.split(//)    
    end
    
    # Convert an array of numeric bytes to an uppercase hex string
    #
    # @example
    #   numeric_byte_array_to_hex_string([0x90, 0x40, 0x40])
    #   # => "904040"
    #
    # @param [Array<Integer>] bytes An array of numeric bytes (e.g., [0x90, 0x40, 0x40])
    # @return [String] An uppercase hex string (e.g., "904040")
    def numeric_byte_array_to_hex_string(bytes)
      string_bytes = bytes.map do |byte| 
        string = byte.to_s(16)
        string = "0#{string}" if string.length == 1
        string
      end
      string_bytes.join.upcase
    end
    
    # Convert a numeric byte to hex character nibbles
    #
    # @example
    #   numeric_byte_to_hex_chars(0x90)
    #   # => ["9", "0"]
    #
    # @param [Integer] num A numeric byte (e.g., 0x90)
    # @return [Array<String>] An array of two hex character nibbles (e.g., ["9", "0"])
    def numeric_byte_to_hex_chars(num)
      nibbles = numeric_byte_to_nibbles(num)
      nibbles.map { |n| n.to_s(16) }      
    end

    # Split a numeric byte into its high and low nibbles
    #
    # @example
    #   numeric_byte_to_nibbles(0x90)
    #   # => [0x9, 0x0]
    #
    # @param [Integer] num A numeric byte (e.g., 0x90)
    # @return [Array<Integer>] An array of two nibbles [high, low] (e.g., [0x9, 0x0])
    def numeric_byte_to_nibbles(num)
      [((num & 0xF0) >> 4), (num & 0x0F)]
    end

  end
  
end
