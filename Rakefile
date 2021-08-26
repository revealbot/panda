# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rspec/core/rake_task'

task default: %i[spec rubocop]

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['--color', '--format doc']
end

RuboCop::RakeTask.new
