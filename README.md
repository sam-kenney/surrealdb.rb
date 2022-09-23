# SurrealDB
Ruby driver for SurrealDB databases.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'surrealdb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install surrealdb

## Usage

Included with this module are two Classes, `SurrealDB::HTTPClient` and `SurrealDB::SurrealError`, where `SurrealError` is raised for any errors that occur during the HTTP request.

### HTTPClient
Create a client with the following code:
```ruby
require "surrealdb"

SurrealDB::HTTPClient.new(
  "http://localhost:8000/",
  namespace: "test",
  database: "test",
  username: "root",
  password: "root"
) do |client|
  ...
end
```

> The following examples assume that the client is created as above.

#### `execute`
Execute a query. It takes a string as the table name to select from, and returns `Array<Hash>`.

```ruby
client.execute("SELECT * FROM test")
# => [{"id"=>1, "name"=>"test"}]

client.execute("DELETE test:1")
# => []
```

#### `select_all`
Retrieve all of the data from a table. Takes a string as the table name to select from. Returns `Array<Hash>`.

```ruby
client.select_all("test")
# => [{"id"=>1, "name"=>"test"}]
```

#### `select_one`
Retrieve one record from a table. Takes a string as as the table name to select from, and an id of any type. Returns `Hash`.
```ruby
client.select_one("test", 1)
# => {"id"=>1, "name"=>"test"}
```

#### `replace_one`
Replace a record in a table. Takes a string as the table name the record exists in, an id of any type, and a `Hash` of values to replace. Returns `Hash`.
```ruby
client.replace_one("test", 1, {name: "test2", title: "test"})
# => {"id"=>1, "name"=>"test2", "title"=>"test"}
```

#### `upsert_one`
Update values of a record in a table. Takes a string as the table name to update a record in, an id of any type, and a `Hash` of values to replace. Returns `Hash`.
```ruby
client.upsert_one("test", 1, {name: "test4"})
# => {"id"=>1, "name"=>"test4", "title"=>"test"}
```

#### `delete_all`
Delete all records from a table. Takes a string as the table name to delete records from. Returns `nil`.
```ruby
client.delete_all("test")
# => nil
```

#### `delete_one`
Delete a record from a table. Takes a string as the table name to delete a record from, and an id of any type. Returns `nil`.
```ruby
client.delete_one("test", 1)
# => nil
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/surrealdb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/surrealdb/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the Surrealdb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sam-kenney/surrealdb.rb/blob/main/CODE_OF_CONDUCT.md).
