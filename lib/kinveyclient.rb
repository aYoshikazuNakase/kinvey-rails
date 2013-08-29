module Kinvey

  class KinveyClient
    @active_user = nil

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

    def active_user
      @active_user
    end

    def login(username, password)
      body = {
        "username" => username,
        "password" => password
      }

      addHeaderAuth
      res = @conn.post do |req|
        req.url "/user/#{@appKey}/login"
        req.body = body
      end

      if res.status == 200 then
        @active_user = Kinvey::User.new(res.body)
      else
        @active_user = nil
      end
    end

    private
    def addHeaderAuth
      if @active_user.nil? then
        @conn.headers['Authorization'] = @appAuth
      else
        # @conn.headers['Authorization'] = @appAuth
      end
    end

  end
end
