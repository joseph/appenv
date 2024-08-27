require('bundler/gem_tasks')

require('rake/testtask')
Rake::TestTask.new { |t|
  t.libs << 'test'
  t.test_files = FileList['test/unit/**/test*.rb']
}

desc('Run tests')
task(:default => :test)
