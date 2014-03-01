module AsciiPaint
  class BlockString
    attr_reader :block_characters

    def initialize(string)
      @block_characters = string.chars.map { |char| BlockCharacter.new(char) }
    end

    def rows
      block_characters.inject([[]]) do |rows, block_char|
        if block_char.newline?
          rows << []
        else
          rows.last << block_char
        end
        rows
      end
    end

    def to_a
      rows.flat_map do |block_row|
        (0...BlockCharacter.height).map do |h|
          block_row.inject('') do |string_row, block_char|
            string_row + block_char.ascii[h]
          end
        end
      end
    end
  end
end

module AsciiPaint
  # TODO: support filename arguments
  # TODO: write tests
  # TODO: write docs
  def self.block_paint(block_string, out_filename, conf = {}, &block)
    block_string = block_string.join("\n") if block_string.respond_to? :join
    ascii_art = BlockString.new(block_string).to_a
    paint(ascii_art, out_filename, conf, &block)
  end
end
