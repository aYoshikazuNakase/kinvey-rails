require "kinvey-rails"

class BookmarkEntity < Kinvey::Entity
  attr_accessor :url

  def initialize(params = {})
    @id = params["_id"] unless params["_id"].nil?
    @url = params["url"] unless params["url"].nil?
  end

  def to_hash
    hash = {
      :url => @url
    }
  end

  def to_s
    puts "[BookmarkCollection] id=#{@id}, url=#{@url}"
  end
end
