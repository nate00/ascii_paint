require 'spec_helper'
require 'ascii_paint'
require 'pry'

describe AsciiPaint do

  let(:input_filename) { Helpers.fixtures_directory.join('ascii.txt') }

  before(:each) do
    Helpers.cd_work_directory
  end

  after(:each) do
    Helpers.rm_rf_work_directory
    AsciiPaint.config.reset!
  end

  it "does math good" do
    (1 + 1).should eq(2)
  end

  it "writes a file" do
    AsciiPaint.paint("ASCII\npaint", OUTPUT_FILENAME)
    File.should be_a_file OUTPUT_FILENAME
  end

  it "paints the correct dimensions" do
    AsciiPaint.paint("ASCII\npaint", OUTPUT_FILENAME, character_width: 10, character_height: 10)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    result.height.should eq(2 * 10)
    result.width.should eq(5 * 10)
  end

  it "paints the correct colors" do
    AsciiPaint.paint("ASCII\npaint", OUTPUT_FILENAME, character_width: 10, color_map: {'S' => :blue})
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    color = result.get_pixel(15, 0)
    red = ChunkyPNG::Color.r(color)
    green = ChunkyPNG::Color.g(color)
    blue = ChunkyPNG::Color.b(color)
    [red, green, blue].should eq([0, 0, 255])
  end

  it "accepts a multiline string input" do
    multiline_string = "ASCII\npaint"
    AsciiPaint.paint(multiline_string, OUTPUT_FILENAME, character_width: 10, character_height: 10)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    result.height.should eq(2 * 10)
    result.width.should eq(5 * 10)
  end

  it "accepts a string array input" do
    string_array = ["ASCII", "paint"]
    AsciiPaint.paint(string_array, OUTPUT_FILENAME, character_width: 10, character_height: 10)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    result.height.should eq(2 * 10)
    result.width.should eq(5 * 10)
  end

  it "accepts a filename input" do
    AsciiPaint.paint(input_filename, OUTPUT_FILENAME, character_width: 10, character_height: 10)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    result.height.should eq(2 * 10)
    result.width.should eq(5 * 10)
  end

  it "obeys AsciiPaint.config configuration" do
    AsciiPaint.config do |config|
      config.character_height = 100
    end

    AsciiPaint.paint(input_filename, OUTPUT_FILENAME)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    result.height.should eq(2 * 100)
  end

  it "obeys per-method-call configuration" do
    AsciiPaint.paint("ASCII\npaint", OUTPUT_FILENAME, character_width: 10, character_height: 10)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    result.height.should eq(2 * 10)
    result.width.should eq(5 * 10)
  end

  it "overrides global config with local config" do
    AsciiPaint.config do |config|
      config.character_height = 100
    end

    AsciiPaint.paint(input_filename, OUTPUT_FILENAME, character_height: 77)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    result.height.should eq(2 * 77)
  end

  it "paints transparent paint" do
    AsciiPaint.paint("ASCII\npaint", OUTPUT_FILENAME, character_width: 10, color_map: {'S' => :transparent})
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    color = result.get_pixel(15, 0)
    alpha = ChunkyPNG::Color.a(color)
    alpha.should eq(0)
  end

  it "deletes temporary files" do
    AsciiPaint.paint("ASCII\npaint", OUTPUT_FILENAME) do |f|
      File.should be_a_file OUTPUT_FILENAME
    end

    File.should_not be_a_file OUTPUT_FILENAME
  end
end
