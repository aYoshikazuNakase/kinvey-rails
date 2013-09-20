module Kinvey

  class User
    attr_reader :id
    attr_reader :username
    attr_reader :authtoken

    def initialize(opt)
      @id        = opt["_id"]
      @username  = opt["username"]
      @authtoken = opt["_kmd"]["authtoken"]
    end
  end
end
