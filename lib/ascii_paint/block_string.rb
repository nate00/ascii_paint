module AsciiPaint
  class BlockString
    attr_reader :block_characters

    def initialize(string)
      @block_characters = string.chars.map { |char| BlockCharacter.new(char) }
    end

    def to_a
      array = []

      # TODO: DRY and ruby-ify this loop
      block_row = nil
      block_characters.each do |block_char|
        block_row ||= [''] * BlockCharacter.height

        if block_char.newline?
          array += block_row
          block_row = nil
        else
          block_row.map!.with_index do |row, i|
            row + block_char.ascii[i]
          end
        end
      end
      array += block_row

      array
    end
  end
end

module AsciiPaint
  # TODO: support filename arguments
  # TODO: write tests
  # TODO: write docs
  def self.block_paint(block_string, out_filename, conf = {})
    block_string = block_string.join("\n") if block_string.respond_to? :join
    ascii_art = BlockString.new(block_string).to_a
    paint(ascii_art, out_filename, conf)
  end
end
