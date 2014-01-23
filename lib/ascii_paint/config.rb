class AsciiPaint::Config

  module Default
    private

    def self.rainbow_mapping(characters)
      hash = {}
      period = Math::PI * 2
      frequency = period / characters.count
      characters.each_with_index do |char, index|
        r = Math.cos(frequency * index + 0) * 127 + 128;
        g = Math.cos(frequency * index + period / 3) * 127 + 128;
        b = Math.cos(frequency * index + period * 2 / 3) * 127 + 128;
        color = ChunkyPNG::Color.rgb(r.to_i, g.to_i, b.to_i)
        hash[char] = color
      end
      hash
    end

    public

    CHARACTER_HEIGHT = 16
    CHARACTER_WIDTH = 8
    COLOR_FOR_UNDEFINED_CHARACTER = :black
    COLOR_MAP =
      begin
        map = {
          ' ' => :transparent,

          '!' => :red,
          '@' => :orange,
          '#' => :yellow,
          '$' => :green,
          '%' => :blue,
          '^' => :purple,

          '_' => :white,
          '~' => :black,

          '<' => :lightgrey,
          '>' => :grey,
          '?' => :darkgrey,
          ',' => :lightslategrey,
          '.' => :slategrey,
          '/' => :darkslategrey,
          '\\' => :dimgrey,

          ':' => :chocolate,
          ';' => :blanchedalmond,
          '\'' => :coral,
          '"' => :deepskyblue,
          '{' => :indigo,
          '}' => :ivory,
          '[' => :khaki,
          ']' => :lavender,
          '|' => :hotpink,
          '&' => :darksalmon,
          '*' => :lime,
          '(' => :lightyellow,
          ')' => :honeydew,
          '-' => :azure,
          '+' => :crimson,
          '=' => :antiquewhite,
          '`' => :cornsilk
        }

        letters = ('a'..'z').zip('A'..'Z').flatten  # ['a', 'A', 'b', 'B', ...]
        map.merge! rainbow_mapping(letters)

        numbers = ('0'..'9')
        map.merge! rainbow_mapping(numbers)

        map
      end
  end

  SPECIAL_SYMBOL_MAP = {
    transparent: AsciiPaint::TRANSPARENT
  }

  attr_accessor :character_width, :character_height

  def initialize(settings = {})
    set_attributes(settings)
  end

  class << self
    alias_method :default, :new
  end

  def color_map=(hash)
    replace_special_symbols!(hash)
    @color_map = color_map.merge(hash)
  end

  def color_for_undefined_character=(color)
    color_map.default = replacement_for_special_symbol(color)
  end

  def color_map
    @color_map ||=
      begin
        map = Default::COLOR_MAP.dup
        map.default = Default::COLOR_FOR_UNDEFINED_CHARACTER
        replace_special_symbols!(map)
        map
      end
  end

  def character_width
    @character_width ||= Default::CHARACTER_WIDTH
  end

  def character_height
    @character_height ||= Default::CHARACTER_HEIGHT
  end

  def characters_to_pixels(x, y)
    [x * character_width, y * character_height]
  end

  def set_attributes(setting)
    setting.each do |key, value|
      mutator_name = "#{key}="
      self.send(mutator_name, value)
    end
  end

  private

  def replace_special_symbols!(hash)
    hash.each do |char, color_sym|
      hash[char] = replacement_for_special_symbol(color_sym)
    end
  end

  def replacement_for_special_symbol(symbol)
    SPECIAL_SYMBOL_MAP[symbol] || symbol
  end
end

module AsciiPaint
  def self.config
    @configuration ||= Config.default
    yield(@configuration) if block_given?
    @configuration
  end
end
