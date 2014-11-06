require "./maps.rb"
require "json"
require "sinatra"

get "/:id" do
  content_type :json
  new_params = params.dup
  id, splat, captures = ["id", "splat", "captures"].map do |p| 
    new_params.delete(p)
  end
  JSON.pretty_generate Maps.new.send(id, new_params)
end
