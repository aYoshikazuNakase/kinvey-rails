module Kinvey

  class DataStore
    attr_reader :collection_name

    def initialize(client, name)
      @client = client
      @collection_name = name
    end

    def create(entity)
      resp = @client.conn.post do |req|
        req.url "/appdata/#{@client.appKey}/#{@collection_name}"
        req.body = entity.to_hash
      end

      if resp.status == 201 then
        @id = resp.body["_id"]
      else
        nil
      end
    end

    def retrieve(clazz = nil, opt = {})
      id = opt[:id] unless opt[:id].nil?

      resp = @client.conn.get do |req|
        if id.nil? then
          req.url "/appdata/#{@client.appKey}/#{@collection_name}"
        else
          req.url "/appdata/#{@client.appKey}/#{@collection_name}/#{id}"
        end
      end

      if resp.status == 200 then
        if clazz.nil? then
          resp.body
        else
          retrieve_parse_body(clazz, resp.body)
        end
      else
        nil
      end
    end

    def count
      resp = @client.conn.get do |req|
        req.url "/appdata/#{@client.appKey}/#{@collection_name}/_count"
      end

      if resp.status == 200 then
        resp.body["count"]
      else
        nil
      end
    end

    def delete(entity)
      if not entity.nil? then
        id = entity.id
        resp = @client.conn.delete do |req|
          req.url "/appdata/#{@client.appKey}/#{@collection_name}/#{id}"
        end

        if not resp.status == 200 then
          Kinvey::Error.from_response(resp)
        end
      end
    end

    def retrieve_parse_body(clazz, body)
      entities = {}
      if body.instance_of?(Array) then
        body.each do |b|
          entities[b["_id"]] = clazz.new(b)
        end
      else
        entities[body["_id"]] = clazz.new(body)
      end

      entities
    end
  end
end
