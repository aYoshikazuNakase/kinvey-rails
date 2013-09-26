module Kinvey

  class DataStore
    attr_reader :collection

    def initialize(kinvey)
      @kinvey = kinvey

      classname = self.class.name
      classname[0] = classname[0].downcase
      @collection = classname
    end

    def create(data = {})
      resp = @kinvey.conn.post do |req|
        req.url "/appdata/#{@kinvey.appKey}/#{@collection}"
        req.body = data
      end

      if resp.status == 201 then
        resp.body["_id"]
      else
        nil
      end
    end

    def retrieve
      resp = @kinvey.conn.get do |req|
        req.url "/appdata/#{@kinvey.appKey}/#{@collection}"
      end

      if resp.status == 200 then
        resp.body
      else
        nil
      end
    end
  end
end
