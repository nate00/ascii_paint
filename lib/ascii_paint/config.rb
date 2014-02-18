# An instance of class +AsciiPaint::Config+ is used to set global configuration
# options for ASCII paint. Pass a block to {AsciiPaint.config} to access this
# object.

class AsciiPaint::Config

  SPECIAL_SYMBOL_MAP = {
    transparent: AsciiPaint::TRANSPARENT
  }

  # The horizontal size in pixels of the rectangle that replaces a single
  # character during painting.
  attr_accessor :character_width

  # The vertical size in pixels of the rectangle that replaces a single
  # character during painting.
  attr_accessor :character_height

  def initialize(settings = {})
    set_attributes(settings)
  end

  class << self
    alias_method :default, :new
  end

  # Merge new mappings into the color map.
  #
  # The color map specifies which color paints over each character. For example,
  #     config.color_map = { 'a' => :blue }
  # tells ASCII paint to replace the character 'a' with the color blue.
  #
  # @param  hash [Hash<String, Symbol>]
  #   the new mappings to be merged into the color map.
  # @return [void]
  def color_map=(hash)
    replace_special_symbols!(hash)
    @color_map = color_map.merge(hash)
  end

  # Set the color to paint over characters whose color hasn't been defined by
  # the color map.
  #
  # @param default_color [Symbol]
  #   the default color to replace characters without a specified color.
  # @return [void]
  def color_for_undefined_character=(default_color)
    color_map.default = replacement_for_special_symbol(default_color)
  end

  # The color map defining which colors will paint over which characters.
  #
  # @return hash [Hash<String, Symbol>]
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

  # Set configuration options using a hash instead of using method calls. For
  # example,
  #     config.set_attributes({character_width: 10})
  # is equivalent to
  #     config.character_width = 10
  #
  # @param  settings [Hash<Symbol, value>]
  #   settings mapping from attribute name to value.
  # @return [void]
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

  public

  # Default values for configuration settings.
  module Default
    private

    def self.rainbow_mapping(characters)
      # Thanks jbum (http://krazydad.com/tutorials/makecolors.php)
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

end

module AsciiPaint
  # Passes an instance of {AsciiPaint::Config} to the given block. Used to set
  # global configuration.
  #
  # @return [Config] the global configuration
  def self.config
    @configuration ||= Config.default
    yield(@configuration) if block_given?
    @configuration
  end
end
