# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qiita-export/version'

Gem::Specification.new do |spec|
  spec.name          = "qiita-export"
  spec.version       = QiitaExport::VERSION
  spec.authors       = ["Shin Akiyama"]
  spec.email         = ["akishin999@gmail.com"]
  spec.summary       = %q{export tool for Qiita}
  spec.description   = %q{export tool for Qiita}
  spec.homepage      = "https://github.com/akishin/qiita-export"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.bindir        = 'bin'

  spec.add_dependency "sqlite3"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "3.4.0"
end
