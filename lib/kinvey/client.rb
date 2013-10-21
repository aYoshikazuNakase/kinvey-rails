module Kinvey

  class KinveyClient
    attr_reader :conn
    attr_reader :appKey

    @m_actuser = nil

    def initialize(app_key, app_secret)
      @appKey = app_key
      @appSecret = app_secret

      @conn = Faraday.new(:url => KINVEY_HOST) do |builder|
        builder.request  :url_encoded
        builder.response :logger
        builder.adapter  :net_http
        builder.response :json, :content_type => /\bjson/
      end
      @conn.headers['X-Kinvey-API-Version'] = '2'
      self.active_user = nil
    end

    def handshake
      res = @conn.get do |req|
        req.url "/appdata/#{@appKey}"
      end
    end

    def active_user
      @m_actuser
    end

    def login(username, password)
      body = {
        "username" => username,
        "password" => password
      }

      resp = @conn.post do |req|
        req.url "/user/#{@appKey}/login"
        req.body = body
      end

      if resp.status == 200 then
        self.active_user = Kinvey::User.new(resp.body)
      else
        self.active_user = nil
        Kinvey::Error.from_response(resp)
      end
    end

    def logout
      if not @m_actuser.nil? then
        resp = @conn.post do |req|
          req.url "/user/#{@appKey}/_logout"
        end

        if resp.status == 204 then
          self.active_user = nil
        else
          Kinvey::Error.from_response(resp)
        end
      end
    end

    def datastore(collection_name)
      Kinvey::DataStore.new(self, collection_name)
    end

    ######
    private

    def active_user=(user)
      if user.nil? then
        @m_actuser = nil
        @conn.headers['Authorization'] = "Basic " + Base64.strict_encode64("#{@appKey}:#{@appSecret}")
      else
        @m_actuser = user
        @conn.headers['Authorization'] = "Kinvey #{@m_actuser.authtoken}"
      end
    end
  end
end
