require 'ascii_paint'
require 'pry'

describe AsciiPaint::BlockString do

  before(:each) do
    Helpers.cd_work_directory
  end

  after(:each) do
    Helpers.rm_rf_work_directory
    AsciiPaint.config.reset!
  end

  it "writes a file" do
    AsciiPaint.block_paint("ASCII", OUTPUT_FILENAME)
    File.should be_a_file OUTPUT_FILENAME
  end

  it "obeys local configuration" do
    AsciiPaint.block_paint("ASCII", OUTPUT_FILENAME, character_height: 100)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    result.height.should eq(100 * AsciiPaint::BlockCharacter.height)
  end

  it "obeys global configuration" do
    AsciiPaint.config do |config|
      config.character_height = 100
    end

    AsciiPaint.block_paint("ASCII", OUTPUT_FILENAME)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    result.height.should eq(100 * AsciiPaint::BlockCharacter.height)
  end

  context "data directory" do
    it "has character files of the correct width" do
      Helpers.each_block_character_path do |path|
        File.open(path, 'r') do |file|
          file.each_line do |line|
            line.chomp.size.should eq(AsciiPaint::BlockCharacter::UNPADDED_WIDTH), file.path
          end
        end
      end
    end

    it "has character files of the correct height" do
      Helpers.each_block_character_path do |path|
        File.open(path, 'r') do |file|
          file.each_line.count.should eq(AsciiPaint::BlockCharacter::UNPADDED_HEIGHT), file.path
        end
      end
    end

    it "has character files for all alphanumeric characters" do
      desired_characters = ('A'..'Z').to_a + ('0'..'9').to_a
      found_characters = []

      Helpers.each_block_character_path do |path|
        character = path.to_s.match(/\/(.)\.txt/)[1]
        found_characters << character
      end

      found_characters.should =~ desired_characters
    end
  end
end
