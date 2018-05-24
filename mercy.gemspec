# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mercy/version'

Gem::Specification.new do |gem|
  gem.name          = 'mercy'
  gem.version       = Mercy::VERSION
  gem.authors       = ["Bidu Dev's Team"]
  gem.email         = ["dev@bidu.com.br"]
  gem.homepage      = 'https://github.com/Bidu/mercy'
  gem.description   = 'Gem for easy health check'
  gem.summary       = gem.description

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f)  }
  gem.test_files    = gem.files.grep(%r{^(test|gem|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'activesupport', '~> 5.x'
  gem.add_runtime_dependency 'sinclair', '~> 1.0.0'
  gem.add_runtime_dependency 'darthjee-active_ext', '>= 1.3.1'
  gem.add_runtime_dependency 'json_parser', '>= 1.2'

  gem.add_development_dependency 'activerecord', '~> 5.x'
  gem.add_development_dependency "sqlite3"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency 'pry-nav'
  gem.add_development_dependency 'simplecov'
end
