require 'bundler/setup'
require 'chunky_png'

module AsciiPaint
  
  # Exception raised when ASCII paint encounters a character without a paint
  # color specified.
  class CharacterNotFound < Exception; end

  # Paints a PNG based on the given ASCII art.
  #
  # Example:
  #     text = "
  #     !!!!! @@@@@ $$$$$ %%%%% ^^^^^       @@@@@ $$$$$ %%%%% ^   ^ !!!!! 
  #     !   ! @     $       %     ^         @   @ $   $   %   ^^  ^   !   
  #     !!!!! @@@@@ $       %     ^         @@@@@ $$$$$   %   ^ ^ ^   !   
  #     !   !     @ $       %     ^         @     $   $   %   ^  ^^   !   
  #     !   ! @@@@@ $$$$$ %%%%% ^^^^^ !!!!! @     $   $ %%%%% ^   ^   !   
  #     "
  #
  #     AsciiPaint.paint(text, 'out.png')
  #
  # @param  ascii_art [#to_s, Array<String>]
  #   multiline string, string array or filename with the ASCII art to paint
  # @param  out_filename [#to_s]
  #   the name of the painted PNG file
  # @param  conf [Hash<Symbol, value>]
  #   configuration settings. Keys should be the names of attributes of
  #   {AsciiPaint::Config}, such as +:character_height+.
  # @return [String]
  #   the name of the painted PNG file
  def self.paint(ascii_art, out_filename, conf = {})
    configuration = self.config.dup
    configuration.set_options(conf)

    ascii_array = ascii_art_to_array(ascii_art)
    image = ascii_to_image(ascii_array, configuration)
    save_image(image, out_filename, configuration)

    out_filename
  end

  private

  def self.ascii_art_to_array(ascii_art)
    return ascii_art if ascii_art.is_a? Array

    ascii_art = ascii_art.to_s.split("\n")
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
        raise AsciiPaint::CharacterNotFound.new "Couldn't find a color mapping for character: #{char}" unless color
        color
      end
    end
  end

  def self.painted_image(image, color_grid, configuration)
    color_grid.each_with_index do |row, y|
      row.each_with_index do |color, x|
        x_pixels, y_pixels = configuration.characters_to_pixels(x, y)
        width_pixels, height_pixels = configuration.characters_to_pixels(1, 1)
        image.rect(x_pixels, y_pixels, x_pixels + width_pixels, y_pixels + height_pixels, configuration.border_color, color)
      end
    end

    image
  end

  def self.save_image(image, filename, _)
    image.save(filename, :interlace => true)
  end

  def self.root
    Pathname.new(__FILE__).parent.parent
  end
end

require_relative 'ascii_paint/block_character.rb'
require_relative 'ascii_paint/block_string.rb'
require_relative 'ascii_paint/config.rb'
require_relative 'ascii_paint/version.rb'
