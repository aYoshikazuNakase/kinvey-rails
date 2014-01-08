require "kinvey-rails"

class ImageEntity < Kinvey::Entity
  attr_accessor :image

  def initialize(params = {})
    @id = params["_id"] unless params["_id"].nil?

    @image = FileReference.new()
    @image.set(params["image"]) unless params["image"].nil?
  end

  def to_hash
    hash = {
      :image => @image
    }
  end

  def to_s
    puts "[BookmarkCollection] id=#{@id}, image=#{@image}"
  end
end
