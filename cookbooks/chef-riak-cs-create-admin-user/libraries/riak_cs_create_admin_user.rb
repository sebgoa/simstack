require "net/http"
require "json"
require "uri"

module RiakCS
  USER_RESOURCE_PATH = "riak-cs/user"

  def self.create_admin_user(name, email, ipaddress, port)
    uri           = URI.parse("http://#{ipaddress}:#{port}/#{USER_RESOURCE_PATH}")
    request       = Net::HTTP::Post.new(uri.request_uri, "Content-Type" => "application/json")
    request.body  = {
      "email" => email,
      "name"  => name
    }.to_json
    response      = Net::HTTP.new(uri.host, uri.port).start { |http| http.request(request) }
    json          = JSON.parse(response.body)

    [ json["key_id"], json["key_secret"] ]
  end
end
