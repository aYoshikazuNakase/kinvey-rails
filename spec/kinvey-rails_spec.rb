require "kinvey-rails"
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "KinveyRails" do
  before do
    @kinvey = Kinvey.init('kid_VTkkODHk1M', '79b2f9757285425f88aa155f87b44dd5')
  end

  it "init Kinvey" do
    @kinvey.should_not be_nil
    @kinvey.active_user.should be_nil
  end

  it "handshake" do
    @kinvey.handshake.status.should == 200
  end

  it "login" do
    @kinvey.login("a", "111111")
    @kinvey.active_user.should_not be_nil
    @kinvey.active_user.username.should == "a"
  end
end
