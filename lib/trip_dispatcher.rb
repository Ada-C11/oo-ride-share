require "csv"
require "time"

require_relative "passenger"
require_relative "trip"
require_relative "driver"

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
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    def request_trip(passenger_id)
      trip_driver = ""
      # drivers.each do |driver|
      #   until driver.status == :AVAILABLE
      #     trip_driver = driver
      #   end
      # end
      available_drivers = []
      drivers.each do |driver|
        if driver.status == :AVAILABLE
          available_drivers << driver
        end
      end
      if available_drivers == []
        raise ArgumentError, "No available drivers"
      end

      available_drivers.each do |driver|
        times_array = []
        if driver.trips.length == 0
          trip_driver = driver
        end
      end

      if trip_driver == ""
        trip_driver = available_drivers.reduce(0) do |memo, driver|
          memo = (Time.now - driver.end_time) > memo ? (Time.now - driver.end_time) : memo
        end
      end
      # if trip_driver == ""
      #   raise ArgumentError, "No Available Drivers"
      # end
      start_time = Time.now
      end_time = nil
      cost = nil
      rating = nil
      trip = Trip.new(driver: trip_driver, start_time: start_time, end_time: end_time, cost: cost, rating: rating)
      trip_driver.start_trip(trip)
      passenger.add_trip(trip)
      add_trip(trip)

      return trip
    end

    def add_trip(trip)
      @trips << trip
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end

      return trips
    end
  end
end
