$:.push(File.expand_path('../lib', __FILE__))

require('appenv/version')

Gem::Specification.new { |gem|
  gem.name = 'appenv'
  gem.version = AppEnv::VERSION
  gem.authors = ['Joseph Pearson']
  gem.email = 'joseph@users.noreply.github.com'
  gem.homepage = "https://github.com/joseph/#{gem.name}"
  gem.summary = 'Application environment configuration'
  gem.description = 'Environment-variable compatible application configuration.'
  gem.license = 'MIT'

  gem.metadata = {
    'github_repo' => "ssh://github.com/bksh/#{gem.name}"
  }

  gem.files = [
    'lib/appenv.rb',
    'lib/appenv/version.rb',
    'lib/appenv/environment.rb'
  ]

  gem.add_dependency('activesupport')
}
