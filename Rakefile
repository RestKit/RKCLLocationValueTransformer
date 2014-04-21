require 'rubygems'
require 'bundler'
Bundler.setup
require 'xctasks/test_task'

XCTasks::TestTask.new(:test) do |t|
  t.workspace = 'RKCLLocationValueTransformer.xcworkspace'
  t.schemes_dir = 'Tests/Schemes'
  t.runner = :xcpretty
  t.actions = %w{clean test}
  
  t.subtask(ios: 'iOS Tests') do |s|
    s.sdk = :iphonesimulator
  end
  
  t.subtask(osx: 'OS X Tests') do |s|
    s.sdk = :macosx
  end
end

task :default => 'spec'
