require 'bundler/setup'
require 'ascii_paint'

this_directory = File.dirname(__FILE__)
text_file = File.join(this_directory, 'ascii.txt')
image_file = File.join(this_directory, 'output.png')
AsciiPaint.paint(text_file, image_file)
