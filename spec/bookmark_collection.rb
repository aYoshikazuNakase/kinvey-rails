require "kinvey-rails"

class BookmarkCollection < Kinvey::DataStore
  attr_accessor :url

  def make_entity
    entity = {
      :url => @url
    }
  end
end
