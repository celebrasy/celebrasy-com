# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

if %w(development test).include?(Rails.env)
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:rspec)

  task({ test: %w(rspec cucumber) })
end

Rails.application.load_tasks
