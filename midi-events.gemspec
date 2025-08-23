Gem::Specification.new do |s|
  s.name        = 'midi-events'
  s.version     = '0.6.0'
  s.date        = '2025-08-23'
  s.summary     = 'A Ruby simple library for creating MIDI Event Messages'
  s.description = 'MIDI Events is a library for creating MIDI Event Messages that can be sent to MIDI Instruments through other libraries such as midi-communications or unimidi'
  s.authors     = ['Javier Sánchez Yeste']
  s.email       = 'javier.sy@gmail.com'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|samples)/}) }
  s.homepage    = 'https://github.com/javier-sy/midi-events'
  s.license     = 'LGPL-3.0-or-later'

  s.required_ruby_version = '>= 2.7'

  # TODO
  #s.metadata    = {
    # "source_code_uri" => "https://",
    # "homepage_uri" => "",
    # "documentation_uri" => "",
    # "changelog_uri" => ""
  #}

  s.add_development_dependency 'minitest', '~>5', '>= 5.14.4'
  s.add_development_dependency 'rake', '~>13', '>= 13.0.6'
  s.add_development_dependency 'shoulda-context', '~>2', '>= 2.0.0'
end
