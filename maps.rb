require "json"
require "rest_client"

class Maps
  attr_accessor :api, :key

  def initialize
    @api = RestClient::Resource.new "https://maps.googleapis.com/maps/api"
    @key = ENV['KEY'] || abort("KEY not defined")
  end

  def resources
    { 
      nearby:      ["place/nearbysearch/json", "results"],
      details:     ["place/details/json", "result"],
      directions:  ["directions/json", "routes"],
      geocode:     ["geocode/json", "results"],
    }
  end

  def request(resource, params)
    api[resource].get(params: params.merge(key: key)) do |response|
      JSON.parse(response).tap do |result|
        status = result.delete("status")
        raise status if status != "OK"
      end
    end
  end

  def method_missing(m, *args, &block)
    resource = resources[m]
    super unless resource
    request(resource.first, *args)[resource.last]
  end
end
