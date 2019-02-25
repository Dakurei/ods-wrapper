lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ODS/version"

Gem::Specification.new do |spec|
  spec.name          = "ODS-Wrapper"
  spec.version       = ODS::VERSION
  spec.authors       = ["Maxime Palanchini"]
  spec.email         = ["m.palanchini@laposte.net"]

  spec.summary       = "Ruby wrapper for opendatasoft service"
  spec.homepage      = "https://github.com/Dakurei/ODS-Wrapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"

  spec.add_dependency "httparty"
end
