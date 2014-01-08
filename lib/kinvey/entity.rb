module Kinvey

  class Entity
    attr_reader :id

    def to_hash
    end

    class FileReference
      attr_reader :id
      attr_reader :filename
      attr_reader :url
      attr_reader :size
      attr_reader :expiresAt

      def initilaize
      end

      def set(params = {})
        @id = params["_id"]
        @filename = params["_filename"]
        @url = params["_downloadURL"]
        @size = params["size"]
        @expiresAt = params["_expiresAt"]
      end
    end
  end
end
