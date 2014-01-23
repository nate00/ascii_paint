require 'bundler/setup'
require 'chunky_png'

module AsciiPaint
  
  class UndefinedCharacter < Exception; end

  TRANSPARENT = ChunkyPNG::Color::TRANSPARENT
  BORDER_COLOR = TRANSPARENT

  # ascii_art - multiline string, string array, or filename
  # out_filename - name of PNG file to output
  # config:
  #   color_map
  #   character_width
  #   character_height
  #   color_for_undefined_character
  #
  def self.paint(ascii_art, out_filename, conf = {})
    configuration = self.config.dup
    configuration.set_attributes(conf)

    ascii_array = ascii_art_to_array(ascii_art)
    image = ascii_to_image(ascii_array, configuration)
    save_image(image, out_filename, configuration)
  end

  private

  def self.ascii_art_to_array(ascii_art)
    ascii_art = ascii_art.split("\n") if ascii_art.is_a? String
    if ascii_art.size == 1
      ascii_art = File.open(ascii_art[0], 'r').to_a.map(&:chomp)
    end
    ascii_art
  end

  def self.ascii_to_image(ascii_array, configuration)
    colors_grid = ascii_to_colors(ascii_array, configuration)
    image = blank_image(ascii_array, configuration)
    painted_image(image, colors_grid, configuration)
  end
  
  def self.blank_image(lines, configuration)
    height = lines.size
    width = lines.map(&:size).max

    width_pixels, height_pixels = configuration.characters_to_pixels(width, height)
    png = ChunkyPNG::Image.new(width_pixels, height_pixels, configuration.color_map[' '])
  end

  def self.ascii_to_colors(strings, configuration)
    strings.map do |line|
      line.chars.map do |char|
        color = configuration.color_map[char]
        raise AsciiPaint::UndefinedCharacter.new "Couldn't find a color mapping for character: #{char}" unless color
        color
      end
    end
  end

  def self.painted_image(image, color_grid, configuration)
    color_grid.each_with_index do |row, y|
      row.each_with_index do |color, x|
        x_pixels, y_pixels = configuration.characters_to_pixels(x, y)
        width_pixels, height_pixels = configuration.characters_to_pixels(1, 1)
        image.rect(x_pixels, y_pixels, x_pixels + width_pixels, y_pixels + height_pixels, BORDER_COLOR, color)
      end
    end

    image
  end

  def self.save_image(image, filename, _)
    image.save(filename, :interlace => true)
  end
end

require_relative 'ascii_paint/config.rb'
