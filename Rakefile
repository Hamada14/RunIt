require 'sinatra/activerecord/rake'
$LOAD_PATH << File.dirname(__FILE__)
require './app'

task :load_config do
end

namespace :testcode do
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  desc 'Execute Rspec'
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.rspec_opts = '--format p --require spec_helper'
  end

  desc 'Execute rubocop -DR'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.requires << 'rubocop-rspec'
    task.options = ['-DR', 'pattern', '**/*.rb']
  end
end

task :test do
  %w[rubocop spec].each { |task| Rake::Task["testcode:#{task}"].invoke }
end
