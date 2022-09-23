# Generic HTTP response class for SurrealDB.
module SurrealDB
  class HTTPResponse
    attr_reader :time, :status, :result

    # @param [String] time The time taken to execute the request.
    # @param [Integer] status The HTTP status code.
    # @param [Hash] result The JSON response.
    # @return [SurrealDB::HTTPResponse] The HTTPResponse instance.
    def initialize(time, status, result)
      @time = time
      @status = status
      @result = result
    end

    # Create a HTTPResponse from a Hash.
    #
    # @param [Hash] data The Hash to convert.
    # @return [SurrealDB::HTTPResponse] The HTTPResponse instance.
    def self.from_hash(data)
      HTTPResponse.new data["time"], data["status"], data["result"]
    end

    # String representation of the HTTPResponse.
    def to_s
      "HTTPResponse(time => '#{@time}' status => '#{@status}' result => #{@result})"
    end
  end
end
