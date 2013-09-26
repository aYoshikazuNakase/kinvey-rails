module Kinvey

  class Error
    attr_reader :status
    attr_reader :error
    attr_reader :description

    def initialize(status, opt = {})
      @status = status
      @error = opt["error"]
      @description = opt["description"]
    end

    def to_s
      <<"EOS"
[[Kinvey::Error]]
  status:      #{@status}
  error:       #{@error}
  description: #{@description}
EOS
    end

    def self.from_response(resp)
      Kinvey::Error.new(resp.status, resp.body)
    end
  end
end
