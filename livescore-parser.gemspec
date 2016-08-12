Gem::Specification.new do |s|
  s.name        = 'livescore-parser'
  s.version     = '0.2.7'
  s.executables << 'livescore-parser'
  s.date        = '2013-09-24'
  s.summary     = 'TV Channel parser'
  s.description = 'Downloads TV channel schedule in XML format'
  s.authors     = ['Maciej Walusiak']
  s.email       = 'rabsztok@gmail.com'
  s.files       = ['bin/livescore-parser', 'lib/livescore-parser.rb', 'lib/livescore-parser/parser.rb', 'lib/livescore-parser/writer.rb', 'lib/livescore-parser/hash_helper.rb', 'pages.yml']
  s.homepage    = 'https://github.com/Rabsztok/livescore-parser'
  s.license     = 'GPL'
  s.add_dependency 'builder', '~> 3.2'
  s.add_dependency 'mechanize', '~> 2.7'
  s.add_dependency 'nokogiri', '~> 1.6'
end
