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

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "httparty", "~> 0.13.7"
end
