require 'bundler/setup'
require 'ascii_paint'
require 'pry'

AsciiPaint.config do |c|
  c.character_width = 20
  c.character_height = 50
  c.color_map = { '$' => :rosybrown }
  c.color_for_undefined_character = :black
end

AsciiPaint.paint('ascii.txt', 'output.png', color_map: {'@' => :black}, character_width: 5)
