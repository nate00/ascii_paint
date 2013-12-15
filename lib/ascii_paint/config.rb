class AsciiPaint::Config

  module Default
    CHARACTER_HEIGHT = 16
    CHARACTER_WIDTH = 8
    COLOR_MAP = {
      ' ' => :white,
      '#' => :blue
    }
  end

  attr_accessor :background, :character_width, :character_height

  def initialize(settings = {})
    set_attributes(settings)
  end

  def self.default
    self.class.new
  end

  def color_map=(hash)
    @color_map = color_map.merge(hash)
  end

  def color_for_undefined_character=(color)
    color_map.default = color
  end

  def color_map
    @color_map ||= Default::COLOR_MAP
  end

  def background
    @background ||= ChunkyPNG::Color::TRANSPARENT
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

  private

  def set_attributes(setting)
    setting.each do |key, value|
      mutator_name = "#{key}="
      self.send(mutator_name, [value])
    end
  end
end

module AsciiPaint
  def config
    @config ||= Config.default
    yield(@config) if block_given?
    @config
  end
end
