require "surrealdb"


SurrealDB::HTTPClient.new(
  "http://localhost:8000/",
  namespace: "test",
  database: "test",
  username: "root",
  password: "root"
) do |client|
  begin
    client.create_one("test", 4, { "name" => "test" })
    puts client.execute("SELECT * FROM test")
  rescue SurrealDB::SurrealError => e
    puts "Error: #{e.status} #{e.json}"
  end
end
