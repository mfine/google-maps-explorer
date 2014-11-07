require "./maps.rb"
require "./minimal_maps.rb"
require "json"
require "sinatra"

get "/:id" do
  content_type :json
  new_params = params.dup
  id, minimal, splat, captures = ["id", "minimal", "splat", "captures"].map do |p| 
    new_params.delete(p)
  end
  maps = minimal == "true" ? MinimalMaps.new : Maps.new
  JSON.pretty_generate maps.send(id, new_params)
end
