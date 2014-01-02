Gem::Specification.new do |s|
  s.name = 'ascii_paint'
  s.version = '0.0.0'
  s.date = '2013-12-14'

  s.summary = 'Paint in ASCII!'
  s.description = 'Convert ASCII art to PNGs in pure Ruby.'
  s.homepage = 'https://github.com/nate00/ascii_paint'
  s.license = 'MIT'

  s.authors = ['Nate Sullivan']
  s.email = 'nathanielsullivan00+ascii_paint@gmail.com'

  s.files = ['lib/ascii_paint.rb']

  s.add_dependency 'chunky_png', '~>1.2.9'
end
