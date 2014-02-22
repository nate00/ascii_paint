module AsciiPaint
  class BlockString
    attr_reader :block_characters

    def initialize(string)
      @block_characters = string.chars.map { |char| BlockCharacter.new(char) }
    end

    def each_row
      return to_enum(:each_row) unless block_given?

      rows =
        block_characters.chunk do |block_char|
          if block_char.newline?
            nil
          else
            :not_newline
          end
        end.map do |symbol, row|
          row
        end

      rows.each do |row|
        yield row
      end
    end

    def to_a
      each_row.flat_map do |block_row|
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
  def self.block_paint(block_string, out_filename, conf = {})
    block_string = block_string.join("\n") if block_string.respond_to? :join
    ascii_art = BlockString.new(block_string).to_a
    paint(ascii_art, out_filename, conf)
  end
end
