require File.expand_path('../lib/appenv/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = 'appenv'
  gem.version = AppEnv::VERSION
  gem.authors = ['Joseph Pearson']
  gem.email = 'joseph@users.noreply.github.com'
  gem.description = 'Environment-variable compatible application configuration.'
  gem.summary = 'Application environment configuration'
  gem.homepage = 'https://github.com/joseph/appenv'
  gem.license = 'MIT'

  gem.files = [
    'lib/appenv.rb',
    'lib/appenv/version.rb',
    'lib/appenv/environment.rb'
  ]
  gem.add_dependency('activesupport')
end
