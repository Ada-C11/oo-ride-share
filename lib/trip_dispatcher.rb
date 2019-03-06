require "csv"
require "time"
require "driver"

require_relative "passenger"
require_relative "trip"

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(directory: "./support")
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
      # changed the order of @drivers and connect trip
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    # added raise argument for bad id
    def find_driver(id)
      Driver.validate_id(id)
      if id.zero?
        return raise ArgumentError, "Invalid ID"
      end
      return @drivers.find { |driver| driver.id == id }
    end

    # def find_available_driver
    #   @drivers.each do |driver|
    #     if driver.status == :AVAILABLE
    #       return driver
    #     end
    #   end
    #   return nil
    # end

    # def request_trip(passenger_id)
    #   driver = find_available_driver
    #   passenger = find_passenger(passenger_id)
    #   driver == nil ? (return nil) : driver

    #   if passenger.id == driver.id
    #     raise ArgumentError.new
    #   end

    #   input = {
    #     id: @trips.length + 1,
    #     passenger: passenger,
    #     start_time: Time.now,
    #     end_time: nil,
    #     cost: nil,
    #     rating: nil,
    #     driver: driver
    #   }
    #   trip = Trip.new(input)

    #   driver.accept_trip(trip)
    #   find_passenger(passenger_id).add_trip(trip)
    #   @trips << trip
    #   return trip
    # end

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
        # added second argument to trip.connect
      end
      return trips
    end
  end
end
