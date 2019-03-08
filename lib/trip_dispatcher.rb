require "csv"
require "time"

require_relative "driver"
# require_relative "passenger"
require_relative "trip"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: "./support")
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      if id.zero?
        return raise ArgumentError, "Invalid ID"
      end
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      Driver.validate_id(id)
      if id.zero?
        return raise ArgumentError, "Invalid ID"
      end
      return @drivers.find { |driver| driver.id == id }
    end

    # Returns list of drivers who are available and have never taken a ride.
    # Assigns to the first driver in that list
    # Otherwise assign to driver who has the least recent endtime
    def find_available_driver
      eligible_driver_list = @drivers.select { |driver| driver.status == :AVAILABLE && driver.last_end_time = nil }
      unless eligible_driver_list.empty?
        return eligible_driver_list.first
      end
      return @drivers.min_by { |driver| driver.last_end_time }
    end

    def request_trip(passenger_id)
      driver = find_available_driver
      passenger = find_passenger(passenger_id)
      driver.nil ? (return nil) : driver

      if passenger.id == driver.id
        raise ArgumentError.new
      end

      input = {
        id: @trips.length + 1,
        passenger: passenger,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil,
        driver: driver
      }
      trip = Trip.new(input)

      driver.accept_trip(trip)
      find_passenger(passenger_id).add_trip(trip)
      @trips << trip
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end
      trips
    end
  end
end
