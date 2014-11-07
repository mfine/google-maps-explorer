require "./maps.rb"

class MinimalMaps
  attr_accessor :api

  def initialize
    @api = Maps.new
  end

  def geocode(params)
    api.geocode(params).map do |result|
      {
        address: result['formatted_address'],
        location: result['geometry']['location'].values.join(","),
      }
    end
  end

  def directions(params)
    api.directions(params).map do |route|
      {
        bounds: {
          ne: route['bounds']['northeast'].values.join(","),
          sw: route['bounds']['southwest'].values.join(","),
        },
        legs: route['legs'].map do |leg|
          {
            distance: leg['distance'],
            duration: leg['duration'],
            end_address: leg['end_address'],
            end_location: leg['end_location'].values.join(","),
            start_address: leg['start_address'],
            start_location: leg['start_location'].values.join(","),
            steps: leg['steps'].map do |step|
              {
                distance: step['distance'],
                duration: step['duration'],
                end_location: step['end_location'].values.join(","),
                start_location: step['start_location'].values.join(","),
                html_instructions: step['html_instructions'],
                maneuver: step["straight"],
              }
            end,
          }
        end,
      }
    end
  end

  def nearby(params)
    api.nearby(params).map do |result|
      {
        location: result['geometry']['location'].values.join(","),
        name: result['name'],
        placeid: result['place_id'],
      }
    end
  end

  def details(params)
    api.details(params).tap do |result|
      break {
        address: result['formatted_address'],
        location: result['geometry']['location'].values.join(","),
        name: result['name'],
        reviews: result['reviews'].map do |review|
          {
            aspects: review['aspects'],
            rating: review['rating'],
            text: review['text'],
            time: review['time'],
          }
        end,
      }
    end
  end
end

