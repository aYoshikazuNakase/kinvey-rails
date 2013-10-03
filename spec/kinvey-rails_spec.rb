require "kinvey-rails"
require "bookmark_collection"
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "KinveyRails" do
  before(:all) do
    @kinvey = Kinvey.init(APP_KEY, APP_SECRET)
  end

  it "init Kinvey" do
    @kinvey.should_not be_nil
    @kinvey.active_user.should be_nil
  end

  it "handshake" do
    @kinvey.handshake.status.should == 200
  end

  it "login failed" do
    ret = @kinvey.login("a", "----")
    ret.class.should == Kinvey::Error
    @kinvey.active_user.should be_nil
  end

  it "login success" do
    ret = @kinvey.login("a", "111111")
    ret.class.should == Kinvey::User
    @kinvey.active_user.should_not be_nil
    @kinvey.active_user.username.should == "a"
  end

  it "datastore create" do
    bookstore = @kinvey.datastore(BookmarkCollection)
    bookstore.should_not be_nil
    id = bookstore.create({"url" => "http://www.access.co.jp"})
    id.should_not be_nil
  end

  it "datastore retrieve" do
    bookstore = @kinvey.datastore(BookmarkCollection)
    books = bookstore.retrieve
  end

  it "datastore del" do
    #id
  end

  it "logout" do
    @kinvey.logout.should be_nil
    @kinvey.active_user.should be_nil
  end
end
