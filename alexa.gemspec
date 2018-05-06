# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "alexa/version"

Gem::Specification.new do |gem|
  gem.name          = "alexa"
  gem.version       = Alexa::VERSION
  gem.authors       = ["Wojciech Wnętrzak"]
  gem.email         = ["w.wnetrzak@gmail.com"]

  gem.summary       = %q{Alexa Web Information Service library}
  gem.description   = %q{Alexa Web Information Service library (AWIS)}
  gem.homepage      = "https://github.com/morgoth/alexa"
  gem.license       = "MIT"

  gem.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 1.9.3"

  gem.add_dependency "aws-sigv4"
  gem.add_dependency "multi_xml", ">= 0.5.0"

  gem.add_development_dependency "minitest", ">= 5.0.0"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "vcr"
end
