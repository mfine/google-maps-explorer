require "json"
require "rest_client"

class Maps
  attr_accessor :api, :key

  def initialize
    @api = RestClient::Resource.new "https://maps.googleapis.com/maps/api"
    @key = ENV['KEY'] || abort("KEY not defined")
  end

  def apis
    { 
      nearby: "place/nearbysearch/json",
      details: "place/details/json",
      directions: "directions/json",
      geocode: "geocode/json",
    }
  end

  def request(resource, params)
    api[apis[resource]].get(params: params.merge(key: key)) do |response|
      JSON.parse(response).tap do |result|
        status = result.delete("status")
        raise status if status != "OK"
      end
    end
  end

  def nearby(params)
    request(:nearby, params)["results"]
  end

  def details(params)
    request(:details, params)["result"]
  end

  def directions(params)
    request(:directions, params)["routes"]
  end

  def geocode(params)
    request(:geocode, params)["results"]
  end
end
