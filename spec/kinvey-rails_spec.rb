require "kinvey-rails"
require "bookmark_entity"
require "image_entity"
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

APP_KEY = "kid_VTdIfP_01f"
APP_SECRET = "68224fc0be294726be11ab0f673c51be"

##########
describe "Kinvey Handshake" do
  before(:all) do
    @kinvey = Kinvey.init(APP_KEY, APP_SECRET)
  end

  it "handshake" do
    @kinvey.handshake.status.should == 200
  end
end

##########
describe "Kinvey Login" do
  before(:all) do
    @kinvey = Kinvey.init(APP_KEY, APP_SECRET)
  end

  it "login failed" do
    ret = @kinvey.login("test", "----")
    ret.class.should == Kinvey::Error
    @kinvey.active_user.should be_nil
  end

  it "login success" do
    ret = @kinvey.login("test", "111111")
    ret.class.should == Kinvey::User
    @kinvey.active_user.should_not be_nil
    @kinvey.active_user.username.should == "test"
  end

  it "logout" do
    @kinvey.logout.should be_nil
    @kinvey.active_user.should be_nil
  end
end

##########
describe "Kinvey Datastore" do
  before(:all) do
    @kinvey = Kinvey.init(APP_KEY, APP_SECRET)
    @kinvey.login("test", "111111")
  end

  before(:each) do
    @bookstore = @kinvey.datastore(:bookmarkCollection)
  end

  after(:all) do
    @kinvey.logout
  end

  it "init Kinvey" do
    @kinvey.should_not be_nil
    @kinvey.active_user.should_not be_nil
  end

  it "datastore count 1" do
    count = @bookstore.count
    count.should >= 0
    p "@@@@@ count=#{count}"
  end

  it "datastore create" do
    entity = BookmarkEntity.new
    entity.url = "http://www.google.co.jp/"

    @bookstore.should_not be_nil
    id = @bookstore.create(entity)
    id.should_not be_nil
  end

  it "datastore retrieve all" do
    books = @bookstore.retrieve(BookmarkEntity)
    count = @bookstore.count
    books.length.should == count
  end

  it "datastore retrieve one" do
    book = @bookstore.retrieve(BookmarkEntity, {:id => "524d6127a2f27e2e5f00766d"})
    p book
  end

  it "datastore delete one" do
    books = @bookstore.retrieve(BookmarkEntity)
    before_count = @bookstore.count
    books.length.should == before_count

    key = books.keys[0]
    @bookstore.delete(books[key])
    after_count = @bookstore.count
    after_count.should == (before_count - 1)
  end

  it "datastore count 2" do
    count = @bookstore.count
    count.should >= 0
    p "@@@@@ count=#{count}"
  end
end


describe "Kinvey file reference Datastore" do
  before(:all) do
    @kinvey = Kinvey.init(APP_KEY, APP_SECRET)
    @kinvey.login("test", "111111")
  end

  before(:each) do
    @imageCollection= @kinvey.datastore(:ia2013ImageCollection)
  end

  after(:all) do
    @kinvey.logout
  end

  it "file reference datastore" do
    images = @imageCollection.retrieve(ImageEntity)
    @imageCollection.count.should == 6
  end
end
