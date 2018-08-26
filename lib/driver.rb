
module RideShare
  class Driver < RideShare::User
    attr_reader :vehicle_id, :driven_trips
    attr_accessor :status

    def initialize(input)
      super(input)

      @status = input[:status]
      @status ||= :AVAILABLE
      @vehicle_id = input[:vin]
      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

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
      total_ratings = driven_trips.select{ |trip| !trip.end_time.nil? }.reduce(0) do |total, trip|
        total + trip.rating
      end
      return completed_trips.zero? ? 0.0 : total_ratings.to_f / completed_trips
    end

    def net_expenditures
      return super - total_revenue
    end

    def completed_trips
      return driven_trips.reduce(0) do |total, trip|
        trip.end_time.nil? ? total : total + 1
      end
    end

    def total_revenue
      return @driven_trips.select{ |trip| !trip.end_time.nil? }.reduce(0.0) do |sum, trip|
        sum + (trip.cost - 1.65) * 0.8
      end
    end
  end
end
