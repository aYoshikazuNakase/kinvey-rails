require "faraday"
require "faraday_middleware"
require "uuidtools"
require "base64"
require "kinveyclient"

module Kinvey
  KINVEY_HOST = 'https://baas.kinvey.com/'

  class << self
    @kinvey = nil

    def init(app_key, app_secret)
      @kinvey ||= KinveyClient.new(app_key, app_secret)
    end
  end

end
