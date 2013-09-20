require "kinvey-rails"
require "bookmark_collection"
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "KinveyRails" do
  before(:all) do
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
    @kinvey.login("a", "111111").should be_true
    @kinvey.active_user.should_not be_nil
    @kinvey.active_user.username.should == "a"
  end

  it "datastore" do
    resp = @kinvey.datastore_retrieve(:collection => "bookmarkCollection")
    resp.status.should == 200
  end

  it "datastore retrieve" do
    col = @kinvey.datastore(BookmarkCollection)
    books = col.retrieve
    p books
  end

  it "datastore add" do
    col = @kinvey.datastore(BookmarkCollection)
    @id = col.create({:url => "http://www.access-company.com/"})
  end

  it "datastore del" do
    #id
  end

  it "logout" do
    @kinvey.logout.should be_true
    @kinvey.active_user.should be_nil
  end
end
