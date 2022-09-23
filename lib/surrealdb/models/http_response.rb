# Copyright © SurrealDB Ltd
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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
