# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mercy/version'

Gem::Specification.new do |gem|
  gem.name                  = 'mercy'
  gem.version               = Mercy::VERSION
  gem.authors               = ["Darthjee"]
  gem.email                 = ["darthjee@gmail.com"]
  gem.summary               = 'Gem for easy health check'
  gem.description           = 'Gem for easy health check'
  gem.homepage              = 'https://github.com/darthjee/mercy'
  gem.required_ruby_version = '>= 2.5.0'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f)  }
  gem.test_files    = gem.files.grep(%r{^(test|gem|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'activesupport',       '~> 5.x'
  gem.add_runtime_dependency 'darthjee-active_ext', '>= 1.3.1'
  gem.add_runtime_dependency 'arstotzka',           '>= 1.3.2'
  gem.add_runtime_dependency 'darthjee-core_ext',   '>= 1.7.4'

  gem.add_development_dependency 'activerecord', '~> 5.x'
  gem.add_development_dependency "sqlite3"

  gem.add_development_dependency 'bundler',       '~> 1.16.1'
  gem.add_development_dependency 'pry-nav',       '~> 0.2.4'
  gem.add_development_dependency 'rake',          '>= 12.3.1'
  gem.add_development_dependency 'rspec',         '>= 3.8'
  gem.add_development_dependency 'rubocop',       '0.58.1'
  gem.add_development_dependency 'rubocop-rspec', '1.30.0'
  gem.add_development_dependency 'rubycritic',    '>= 4.0.2'
  gem.add_development_dependency 'simplecov',     '~> 0.16.x'
  gem.add_development_dependency 'yard',          '>= 0.9.18'
  gem.add_development_dependency 'yardstick',     '>= 0.9.9'
end
