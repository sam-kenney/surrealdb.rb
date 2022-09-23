# Generic error class for SurrealDB.
module SurrealDB
  class SurrealError < StandardError
    attr_reader :status, :json

    # @param [Integer] status The HTTP status code.
    # @param [Hash] json The JSON response.
    # @return [SurrealDB::SurrealError] The SurrealError instance.
    def initialize(status, json = nil)
      @status = status
      @json = json
      super("SurrealDB Error: #{status} #{json}")
    end
  end
end
