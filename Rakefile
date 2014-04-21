#!/usr/bin/env rake

begin
  require "kitchen/rake_tasks"
  Kitchen::RakeTasks.new
rescue LoadError
  puts "Unable to require `kitchen/rake_tasks`"
end

task default: "test"

desc "Runs all tests"
task test: [:knife, :rubocop, :foodcritic, :chefspec, :kitchen]

desc "Runs foodcritic linter"
task foodcritic: :prepare_sandbox do
  sh "bundle exec foodcritic #{sandbox_path} -f any --tags ~FC015"
end

desc "Runs knife cookbook test"
task knife: :prepare_sandbox do
  sh "bundle exec knife cookbook test cookbook -c test/.chef/knife.rb -o #{sandbox_path}/../"
end

desc "Runs specs with chefspec"
task chefspec: :prepare_sandbox do
  if Bundler.rubygems.find_name("chef").first.version < Gem::Version.new(11)
    puts "Skipping `chefspec` due to older Chef version"
  else
    sh "bundle exec rspec --color"
  end
end

desc "Runs integration tests with test kitchen"
task :kitchen do
  if ENV["CI"]
    puts "Skipping Kitchen tests for now due to CI environment..."
    exit
  end
  args = ENV["CI"] ? "test --destroy=always" : "verify"
  sh "bundle exec kitchen #{args}"
end

desc "Runs RuboCop style checks"
task rubocop: :prepare_sandbox do
  sh "bundle exec rubocop #{sandbox_path}"
end

task :prepare_sandbox do
  files = %w[
    *.md *.rb attributes definitions libraries files providers recipes
    resources templates
  ]

  rm_rf sandbox_path
  mkdir_p sandbox_path
  cp_r Dir.glob("{#{files.join(",")}}"), sandbox_path
end

private

def sandbox_path
  File.join(File.dirname(__FILE__), %w[tmp cookbooks cookbook])
end
