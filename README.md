# ASCII paint

Convert ASCII art to PNG.

### Usage

    text = "
     !!!!! @@@@@ $$$$$ %%%%% ^^^^^       @@@@@ $$$$$ %%%%% ^   ^ !!!!! 
     !   ! @     $       %     ^         @   @ $   $   %   ^^  ^   !   
     !!!!! @@@@@ $       %     ^         @@@@@ $$$$$   %   ^ ^ ^   !   
     !   !     @ $       %     ^         @     $   $   %   ^  ^^   !   
     !   ! @@@@@ $$$$$ %%%%% ^^^^^ !!!!! @     $   $ %%%%% ^   ^   !   
    "
    AsciiPaint.paint(text, 'out.png')

### Configuration

Use `AsciiPaint.config` to define your personal painting style.

    AsciiPaint.config do |config|
      config.character_width = 10
      config.character_height = 10
      config.color_map = { '!' => :blue, '@' => :red, '$' => :yellow }
    end

You can also customize individual paintings by passing options to `AsciiPaint.paint`

    AsciiPaint.paint(text, 'out.png', character_width: 10, character_height: 10)

### Demonstration

![ASCII paint logo](https://raw.github.com/nate00/ascii_paint/master/logo.gif)

### License

MIT
