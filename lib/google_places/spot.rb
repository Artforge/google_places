module GooglePlaces
  class Spot
    attr_accessor :lat, :lng, :name, :icon, :reference, :vicinity, :types, :id, :formatted_phone_number, :formatted_address, :address_components, :rating, :url

    def self.list(lat, lng, api_key, options = {})
      request_radius = options.delete(:radius) || 200
      request_sensor = options.delete(:sensor) || false
      request_types  = options.delete(:types)
      request_name  = options.delete(:name)
      request_location = Location.new(lat, lng)

      options = {
        :location => request_location.format,
        :radius => request_radius,
        :sensor => request_sensor,
        :key => api_key,
        :name => request_name
      }

      # Accept Types as a string or array
      if request_types
        types = (types.is_a?(Array) ? request_types.join('|') : request_types)
        options.merge!(:types => request_types)
      end

      response = Request.spots(options)
      response['results'].map do |result|
        self.new(result)
      end
    end

    def self.find(reference, api_key, options = {})
      request_sensor = options.delete(:sensor) || false

      response = Request.spot(
        :reference => reference,
        :sensor => request_sensor,
        :key => api_key
      )

      self.new(response['result'])
    end

    def initialize(json_result_object)
      @reference              = json_result_object['reference']
      @vicinity               = json_result_object['vicinity']
      @lat                    = json_result_object['geometry']['location']['lat']
      @lng                    = json_result_object['geometry']['location']['lng']
      @name                   = json_result_object['name']
      @icon                   = json_result_object['icon']
      @types                  = json_result_object['types']
      @id                     = json_result_object['id']
      @formatted_phone_number = json_result_object['formatted_phone_number']
      @formatted_address      = json_result_object['formatted_address']
      @address_components     = json_result_object['address_components']
      @rating                 = json_result_object['rating']
      @url                    = json_result_object['url']
    end

  end
end
