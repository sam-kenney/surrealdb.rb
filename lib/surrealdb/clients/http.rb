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
require "httpx"
require "json"

require_relative "../models/http_response"
require_relative "../common/surreal_error"

module SurrealDB
  # HTTP client for SurrealDB.
  class HTTPClient
    attr_accessor :url, :namespace, :database, :username, :password

    # @param [String] url The URL of the SurrealDB server.
    # @param [String] namespace The namespace to use.
    # @param [String] database The database to use.
    # @param [String] username The username to authenticate with.
    # @param [String] password The password to authenticate with.
    # @return [HTTPClient] The HTTPClient instance.
    # @yield [HTTPClient] The HTTPClient instance.
    def initialize(url, namespace:, database:, username:, password:)
      if url.end_with? "/" then @url = url else @url = "#{url}/" end
      @namespace = namespace
      @database = database
      @username = username
      @password = password

      @headers = {
        "NS" => @namespace,
        "DB" => @database,
        "Content-Type" => "application/json",
        "Accept" => "application/json",
      }
      yield self if block_given?
    end

    # Make a request to the SurrealDB server.
    #
    # @param [String] method The HTTP method to use.
    # @param [String] uri The endpoint to request.
    # @param [Hash | Array<Hash> | nil] data The body of the request.
    # @return [SurrealDB::HTTPResponse] The response from the server.
    # @raise [SurrealDB::Exception] If the server returns an error.
    def _request(method, uri, data = nil)
      url = @url + uri
      response = HTTPX.plugin(:basic_authentication)
                      .basic_authentication(@username, @password)
                      .with(:headers => @headers)
                      .request(method, url, :body => data)

      raise SurrealDB::SurrealError.new(
        response.error.message,
      ) unless response.error.nil?

      raise SurrealDB::SurrealError.new(
        response.status,
        response.json,
      ) unless (200..300).include?(response.status) and response.json[0]["status"] == "OK"

      SurrealDB::HTTPResponse.from_hash(response.json[0]).result
    end

    # Execute a query.
    #
    # @param [String] query The query to execute.
    # @return [Array<Hash>] The result of the query.
    # @raise [SurrealDB::Exception] If the query is invalid.
    def execute(query)
      _request("POST", "sql", query)
    end

    # Insert multiple records into a table.
    #
    # @param [String] table The table to insert records into.
    # @param [Array<Hash>] data The data to insert. Each element
    #   must be a hash with an "id" key representing a unique identifier.
    # @raise [SurrealDB::Exception] If there is an issue with the request.
    def create_all(table, data)
      _request("POST", "key/#{table}", JSON.generate(data))
    end

    # Insert a record into a table.
    #
    # @param [String] table The table to insert a record into.
    # @param [String] id The ID of the record to insert.
    # @param [Hash] data The data to insert.
    # @return [Hash] The new record.
    # @raise [SurrealDB::Exception] If there is an issue with the request.
    def create_one(table, id, data)
      _request("POST", "key/#{table}/#{id}", JSON.generate(data))[0]
    end

    # Get all records from a table.
    #
    # @param [String] table The table to get records from.
    # @return [Array<Hash>] The records.
    # @raise [SurrealDB::Exception] If there is an issue with the request.
    def select_all(table)
      _request("GET", "key/#{table}")
    end

    # Get one record from a table.
    #
    # @param [String] table The table to get records from.
    # @param [String] id The ID of the record to get.
    # @return [Hash] The record.
    # @raise [SurrealDB::Exception] If there is an issue with the request.
    def select_one(table, id)
      _request("GET", "key/#{table}/#{id}")[0]
    end

    # Replace a record in a table.
    #
    # Requires all fields to be present, and will create
    # a new record if one with the given ID does not exist.
    #
    # @param [String] table The table to replace a record in.
    # @param [String] id The ID of the record to replace.
    # @param [Hash] data The data to replace.
    # @return [Hash] The replaced record.
    # @raise [SurrealDB::Exception] If there is an issue with the request.
    def replace_one(table, id, data)
      _request("PUT", "key/#{table}/#{id}", JSON.generate(data))[0]
    end

    # Upsert a record in a table.
    #
    # Requires only the fields that are being updated.
    # If a record with the given ID does not exist, it will be created.
    #
    # @param [String] table The table to upsert a record in.
    # @param [String] id The ID of the record to upsert.
    # @param [Hash] data The data to upsert.
    # @return [Hash] The upserted record.
    # @raise [SurrealDB::Exception] If there is an issue with the request.
    def upsert_one(table, id, data)
      _request("PATCH", "key/#{table}/#{id}", JSON.generate(data))[0]
    end

    # Delete all records from a table.
    #
    # @param [String] table The table to delete records from.
    # @raise [SurrealDB::Exception] If there is an issue with the request.
    def delete_all(table)
      _request("DELETE", "key/#{table}")
    end

    # Delete one record from a table.
    #
    # @param [String] table The table to delete records from.
    # @param [String] id The ID of the record to delete.
    # @raise [SurrealDB::Exception] If there is an issue with the request.
    def delete_one(table, id)
      _request("DELETE", "key/#{table}/#{id}")
    end
  end
end
