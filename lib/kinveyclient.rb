module Kinvey

  class KinveyClient
    def initialize(app_key, app_secret)
      @appKey = app_key
      @appSecret = app_secret
      @appAuth = "Basic " + Base64.strict_encode64("#{@appKey}:#{@appSecret}")

      @conn = Faraday.new(:url => KINVEY_HOST) do |builder|
        builder.request  :url_encoded
        builder.response :logger
        builder.adapter  :net_http
        builder.response :json, :content_type => /\bjson/
      end
      @conn.headers['Authorization'] = @appAuth
      @conn.headers['X-Kinvey-API-Version'] = '2'
    end

    def handshake
      res = @conn.get do |req|
        req.url "/appdata/#{@appKey}"
      end
    end
  end
end
