require 'spec_helper'
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
    expect(File).to be_a_file OUTPUT_FILENAME
  end

  it "obeys local configuration" do
    AsciiPaint.block_paint("ASCII", OUTPUT_FILENAME, character_height: 100)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    expect(result.height).to eq(100 * AsciiPaint::BlockCharacter.height)
  end

  it "obeys global configuration" do
    AsciiPaint.config do |config|
      config.character_height = 100
    end

    AsciiPaint.block_paint("ASCII", OUTPUT_FILENAME)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)
    expect(result.height).to eq(100 * AsciiPaint::BlockCharacter.height)
  end

  it "deletes temporary files" do
    AsciiPaint.block_paint("ASCII\npaint", OUTPUT_FILENAME) do |f|
      expect(File).to be_a_file OUTPUT_FILENAME
    end

    expect(File).not_to be_a_file OUTPUT_FILENAME
  end

  it "renders adjacent newlines" do
    ascii = "ASCII\n\npaint"
    AsciiPaint.block_paint(ascii, OUTPUT_FILENAME, character_height: 10)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)

    rows = 3
    row_height = 10 * AsciiPaint::BlockCharacter.height
    expect(result.height).to eq(rows * row_height)
  end

  it "renders leading and trailing newlines" do
    ascii = "\nASCII\npaint\n"
    AsciiPaint.block_paint(ascii, OUTPUT_FILENAME, character_height: 10)
    result = ChunkyPNG::Image.from_file(OUTPUT_FILENAME)

    rows = 4
    row_height = 10 * AsciiPaint::BlockCharacter.height
    expect(result.height).to eq(rows * row_height)
  end

  context "data directory" do
    it "has character files of the correct width" do
      Helpers.each_block_character_path do |path|
        File.open(path, 'r') do |file|
          file.each_line do |line|
            expect(line.chomp.size).to eq(AsciiPaint::BlockCharacter::UNPADDED_WIDTH), file.path
          end
        end
      end
    end

    it "has character files of the correct height" do
      Helpers.each_block_character_path do |path|
        File.open(path, 'r') do |file|
          expect(file.each_line.count).to eq(AsciiPaint::BlockCharacter::UNPADDED_HEIGHT), file.path
        end
      end
    end

    it "has character files for all printing ASCII characters" do
      printing_character_codes = (32..126).map { |code| code.to_s }
      character_codes_present =
        Helpers.each_block_character_path.map do |path|
          path.to_s.match(/\/(\d+)\.txt/)[1]
        end

      missing_character_codes = printing_character_codes - character_codes_present

      expect(missing_character_codes).to be_empty, missing_character_codes.to_s
    end
  end
end
