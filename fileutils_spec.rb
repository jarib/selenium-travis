require 'rspec/autorun'

describe "foo" do
  before do           
    Dir.stub!(:mktmpdir => "/tmp/some/path")
    FileUtils.stub!(:rm_rf)
  end
  
  it "bar" do
    FileUtils.rm_rf Dir.mktmpdir
  end
end