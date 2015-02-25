require 'fileutils'
require 'rake/clean'
require 'rspec/core/rake_task'

$project_root = File.dirname(__FILE__)

ARTIFACTS = {
    "build/rb"                                                                    => "selenium-webdriver",
    "rb/spec"                                                                     => nil,
    "build/java/server/test/org/openqa/selenium/server-with-tests-standalone.jar" => nil,
    "common/src/web"                                                              => nil,
    'build/javascript/safari-driver/prebuilt/SafariDriver.safariextz'             => nil
}

CLEAN << "selenium-webdriver"
CLEAN << "build"
CLEAN << "rb"
CLEAN << "common"

task :selenium do
  $selenium_root = ENV['SELENIUM_ROOT'] or raise "must set SELENIUM_ROOT"
end

task :copy_artifacts do
  ARTIFACTS.each do |from, to|
    absolute_to = File.join($project_root, to ? to : from)
    absolute_from = File.join($selenium_root, from)
  
    FileUtils.rm_rf absolute_to, :verbose => true
    FileUtils.mkdir_p File.dirname(absolute_to)
    FileUtils.cp_r(absolute_from, absolute_to, :verbose => true)
  end
end

task :clean_svn_dirs do
  Dir['**/.svn'].each { |e| rm_rf e, :verbose => true }
end

desc 'Import code and artifacts from the Selenium repo.'
task :import => [:selenium, :copy_artifacts, :clean_svn_dirs]

RSPEC_OPTS = "-f doc --colour"

RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = "rb/spec/unit/**/*_spec.rb"
  t.rspec_opts = RSPEC_OPTS
end

[:firefox, :ie, :remote, :chrome].each do |driver|
  RSpec::Core::RakeTask.new(driver) do |t|
    t.ruby_opts = "-Irb/spec/integration"
    t.pattern = "rb/spec/integration/selenium/webdriver{,#{driver}/**}/*_spec.rb"
    t.rspec_opts = RSPEC_OPTS
  end
end

RSpec::Core::RakeTask.new(:rc_client) do |t|
  t.ruby_opts = "-Irb/spec/integration"
  t.pattern = "rb/spec/integration/selenium/client/{api,reporting,smoke}/*_spec.rb"
  t.rspec_opts = RSPEC_OPTS
end


task :default => (ENV['WD_SPEC_DRIVER'] ||= 'unit')

