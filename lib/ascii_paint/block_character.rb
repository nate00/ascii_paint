module AsciiPaint
  class BlockCharacter
    attr_reader :ascii

    # TODO: make customizable
    UNPADDED_HEIGHT = 5
    UNPADDED_WIDTH = 5
    VERTICAL_PADDING = 2
    HORIZONTAL_PADDING = 2

    def initialize(character)
      raise "Only single characters please! #{character}" unless character.size == 1

      if character == "\n"
        @newline = true
        return
      end

      load_ascii(character)
    end

    def newline?
      @newline == true
    end

    def to_s
      ascii.join("\n")
    end

    def self.height
      UNPADDED_HEIGHT + VERTICAL_PADDING
    end

    def self.width
      UNPADDED_WIDTH + HORIZONTAL_PADDING
    end

    def self.left_padding
      HORIZONTAL_PADDING / 2
    end

    def self.right_padding
      (HORIZONTAL_PADDING + 1) / 2
    end

    def self.top_padding
      VERTICAL_PADDING / 2
    end

    def self.bottom_padding
      (VERTICAL_PADDING + 1) / 2
    end

    private

    # TODO: filename escaping
    def load_ascii(character)
      path = path_for character
      if File.exist?(path)
        @ascii = File.open(path, 'r').to_a.map(&:chomp)
        @ascii = pad_ascii(@ascii)
      else
        raise "Character not supported: #{character}"
      end
    end

    def path_for(character)
      # Use ASCII codes!
      block_characters_dir.join "#{character.ord}.txt"
    end

    def pad_ascii(ascii)
      left = " " * self.class.left_padding
      right = " " * self.class.right_padding
      padded = ascii.map do |row|
        "#{left}#{row}#{right}"
      end

      blank_row = " " * self.class.width
      self.class.top_padding.times { padded.unshift(blank_row) }
      self.class.bottom_padding.times { padded.push(blank_row) }

      padded
    end

    def block_characters_dir
      AsciiPaint.root.join('data', 'block_characters')
    end
  end
end
