require File.expand_path('../lib/ascii_paint/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'ascii_paint'
  s.version = AsciiPaint::VERSION
  s.date = '2013-12-14'

  s.summary = 'Paint in ASCII!'
  s.description = 'Convert ASCII art to PNGs in pure Ruby.'
  s.homepage = 'https://github.com/nate00/ascii_paint'
  s.license = 'MIT'

  s.authors = ['Nate Sullivan']
  s.email = 'nathanielsullivan00+ascii_paint@gmail.com'

  s.files = Dir['lib/**/*', 'data/**/*']

  s.add_dependency 'chunky_png', '~>1.2.9'

  s.add_development_dependency 'rspec', '~>2.14.1'
  s.add_development_dependency 'pry'
  s.test_files = Dir['spec/**/*']
end
