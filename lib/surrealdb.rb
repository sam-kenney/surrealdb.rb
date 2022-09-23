require "surrealdb/version"

module SurrealDB
  class Error < StandardError; end
  # Your code goes here...
  autoload(:HTTPClient, "surrealdb/clients/http.rb")
  autoload(:SurrealError, "surrealdb/common/surreal_error.rb")
end
