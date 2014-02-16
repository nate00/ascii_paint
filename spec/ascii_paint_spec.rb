require 'ascii_paint'
require 'pry'

describe AsciiPaint do
  FILENAME = 'painted.png'

  let(:input_filename) { Helpers.fixtures_directory.join('ascii.txt') }

  before(:each) do
    Helpers.cd_work_directory
  end

  after(:each) do
    Helpers.rm_rf_work_directory
  end

  it "does math good" do
    (1 + 1).should eq(2)
  end

  it "writes a file" do
    AsciiPaint.paint("ASCII\npaint", FILENAME)
    File.should be_a_file FILENAME
  end

  it "paints the correct dimensions" do
    AsciiPaint.paint("ASCII\npaint", FILENAME, character_width: 10, character_height: 10)
    result = ChunkyPNG::Image.from_file(FILENAME)
    result.height.should eq(2 * 10)
    result.width.should eq(5 * 10)
  end

  it "paints the correct colors" do
    AsciiPaint.paint("ASCII\npaint", FILENAME, character_width: 10, color_map: {'S' => :blue})
    result = ChunkyPNG::Image.from_file(FILENAME)
    color = result.get_pixel(15, 0)
    red = ChunkyPNG::Color.r(color)
    green = ChunkyPNG::Color.g(color)
    blue = ChunkyPNG::Color.b(color)
    [red, green, blue].should eq([0, 0, 255])
  end

  it "accepts a multiline string input" do
    multiline_string = "ASCII\npaint"
    AsciiPaint.paint(multiline_string, FILENAME, character_width: 10, character_height: 10)
    result = ChunkyPNG::Image.from_file(FILENAME)
    result.height.should eq(2 * 10)
    result.width.should eq(5 * 10)
  end

  it "accepts a string array input" do
    string_array = ["ASCII", "paint"]
    AsciiPaint.paint(string_array, FILENAME, character_width: 10, character_height: 10)
    result = ChunkyPNG::Image.from_file(FILENAME)
    result.height.should eq(2 * 10)
    result.width.should eq(5 * 10)
  end

  it "accepts a filename input" do
    AsciiPaint.paint(input_filename, FILENAME, character_width: 10, character_height: 10)
    result = ChunkyPNG::Image.from_file(FILENAME)
    result.height.should eq(2 * 10)
    result.width.should eq(5 * 10)
  end

  it "obeys AsciiPaint.config configuration" do
    pending "figure out how to make this test not pollute others"
  end

  it "obeys per-method-call configuration" do
    AsciiPaint.paint("ASCII\npaint", FILENAME, character_width: 10, character_height: 10)
    result = ChunkyPNG::Image.from_file(FILENAME)
    result.height.should eq(2 * 10)
    result.width.should eq(5 * 10)
  end

  it "overrides global config with local config" do
    pending "figure out how to make this test not pollute others"
  end

  it "paints transparent paint" do
    AsciiPaint.paint("ASCII\npaint", FILENAME, character_width: 10, color_map: {'S' => :transparent})
    result = ChunkyPNG::Image.from_file(FILENAME)
    color = result.get_pixel(15, 0)
    alpha = ChunkyPNG::Color.a(color)
    alpha.should eq(0)
  end
end
