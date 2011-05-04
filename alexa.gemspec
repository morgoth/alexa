# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "alexa/version"

Gem::Specification.new do |s|
  s.name        = "alexa"
  s.version     = Alexa::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Wojciech Wnętrzak"]
  s.email       = ["w.wnetrzak@gmail.com"]
  s.homepage    = "https://github.com/morgoth/alexa"
  s.summary     = %q{Alexa Web Information Service library}
  s.description = %q{Alexa Web Information Service library (AWIS)}

  s.rubyforge_project = "alexa"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "xml-simple"

  s.add_development_dependency "test-unit"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "mocha"
end
