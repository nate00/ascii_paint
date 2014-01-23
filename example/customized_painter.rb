require 'bundler/setup'
require 'ascii_paint'

AsciiPaint.config do |c|
  c.character_width = 20
  c.character_height = 50
  c.color_map = { ' ' => :black }
end

this_directory = File.dirname(__FILE__)
text_file = File.join(this_directory, 'ascii.txt')
image_file = File.join(this_directory, 'output.png')
AsciiPaint.paint(text_file, image_file)
