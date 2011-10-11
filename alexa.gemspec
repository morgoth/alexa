# -*- encoding: utf-8 -*-
require File.expand_path('../lib/alexa/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Wojciech Wnętrzak"]
  gem.email         = ["w.wnetrzak@gmail.com"]
  gem.description   = %q{Alexa Web Information Service library (AWIS)}
  gem.summary       = %q{Alexa Web Information Service library}
  gem.homepage      = "https://github.com/morgoth/alexa"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "alexa"
  gem.require_paths = ['lib']
  gem.version       = Alexa::VERSION

  gem.add_dependency "multi_xml"

  gem.add_development_dependency "mocha"
  gem.add_development_dependency "fakeweb"
end
