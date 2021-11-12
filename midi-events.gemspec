Gem::Specification.new do |s|
  s.name        = 'midi-events'
  s.version     = '0.5.0'
  s.date        = '2021-11-12'
  s.summary     = 'A Ruby simple library for creating MIDI Event Messages'
  s.description = 'MIDI Events is a library for creating MIDI Event Messages that can be sent to MIDI Instruments through other libraries such as midi-communications or unimidi'
  s.authors     = ['Javier Sánchez Yeste']
  s.email       = 'javier.sy@gmail.com'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|samples)/}) }
  s.homepage    = 'https://github.com/javier-sy/midi-events'
  s.license     = 'LGPL-3.0'

  s.required_ruby_version = '~> 2.7'

  # TODO
  #s.metadata    = {
    # "source_code_uri" => "https://",
    # "homepage_uri" => "",
    # "documentation_uri" => "",
    # "changelog_uri" => ""
  #}
end
