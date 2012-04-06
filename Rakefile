require 'fileutils'
require 'rake/clean'
require 'rspec/core/rake_task'

$project_root = File.dirname(__FILE__)

ARTIFACTS = {
    "build/rb" => "selenium-webdriver",
    "rb/spec" => nil,
    "build/java/server/test/org/openqa/selenium/server-with-tests-standalone.jar" => nil,
    "common/src/web" => nil
}

CLEAN << "selenium-webdriver"
CLEAN << "build"
CLEAN << "rb"
CLEAN << "common"

task :selenium do
  $selenium_root = ENV['SELENIUM_ROOT'] or raise "must set SELENIUM_ROOT"
end

desc 'Import code and artifacts from the Selenium repo.'
task :import => [:selenium] do
  ARTIFACTS.each do |from, to|
    absolute_to = File.join($project_root, to ? to : from)
    absolute_from = File.join($selenium_root, from)
  
    FileUtils.rm_rf absolute_to, :noop => false, :verbose => true
    FileUtils.mkdir_p File.dirname(absolute_to)
    FileUtils.cp_r(absolute_from, absolute_to, :noop => false, :verbose => true)
  end
end

RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = "rb/spec/unit/**/*_spec.rb"
end

[:firefox, :ie, :remote, :chrome].each do |driver|
  RSpec::Core::RakeTask.new(driver) do |t|
    t.ruby_opts = "-Irb/spec/integration"
    t.pattern = "rb/spec/integration/selenium/webdriver{,#{driver}/**}/*_spec.rb"
  end
end

task :default => (ENV['WD_SPEC_DRIVER'] ||= 'unit')

