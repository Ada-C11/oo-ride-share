
module RideShare
  class Driver < User
    attr_reader :vin, :driven_trips

    def initialize(input)
      super(input)

      @status = input[:status]
      @status ||= :AVAILABLE
      @vin = input[:vin]
      @driven_trips = []

      raise ArgumentError, "Vin must be 17 characters long" if input[:vin].length != 17
      raise ArgumentError, "Status should be available or unavailable" unless [:AVAILABLE, :UNAVAILABLE].include? @status
    end

    def add_driven_trip(trip)
      driven_trips << trip
      [:passenger, :driver, :cost, :rating, :start_time, :end_time].each do |method|
        raise ArgumentError, "Invalid trip" unless trip.respond_to? method
      end
    end

    def average_rating
      total_ratings = driven_trips.reduce(0) do |total, trip|
        total + trip.rating
      end
      return total_ratings.to_f / driven_trips.length
    end
  end
end
