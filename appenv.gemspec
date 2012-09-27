# -*- encoding: utf-8 -*-
require File.expand_path('../lib/appenv/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ['Joseph Pearson']
  gem.email = ['joseph@booki.sh']
  gem.description = 'Environment-variable compatible application configuration.'
  gem.summary = 'Application environment configuration'
  gem.homepage = ''

  gem.files = `git ls-files`.split($\)
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.name = 'appenv'
  gem.require_paths = ['lib']
  gem.version = AppEnv::VERSION
  gem.add_dependency('activesupport')
end
