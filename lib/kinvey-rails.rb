require "faraday"
require "faraday_middleware"
require "uuidtools"
require "base64"

require "kinvey/error"
require "kinvey/client"
require "kinvey/user"
require "kinvey/entity"
require "kinvey/datastore"

module Kinvey
  KINVEY_HOST = 'https://baas.kinvey.com/'

  class << self
    @kinvey = nil

    def init(app_key, app_secret)
      @kinvey ||= KinveyClient.new(app_key, app_secret)
    end
  end

end
