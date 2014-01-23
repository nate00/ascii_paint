class AsciiPaint::Config

  module Default
    CHARACTER_HEIGHT = 16
    CHARACTER_WIDTH = 8
    COLOR_MAP = {
      ' ' => :transparent,
      '_' => :white,
      '!' => :red,
      '@' => :orange,
      '#' => :yellow,
      '$' => :green,
      '%' => :blue,
      '^' => :purple,
      '~' => :black
    }
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
        color_map = Default::COLOR_MAP.dup
        replace_special_symbols!(color_map)
        color_map
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
